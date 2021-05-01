.model small
.stack 100h
.data
    max_path_size equ 124 
    mathematical_expression db max_path_size dup(0)
    PSP dw ? 
    EPB dw ?
        dw 0
    ten dw 10
    sign dw ?
    minus dw -1
    current_element dw ? 
    string_size equ 10
    string db string_size dup('$')
    min_num equ 32768
    max_num equ 32767
    start_of_stack_numbers equ 0F926h 
    start_of_stack_operations equ 9C40h
    stack_of_numbers dw 0F926h
    stack_of_operations dw 9C40h 
    result db "Result: ",'$'
    message_overflow db "Overflow!",'$'
    message_mathematical_expression db "Mathematical expression: ", '$'
    message_wrong_input db "Wrong input!",'$'
    wrong_args db "Wrong args", 0Dh, 0Ah
               db "Correct format:", 0Dh, 0Ah
               db "[program] ",'"',"mathematical expression",'"', 0Dh, 0Ah, '$'     
    program_over db "Program is over...",0Dh,0Ah,'$'   
    enter db 0Dh,0Ah,'$'
    previous_operation dw ?
    run_adr dw 0
    run_seg dw ?
    pathAdd db "ADD.exe", 0
    pathSub db "SUB.exe", 0
    pathMul db "MUL.exe", 0
    pathDiv db "DIV.exe", 0
             
.code
    jmp start
     
ExecOverlay macro
    call dword ptr run_adr
ExecOverlay endm

LoadOverlay macro overlayPath
    push dx
    push bx
    push ax

    lea dx, overlayPath
    lea bx, EPB 
    mov ax, 4B03h 
    int 21h

    pop ax
    pop bx
    pop dx
LoadOverlay endm

Exit proc
    outputString program_over
    
    mov ax,4C00h
    int 21h
    ret
Exit endp
    
OutputString macro str
    mov ah, 09h
    mov dx, offset str
    int 21h
OutputString endm

Output proc      
Output_loop:
    lodsb
    cmp al, 0
    je Output_end
    mov ah, 02h
    mov dl, al
    int 21h
    jmp Output_loop  
        
Output_end:
    ret
Output endp

OutputWrongInput proc
    OutputString message_wrong_input
    OutputString enter
    call Exit
OutputWrongInput endp

OutputOverflow proc
    OutputString message_overflow
    OutputString enter
    call Exit
OutputOverflow endp

OutputNumber proc
Outp: 
    inc di
    mov dx,0
    
    push ds
    mov bx,es
    pop es
    mov ds,bx
    
    div ten 
    jo OutputOverflow
    
    push ds
    mov bx,es
    pop es
    mov ds,bx
    
    add dx,'0'
    push dx
    cmp ax,0
    jne Outp
    
    cmp sign,-1
    jne Output_num
    Output_sumb '-'
Output_num:
    pop ax
    Output_sumb ax
    dec di
    cmp di,0
jg loop Output_num
    
    OutputString enter
    call Exit
    
    ret
OutputNumber endp

Negative_sign proc
    mov sign,-1
    
    push ds
    mov bx,es
    pop es
    mov ds,bx
    
    mul minus
    
    push ds
    mov bx,es
    pop es
    mov ds,bx
    
    mov di,0
    call OutputNumber
    
    ret
Negative_sign endp

Positive_sign proc
    mov sign,1
    
    mov di,0
    call OutputNumber
    
    ret
Positive_sign endp

Output_sumb macro symb                                                                                                      
    mov dx,symb
    mov ah,06h
    int 21h
Output_sumb endm

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
    
    mov di, offset mathematical_expression
    call getWord
    jc parseCommandLine_error

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

getWord proc; si - source, di - dest, cx - size; output: si is modified, cx is modified
    push bx
    push ax
    push di
    push ds

    mov ax, PSP
    mov ds, ax

    mov bx, di
    mov di, si
    cmp byte ptr [di], '"'
    je Get_word_no_spaces   
    mov al, ' '
    repe scasb        
    
Get_word_no_spaces:
    scasb
    mov si, di
    mov di, bx
    cmp cx, 0
    je Get_word_error

Get_word_space_loop:
    lodsb
    cmp al, '"'
    je Get_word_space
    cmp al, '0'
    jl Check_expression
    cmp al, '9'
    jg Check_expression
    jmp Check_expression_end
    
Check_expression:
    cmp al, '+'
    je Check_expression_end
    cmp al, '-'
    je Check_expression_end
    cmp al, '/'
    je Check_expression_end
    cmp al, '*'
    je Check_expression_end
    cmp al, ' '
    je Check_expression_end
    
