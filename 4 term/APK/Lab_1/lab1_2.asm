.model small
.stack 100h

.data

Error_Write db "Write error!",0Dh,0Ah,'$'
Error_Read db "Read error!",0Dh,0Ah,'$'
Information db "Byte sent: $"
           
.code

jmp start

Init_COM1 proc
   xor ax,ax
   mov al,10100011b
   mov dx,0
   int 14h
   ret            
Init_COM1 endp

IsWrite_COM1 proc
   mov al,'A'
   mov ah,1
   mov dx,0
   int 14h
   test al,80h
   jnz NoWRite
   ret 
IsWrite_COM1 endp

NoWRite proc
   mov ah,9
   mov dx,offset Error_Write
   add dx,2
   int 21h
   ret 
NoWRite endp

IsRead_COM2 proc
    mov ah,2
    mov dx,1
    int 14h
    test al,80h
    jnz NoRead
    ret
IsRead_COM2 endp

NoRead proc
   mov ah,9
   mov dx,offset Error_Read
   add dx,2
   int 21h
   ret 
NoRead endp

Output proc
   mov ah,02h
   mov dl,al
   int 21h
   ret
Output endp

Exit proc
    mov ax,4C00h
    int 21h
    ret
Exit endp

start:
   call Init_COM1
   call IsWrite_COM1
   mov al,'e'
   call IsRead_COM2
   ;push ax
   
   ;mov ah,9
   ;mov dx,offset Information
   ;add dx,2
   ;int 21h
           
   ;pop ax        
   call Output
   call Exit

end start