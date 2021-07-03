.386
code segment use16
    assume cs:code, ds:code     
    old_int dw ?, ?             
    start:
        mov ax, code
        mov ds, ax

        mov ax, 3521h   ; 35号调用，取原有中断向量地址
        int 21h

        mov old_int, bx
        mov old_int + 2, es

        lea dx, new2int

        cli    ; 在装入中断向量表时要关中断，之后再开
        mov ax, 2521h   ; 25号调用，设置新地址
        int 21h
        sti

        mov dl, '1'     ; 结果需要输出2
        mov ah, 2
        int 21h

        mov ah, 4ch
        int 21h

    new2int proc far    ; 中断处理子程序要用far
        push dx
        push ax

        cmp ah, 2
        jne next
        add dl, 1

    next:
        pushf
        call dword ptr old_int

        pop ax
        pop dx
        iret
    new2int endp

code ends
end start
