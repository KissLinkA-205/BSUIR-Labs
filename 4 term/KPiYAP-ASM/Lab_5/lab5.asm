.model small
.stack 100h
.data
    max_path_size           equ 124
    file_path               db max_path_size dup (0)
    old_word                 db max_path_size dup (0)
    new_word                 db max_path_size dup (0)
    buffer                     db ?
    PSP                     dw ?
    old_size                db ?
    new_size                db ?
    EOF                     db ?
    message_old_word         db "replased word: ", '$'
    message_new_word         db "replacement word: ", '$'
    message_file_path       db "filename: ", '$'
    wrong_args              db "Wrong args", 0Dh, 0Ah
                            db "Correct format:", 0Dh, 0Ah
                            db "filepath arg1 arg2", 0Dh, 0Ah, '$'
    unidentifyed_error      db "unidentified error", 0Dh, 0Ah, '$'
    file_not_found          db "file not found", 0Dh, 0Ah, '$'
    path_not_found          db "path not found", 0Dh, 0Ah, '$'
    too_many_open_files     db "too many open files", 0Dh, 0Ah, '$'
    access_denied           db "access denied", 0Dh, 0Ah, '$'
    invalid_handle          db "invalid handle", 0Dh, 0Ah, '$'
    access_code_invalid     db "access code invalid", 0Dh, 0Ah, '$'
    program_over db "Program is over...",0Dh,0Ah,'$'
    file_processed db "File processed",0Dh,0Ah,'$'   
    enter db 0Dh,0Ah,'$'
.code
    jmp start 
    
Exit proc
    outputString program_over
    
    mov ax,4C00h
    int 21h
    ret
Exit endp

checkSize macro str
    push cx
    mov di, offset str
    call strLength
    cmp cx, 0
    je parseCommandLine_error
    pop cx
checkSize endm

parseCommandLine proc
    push si
    push di
    push ax
    push cx

    mov ah, 62h
    int 21h
    mov PSP, bx

    push ds

    mov ds, bx
    xor ah, ah
    mov al, byte ptr ds:[80h]
    pop ds
    cmp al, 0
    je parseCommandLine_error

    xor ch, ch
    mov cl, al
    mov si, 81h
    
    mov di, offset file_path
    call getWord
    jc parseCommandLine_error

    checkSize file_path
    
    mov di, offset old_word
    call getWord
    jc parseCommandLine_error

    checkSize old_word
    
    mov di, offset new_word
    call getWord
    jc parseCommandLine_error

    checkSize new_word

    call checkIfEnded
    jnc parseCommandLine_error

parseCommandLine_fine:
    clc
    jmp parseCommandLine_end

parseCommandLine_error:
    stc
    jmp parseCommandLine_end

parseCommandLine_end:
    pop cx
    pop ax
    pop di
    pop si
    ret
parseCommandLine endp

checkIfEnded proc; si - source, cx - size
    push si
    push di
    push ax
    push cx

    mov di, si
    mov al, ' '
    repe scasb
    cmp cx, 0
    je CheckIfEnded_error

CheckIfEnded_fine:
    clc
    jmp CheckIfEnded_end

CheckIfEnded_error:
    stc
    jmp CheckIfEnded_end

CheckIfEnded_end:
    pop cx
    pop ax
    pop di
    pop si
    ret
checkIfEnded endp

getWord proc; si - source, di - dest, cx - size; output: si is modified, cx is modified
    push bx
    push ax
    push di
    push ds

    mov ax, PSP
    mov ds, ax

    mov bx, di
    mov di, si
    cmp byte ptr [di], ' '
    jne Get_word_no_spaces   
    mov al, ' '
    repe scasb       
    
Get_word_no_spaces:
    mov si, di
    mov di, bx
    cmp cx, 0
    je Get_word_error

Get_word_space_loop:
    lodsb
    cmp al, ' '
    je Get_word_space
    stosb
loop Get_word_space_loop

    jmp Get_word_fine

Get_word_space:
    dec cx
    jmp Get_word_fine

Get_word_fine:
    clc
    jmp Get_word_end

