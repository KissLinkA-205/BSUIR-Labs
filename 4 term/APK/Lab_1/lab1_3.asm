.model small
.stack 100h

.data

Error_Write db "Write error!",0Dh,0Ah,'$'
Error_Read db "Read error!",0Dh,0Ah,'$'
Information db "Byte sent: $"
Data_Byte db 'A'
Data_Byte2 db ?
           
.code
           
Init_COM1 proc
    mov al,80h
    mov dx,3FBh
    out dx,al
    
    mov dx,3F8h
    mov al,00h
    out dx,al
    mov al,0Ch
    mov dx,3F9h
    out dx,al
    
    mov dx,3FCh
    mov al,00001011b
    out dx,al
    
    mov dx,3F9h
    mov al,0
    out dx,al
    ret
Init_COM1 endp

IsWrite_COM1 proc
    xor al,al
    mov dx,3FDh
    in al,dx
    test al,10h
    jnz NoWRite
    ret
IsWrite_COM1 endp

NoWRite proc
   mov ah,9
   mov dx,offset Error_Write
   int 21h
   ret 
NoWRite endp

IsRead_COM2 proc
    xor al,al
    mov dx,3FDh
    in al,dx
    test al,10b
    jnz NoRead
    ret
IsRead_COM2 endp

NoRead proc
   mov ah,9
   mov dx,offset Error_Read
   int 21h
   ret 
NoRead endp

Send_Byte proc
    mov dx,3F8h
    mov al,Data_Byte
    out dx,al
    ret
Send_Byte endp

Read_Byte proc
    mov dx,3F8h
    in al,dx
    mov Data_Byte2,al
    ret
Read_Byte endp

Exit proc
    mov ax,4C00h
    int 21h
    ret
Exit endp

start:
    mov ax,@data
    mov ds,ax
    call Init_COM1
    call IsWrite_COM1
    call Send_Byte
    mov al,2 
    call IsRead_COM2
    call Read_Byte
    mov dx,offset Information
    mov ah,9
    int 21h
    mov ah,02h
    mov dl,Data_Byte2
    int 21h 
    call Exit
   
end start