Check_expression_error:
    pop ds
    pop di
    pop ax
    pop bx
    
    call OutputWrongInput
    
Check_expression_end:
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

Check_num proc
    mov si,offset string
    cmp [si],'-' 
    je Negative_num
    mov bx,0
    mov sign,1
    call ConvertNumber
    ret
Negative_num:
    mov sign,-1
    inc si
    mov bx,0
    call ConvertNumber 
    ret
Check_num endp

ConvertNumber proc
    mov ax,ten
    mul bx
    mov bx,ax
    push bx
    mov ax,0
    mov al,[si]
    sub ax,'0'
    pop bx
    add bx,ax
    inc si
    cmp [si],'$'
    jne call ConvertNumber
    mov ax,bx
    
    cmp sign,-1
    je min_point
    jne max_point
    
max_point:    
    cmp ax,max_num
    ja OutputWrongInput
    jmp point
    
min_point:
    cmp ax,min_num
    ja OutputWrongInput
    
point:    
    mul sign
    mov current_element,ax
    ret
ConvertNumber endp

CalculateExpression proc
    mov si, offset mathematical_expression
    dec si
    
FindNumber:
    mov di, offset string 
    mov cx,10 
    
ClearString:
    cmp cx,0
    je FindNumber_continue
    mov [di],'$'
    dec cx
    inc di
    jmp ClearString

FindNumber_continue:
    mov di, offset string 
    
FindNumber_skipSpaces:
    inc si
    cmp si, ' '
    je FindNumber_skipSpaces
    
FindNumber_afterSpaces:
    cmp [si], '-'
    jne FindNumber_onlyNumer
    movsb

FindNumber_onlyNumer:
    cmp [si], ' '
    je FindNumber_end
    cmp [si], '$'
    je FindNumber_end 
    cmp [si], 0
    je FindNumber_end   
    cmp [si], '0'
    jl OutputWrongInput
    cmp [si], '9'
    jg OutputWrongInput
    
    movsb
    jmp FindNumber_onlyNumer 
    
FindNumber_end:
    mov di, offset string
    cmp [di], '$'    
    je CalculateExpression_end
    
    push si
    call Check_num
    call NumberToStack
    pop si       
    
FindOperation:
    dec si
   
FindOperation_skipSpaces:
    inc si
    cmp [si], ' '
    je FindOperation_skipSpaces
    
FindOperation_afterSpaces:
    cmp [si], '*'
    je FindOperation_noError
    cmp [si], '/'
    je FindOperation_noError
    cmp [si], '+'
    je FindOperation_noError
    cmp [si], '-'
    je FindOperation_noError
    cmp [si], 0
    je CalculateExpression_end
    
FindOperation_error:
    call OutputWrongInput
   
FindOperation_noError:
    inc si
    cmp [si], ' '
    je FindOperation_addToStask
    jne FindOperation_error
    
FindOperation_addToStask:
    dec si

CheckPriority:    
    mov bx, [si]
    cmp [stack_of_operations], start_of_stack_operations
    je FindOperation_addToStackWithoutChanges
        
    mov bx, ax
    call GetOperationFromStack
    call OperationToStack   
    call GetPriority
    
    mov ax, dx
    push ax
    mov ax, [si]
    call getPriority
    pop ax   
    cmp ax, dx
    jb FindOperation_addToStackWithoutChanges    
    call GetOperationFromStack
    mov dx, ax
    call GetNumberFromStack
    mov cx, ax
    call GetNumberFromStack
    
    mov dh,0
    cmp dx, '+'
    jne FindOperation_sub
    
    cmp previous_operation, dx
    je withoutchange_add
    LoadOverlay pathAdd
Withoutchange_add:
    ExecOverlay
    mov previous_operation, dx
    jmp FindOperation_endOp
     
FindOperation_sub:
    cmp dx, '-'
    jne FindOperation_mul 
    cmp previous_operation, dx
    je Withoutchange_sub
    LoadOverlay pathSub
Withoutchange_sub:
    ExecOverlay
    mov previous_operation, dx
    jmp FindOperation_endOp
    
FindOperation_mul:
    cmp dx, '*'
    jne FindOperation_div
    cmp previous_operation, dx
    je withoutchange_mul
    LoadOverlay pathMul
withoutchange_mul:
    ExecOverlay 
    mov previous_operation, dx
    jmp FindOperation_endOp
    