Get_word_error:
    stc
    jmp Get_word_end

Get_word_end:
    pop ds
    pop di
    pop ax
    pop bx
    ret
getWord endp

replaceAllWords proc; bx - file descr           
    push di
    push cx

    mov di, offset old_word
    call strLength
    mov old_size, cl

    mov di, offset new_word
    call strLength
    mov new_size, cl

    xor cx, cx
    mov EOF, 0
    mov di, offset old_word 
    
    call checkIfWord
    jnc replaceAllWords_no          
    call replaceWord
    
replaceAllWords_loop:
    call skipSpaces
    call checkIfWord
    jnc replaceAllWords_no          
    call replaceWord            
jmp replaceAllWords_loop
    
replaceAllWords_no:
    call skipWord
    cmp EOF, 1
    je replaceAllWords_end
    call pointToNext
    jmp replaceAllWords_loop
                         
replaceAllWords_end:
    pop cx
    pop di
    ret
replaceAllWords endp

replaceWord proc; bx - file descr        
    push ax
    push cx
    push dx
    push si
    
    mov dx, bx
    mov al, old_size
    mov ah, new_size
    call minLength
    xor ch, ch
    mov cl, bl
    mov bx, dx

    mov si, offset new_word
    mov dx, offset buffer
    
replaceWord_min_loop:
    lodsb
    push cx
    mov ah, 40h
    mov cx, 1
    mov buffer, al
    int 21h
    pop cx
loop replaceWord_min_loop

    mov al, old_size
    cmp al, new_size
    je replaceWord_end
    ja replaceWord_truncate

replaceWord_extend:
    call insertInFile
    jmp replaceWord_end

replaceWord_truncate:
    push bx
    mov bh, old_size
    mov bl, new_size
    sub bh, bl
    xor ch, ch
    mov cl, bh
    pop bx
    call deleteFromFile

replaceWord_end:
    pop si
    pop dx
    pop cx
    pop ax
    ret
replaceWord endp

pos_high    dw ?
pos_low     dw ?

insertInFile proc; bx - file descr, si - str      
    push ax
    push dx
    push cx
    push di
    
    mov di, si
    call strLength
    mov di, cx
    dec di

    mov ah, 42h; save original pos
    mov al, 01h
    xor cx, cx
    xor dx, dx
    int 21h

    mov pos_high, dx; dx:ax - original pos
    mov pos_low, ax

    mov ah, 42h
    mov al, 02h
    xor cx, cx
    xor dx, dx
    int 21h

insertInFile_loop:
    mov ah, 42h; save current pos (mass[i])
    mov al, 01h
    xor cx, cx
    xor dx, dx
    int 21h
    push ax
    push dx

    mov ah, 3Fh
    mov cx, 1
    mov dx, offset buffer
    int 21h

    mov ah, 42h; lseek to (mass[i + n])
    mov al, 01h
    xor cx, cx
    mov dx, di
    int 21h

    mov ah, 40h
    mov cx, 1
    mov dx, offset buffer
    int 21h

    mov ah, 42h; restore current pos (mass[i])
    mov al, 00h
    pop cx
    pop dx
    int 21h

    cmp dx, pos_high
    jne insertInFile_loop_continue
    cmp ax, pos_low
    jne insertInFile_loop_continue
    jmp insertInFile_extended
       
insertInFile_loop_continue:
    mov ah, 42h;    (mass[i - 1])
    mov al, 01h
    mov cx, 0FFFFh
    mov dx, -1
    int 21h

    jmp insertInFile_loop

insertInFile_extended:
    mov ah, 42h; restore original pos
    mov al, 00h
    mov cx, pos_high
    mov dx, pos_low
    int 21h
    mov dx, offset buffer
    
insertInFile_insert_loop:
    lodsb
    cmp al, 0
    je insertInFile_end
    mov ah, 40h
    mov cx, 1
    mov buffer, al
    int 21h
    jmp insertInFile_insert_loop

insertInFile_end:
    pop di
    pop cx
    pop dx
    pop ax
    ret

