.386
code segment use16
    assume cs:code, ds:code     
    old_int dw ?, ?             
    start:
        mov ax, code
        mov ds, ax

        mov ax, 3521h   ; 35�ŵ��ã�ȡԭ���ж�������ַ
        int 21h

        mov old_int, bx
        mov old_int + 2, es

        lea dx, new2int

        cli    ; ��װ���ж�������ʱҪ���жϣ�֮���ٿ�
        mov ax, 2521h   ; 25�ŵ��ã������µ�ַ
        int 21h
        sti

        mov dl, '1'     ; �����Ҫ���2
        mov ah, 2
        int 21h

        mov ah, 4ch
        int 21h

    new2int proc far    ; �жϴ����ӳ���Ҫ��far
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
