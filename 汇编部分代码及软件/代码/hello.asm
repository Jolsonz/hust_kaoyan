data segment
out1 db 'Hello world$'
out2 db 'My name is DJX$'
data ends

code segment
assume cs:code; ds:data
start:
mov ax,data
mov ds,ax

lea dx,out1
mov ah,9
int 21h

mov dl,0ah
mov ah,2
int 21h
mov dl,0dh
mov ah,2
int 21h

lea dx,out2
mov ah,9
int 21h

mov ah,4ch
int 21h
code ends
end start 