insertInFile endp

deleteFromFile proc; bx - file descr, cx - size     
    push ax
    push dx
    push cx
    push di

    mov di, cx

    mov ah, 42h; save original pos
    mov al, 01h
    xor cx, cx
    xor dx, dx
    int 21h

    mov pos_high, dx; dx:ax - original
    mov pos_low, ax

deleteFromFile_loop:
    mov ah, 42h; save current pos (mass[i])
    mov al, 01h
    xor cx, cx
    xor dx, dx
    int 21h
    push ax
    push dx

    mov ah, 42h; lseek to mass[i + n]
    mov al, 01h
    xor cx, cx
    mov dx, di
    int 21h

    mov ah, 3Fh; read char
    mov cx, 1
    mov dx, offset buffer
    int 21h

    cmp ax, 0
    je deleteFromFile_eof   
    
    mov ah, 42h; restore current pos
    mov al, 00h
    pop cx
    pop dx
    int 21h

    mov ah, 40h; write char
    mov cx, 1
    mov dx, offset buffer
    int 21h

    jmp deleteFromFile_loop

deleteFromFile_eof:
    mov ah, 42h; restore current pos
    mov al, 00h
    pop cx
    pop dx
    int 21h

    mov ah, 40h; truncate file
    mov cx, 0
    mov dx, offset buffer
    int 21h

deleteFromFile_end:
    mov ah, 42h; restore original pos
    mov al, 00h    
    mov cx, pos_high
    mov dx, pos_low
    int 21h

    pop di
    pop cx
    pop dx
    pop ax
    ret
deleteFromFile endp

minLength proc; al - a, ah - b; output: bl - min      
    cmp al, ah
    jae minLength_end
    mov bl, al
    ret
    
minLength_end:
    mov bl, ah
    ret
minLength endp

pointToNext proc; bx - file descr             
    push ax
    push cx
    push dx  
    
    mov ah, 42h 
    mov al, 01h
    xor cx, cx
    mov dx, 1
    int 21h  
    
    pop dx
    pop cx
    pop ax
    ret
pointToNext endp   

skipSpaces proc
    push ax
    push cx
    push dx 

skipSpaces_loop:
     mov ah, 3Fh
    mov cx, 1
    mov dx, offset buffer
    int 21h
    
    cmp ax, 0 
    je skipSpaces_eof
    
    cmp buffer,' '
    je skipSpaces_loop  
    cmp buffer,09h
    je skipSpaces_loop
    cmp buffer,'.'
    je skipSpaces_loop 
    cmp buffer,','
    je skipSpaces_loop
    cmp buffer,'!'
    je skipSpaces_loop
    cmp buffer,'?'
    je skipSpaces_loop
    cmp buffer,';'
    je skipSpaces_loop
    cmp buffer,0Dh
    je skipSpaces_loop
    cmp buffer,0Ah
    je skipSpaces_loop
    
    jmp skipSpaces_end 
        
skipSpaces_eof:
    mov EOF, 1
    
skipSpaces_end: 
    mov ah, 42h;    (mass[i - 1])
    mov al, 01h
    mov cx, 0FFFFh
    mov dx, -1
    int 21h
       
    pop dx
    pop cx
    pop ax
    ret
skipSpaces endp

skipWord proc  
    push ax
    push cx
    push dx

skipWord_loop:    
    mov ah, 3Fh
    mov cx, 1
    mov dx, offset buffer
    int 21h
    
    cmp ax, 0 
    je skipWord_eof
    
    cmp buffer,' '
    je skipWord_end  
    cmp buffer,09h
    je skipWord_end
    cmp buffer,'.'
    je skipWord_end 
    cmp buffer,','
    je skipWord_end
    cmp buffer,'!'
    je skipWord_end
    cmp buffer,'?'
    je skipWord_end
    cmp buffer,';'
    je skipWord_end
    cmp buffer,0Dh
    je skipWord_end
    cmp buffer,0Ah
    je skipWord_end
    
    jmp skipWord_loop 
    
skipWord_eof:
    mov EOF, 1
    
