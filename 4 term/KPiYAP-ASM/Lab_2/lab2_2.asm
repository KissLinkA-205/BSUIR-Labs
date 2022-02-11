.model small
.stack 100h

.data  
    
    size equ 200
    string db size dup ('$')
    slovo db size dup ('$')
    
    str1 db "Enter the string: $"
    str2 db "Entered string: $"
    str3 db "Enter the word: $"
    str4 db "Entered word: $"
    str5 db "Word not found!$"
    str6 db "String is empty$"
    str7 db "Word is empty$"
    str8 db "Word found!$"
    str9 db "It's the first word$"
    close db "End of work...",0Dh,0Ah,'$'
    result db "Result: $"
    enter db 0Dh,0Ah,'$'

.code

Output_string proc
    mov ah,9
    int 21h
    ret
Output_string endp

Output proc
    cmp bx[si], 0Dh
    Output_sumb bx[si]
    inc si
    cmp bx[si],0Dh
    jne call Output
    ret
endp

Output_sumb macro symb
    mov dl,symb
    mov ah,06h
    int 21h
endm
                
Input_string macro str
    lea dx,str
    mov offset str,size
    mov ah,0Ah
    int 21h
endm

Exit proc
    mov dx,offset enter
    call Output_string
    mov dx,offset result
    call Output_string
    mov bx,offset string
    mov si,2
    call Output
    mov dx,offset enter
    call Output_string
    mov dx,offset close
    call Output_string
    mov ax,4C00h
    int 21h
    ret
Exit endp

Empty_exit proc
    mov dx,offset enter
    call Output_string
    mov dx,offset close
    call Output_string
    mov ax,4C00h
    int 21h
    ret
Empty_exit endp

Counter proc
    inc ah
    ret
Counter endp

Moove proc
    dec si
    cmp si,offset string[1] 
    je call Counter
    cmp [si],' '
    jne call Check_is_tab
    cmp [si],09h
    jne call Check_is_space 
    ret
Moove endp

Check_is_space proc
    cmp [si],' '
    jne call Moove
    ret    
Check_is_space endp

Check_is_tab proc
    cmp [si],09h
    jne call Moove
    ret    
Check_is_tab endp

Moove_space proc
    dec si
    cmp si,offset string[1] 
    je call Counter
    cmp [si],' '
    je call Moove_space
    cmp [si],09h
    je call Moove_space
    ret
Moove_space endp

Delete proc 
    inc si
    mov dl,[si]
    dec si
    mov [si],dl
    inc si
    cmp [si],0Dh
    jne call Delete  
    mov si,bx
    cmp [si],' '
    jne call Check_2
    ret
Delete endp

Check_2 proc
    cmp [si],09h
    jne call Delete
    ret
Check_2 endp
                
start:  
    mov ax,@data
    mov ds,ax              
    mov dx,offset str1
    call Output_string
    Input_string string
    
    mov dx,offset enter
    call Output_string
    mov dx,offset str3
    call Output_string
    Input_string slovo
    
    cmp string[1],0
    je isEmpty
    
    mov dx,offset enter
    call Output_string
    mov dx,offset str2
    call Output_string
    mov bx,offset string
    mov si,2
    call Output
    
    cmp slovo[1],0
    je isEmpty
    
    mov dx,offset enter
    call Output_string
    mov dx,offset str4
    call Output_string
    mov bx,offset slovo
    mov si,2
    call Output
    
isEmpty:
    mov ah,[string[1]]
    cmp ah,0
    je String_is_empty
    mov ah,[slovo[1]]
    cmp ah,0
    je Slovo_is_empty
    jne Find
    
String_is_empty:
    Output_sumb 0Dh
    Output_sumb 0Ah
    mov dx,offset str6
    call Output_string
    call Empty_exit
    
Slovo_is_empty:
    Output_sumb 0Dh
    Output_sumb 0Ah
    mov dx,offset str7
    call Output_string
    call Empty_exit
    
Find:
    mov si,offset string[1]
    mov di,offset slovo[2]
    jmp Find_symbol

Find_symbol:
    inc si
    cmp [si],0Dh
    je notFound
    mov dl,[si]
    cmp [si],' '
    je Find_symbol
    cmp [si],09h
    je Find_symbol
    cmp dl,0Dh
    je call Exit
    cmp dl,[di]
    jne Skip_slovo
    jmp Find_slovo
loop Find_symbol
    
Skip_slovo:
    cmp [si],' '
    je Find_symbol
    cmp [si],09h
    je Find_symbol
    cmp [si],0Dh
    je notFound
    inc si
loop Skip_slovo     
    
Find_slovo:
    inc si
    inc di
    cmp [di],0Dh
    je isEnd
    mov dl,[si]
    cmp dl,[di]
    je loop Find_slovo
    jmp isStart 
    
isEnd:
    cmp [si],' '
    je Found
    cmp [si],09h
    je Found
    cmp [si],0Dh
    je Found
    
isStart:
    mov di,offset slovo[2]
    jmp Skip_slovo

notFound:
    mov dx,offset enter
    call Output_string
    mov dx,offset str5
    call Output_string
    call Exit
        
Found:
    inc si
    mov dx,offset enter
    call Output_string
    mov dx,offset str8
    call Output_string
    jmp Delete_slovo
    
Delete_slovo:
    mov ah,0
    call Moove_space
    call Moove
    cmp ah,1
    je call Exit
    call Moove_space
    cmp ah,1
    je call Exit
    call Moove
    mov bx,si
    call Delete
    call Exit
    
end start