FindOperation_div:
    cmp previous_operation, dx
    je withoutchange_div   
    LoadOverlay pathDiv
Withoutchange_div: 
    xor dx, dx
    ExecOverlay 
    mov previous_operation, dx
        
FindOperation_endOp:
        
    call numberToStack
    jmp CheckPriority        
    
FindOperation_addToStackWithoutChanges:
    mov ax,[si]
    call OperationToStack   
    inc si 

    jmp FindNumber    
    
CalculateExpression_end:
    ret
CalculateExpression endp

NumberToStack proc
    push dx
    
    mov dx, sp
    mov sp, [stack_of_numbers]
    push ax
    mov [stack_of_numbers], sp
    mov sp, dx
    
    pop dx
    ret
NumberToStack endp

OperationToStack proc
    push dx
    
    mov dx, sp
    mov sp, [stack_of_operations]
    push ax
    mov [stack_of_operations], sp
    mov sp, dx
    
    pop dx
    ret
    ret
OperationToStack endp

GetNumberFromStack proc  ;output: ax - number
    push dx
    
    mov dx, sp
    mov sp, [stack_of_numbers]
    pop ax
    mov [stack_of_numbers], sp
    mov sp, dx
    
    pop dx  
    ret
GetNumberFromStack endp

GetOperationFromStack proc
    push dx
    
    mov dx, sp
    mov sp, [stack_of_operations]
    pop ax
    mov [stack_of_operations], sp
    mov sp, dx
    
    pop dx  
    ret
GetOperationFromStack endp 

GetPriority proc
    mov ah,0 
    cmp ax, '+'
    jne substr
    mov dx, 1
    jmp toEnd
substr:
    cmp ax, '-'
    jne multipl
    mov dx, 1
    jmp toEnd
multipl:
    cmp ax, '*'
    jne division
    mov dx, 3
    jmp toEnd
division:
    cmp ax, '/'
    mov dx, 3
toEnd:
    ret 
GetPriority endp
    
start:
    push ds
    mov	ax,@data                      
    mov	ds,ax 
    pop PSP
   
    mov ax, progEnd
    mov dx, es
    sub ax, dx
    mov bx, ax 
    mov ah, 4Ah
    int 21h        
     
    mov ah, 48h  
    mov bx, 1000h      
    int 21h     
     
    mov EPB, ax  
    mov EPB+2, ax 
    mov run_seg, ax 
    mov ax, ds
    mov es, ax

    mov ax, @data
    mov ds, ax
    mov es, ax
    
    call parseCommandLine
    jc Error_wrong_args
    
    outputString message_mathematical_expression
    mov si,offset mathematical_expression
    call Output  
    outputString enter
    
    call CalculateExpression
    
Final_loop:
    cmp [stack_of_operations], start_of_stack_operations
    je Final_end
    
    call GetOperationFromStack
    mov dx, ax
    call GetNumberFromStack
    mov cx, ax
    call GetNumberFromStack
    
    mov dh,0
    cmp dx, '+'
    jne FinalSub
    
    cmp previous_operation, dx
    je FinalWithoutChange_add
    LoadOverlay pathAdd  
    
FinalWithoutChange_add:
    ExecOverlay
    mov previous_operation, dx
    
    jmp Final_complete
    
FinalSub:
    cmp dx, '-'
    jne FinalMul
    
    cmp previous_operation, dx
    je FinalWithoutChange_sub
    LoadOverlay pathSub  
    
FinalWithoutChange_sub:
    ExecOverlay
    mov previous_operation, dx
    
    jmp Final_complete
    
FinalMul:
    cmp dx, '*'
    jne FinalDiv
    
    cmp previous_operation, dx
    je FinalWithoutChange_mul
    LoadOverlay pathMul  
    
FinalWithoutChange_mul:
    ExecOverlay
    mov previous_operation, dx
    
    jmp Final_complete
    
FinalDiv:
    cmp previous_operation, dx
    je FinalWithoutChange_div   
    LoadOverlay pathDiv
FinalWithoutChange_div:
    xor dx, dx
    ExecOverlay
    mov previous_operation, dx
    
Final_complete:
    
    call NumberToStack
    jmp Final_loop  
    
Final_end: 
    push ax
    OutputString result 
    pop ax   
    cmp ax,0
    js Negative_sign
    jns Positive_sign 
    
    OutputString enter
    
    jmp _end
    
Error_wrong_args:
    outputString wrong_args
    jmp _end

_end:    
    call Exit

progEnd segment
progEnd ends    
end start    