skipWord_end:
    mov ah, 42h;    (mass[i - 1])
    mov al, 01h
    mov cx, 0FFFFh
    mov dx, -1
    int 21h  
              
    pop dx
    pop cx
    pop ax
    ret        
skipWord endp

checkIfWord proc; bx - file descr, di - str; output: cf set if str    
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov si, di

    mov ah, 42h
    mov al, 01h
    xor cx, cx
    xor dx, dx
    int 21h
    push ax
    push dx

checkIfWord_loop:
    lodsb
    cmp al, 0
    je checkIfWord_yes
    mov di, ax

    mov ah, 3Fh
    mov cx, 1
    mov dx, offset buffer
    int 21h
    cmp ax, 0
    je checkIfWord_eof
    mov ax, di
    cmp al, buffer
    jne checkIfWord_no
    jmp checkIfWord_loop
        
checkIfWord_eof:
    mov EOF, 1
    jmp checkIfWord_no

checkIfWord_yes:
    mov ah, 3Fh
    mov cx, 1
    mov dx, offset buffer
    int 21h
    
    cmp ax, 0 
    je Found
    cmp buffer,' '
    je Found  
    cmp buffer,09h
    je Found
    cmp buffer,'.'
    je Found 
    cmp buffer,','
    je Found
    cmp buffer,'!'
    je Found
    cmp buffer,'?'
    je Found
    cmp buffer,';'
    je Found
    cmp buffer,0Dh
    je Found
    cmp buffer,0Ah
    je Found
    
    jmp checkIfWord_no
Found:
    mov ah, 42h
    mov al, 00h
    pop cx
    pop dx
    int 21h
    stc
    jmp checkIfWord_end

checkIfWord_no:
    mov ah, 42h
    mov al, 00h
    pop cx
    pop dx
    int 21h
    clc
    jmp checkIfWord_end

checkIfWord_end:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
checkIfWord endp

output proc      
output_loop:
    lodsb
    cmp al, 0
    je Output_end
    mov ah, 02h
    mov dl, al
    int 21h
    jmp Output_loop  
        
output_end:
    ret
output endp

outputString macro str
    mov ah, 09h
    mov dx, offset str
    int 21h
outputString endm

strLength proc; di - str; output: cx - length     
    push si
    push ax
    mov si, di
    xor cx, cx

strLength_loop:
    lodsb
    cmp al, 0
    je strLength_end
    inc cx
jmp strLength_loop
    
strLength_end:
    pop ax
    pop si
    ret
strLength endp

start:
    mov ax, @data
    mov ds, ax
    mov es, ax

    call parseCommandLine
    jc Error_wrong_args

    outputString message_file_path
    mov si,offset file_path
    call output  
    outputString enter
    
    outputString message_old_word 
    mov si,offset old_word
    call output
    outputString enter      
    
    outputString message_new_word 
    mov si,offset new_word
    call output 
    outputString enter

    mov ah, 3Dh
    mov al, 0010010b
    mov dx, offset file_path
    int 21h
    jc Error_file
    mov bx, ax

    call replaceAllWords
    mov ah, 3Eh
    int 21h
    jc Error_file

    jmp _end

Error_wrong_args:
    outputString wrong_args
    jmp _end

Error_file:
    cmp ax, 02h
    je Error_file_not_found
    
    cmp ax, 03h
    je Error_path_not_found 
    
    cmp ax, 04h
    je Error_too_many_open_files 
    
    cmp ax, 05h
    je Error_access_denied      
    
    cmp ax, 0Ch
    je Error_access_code_invalid 
    
    outputString unidentifyed_error
    jmp _end

Error_file_not_found:
    outputString file_not_found
    jmp _end      
    
Error_path_not_found:
    outputString path_not_found
    jmp _end             
    
Error_too_many_open_files:
    outputString too_many_open_files
    jmp _end 
    
Error_access_denied:
    outputString access_denied
    jmp _end

Error_access_code_invalid:
    outputString access_code_invalid
    jmp _end 

_end: 
    outputString file_processed
    call Exit
    
end start