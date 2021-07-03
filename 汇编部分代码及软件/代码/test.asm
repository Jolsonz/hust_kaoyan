.386
DATA SEGMENT USE16
INPUT DB 'Please input X(0~9):$'
TAB DW 0,1,8,27,64,125,216,343,512,729
X DB ?
XXX DW ?
INERR DB 0AH,0DH,'Input error! try again',0AH,0DH,'$'
DATA ENDS

STACK SEGMENT USE16 STACK
      DB 200 DUP(0);缓冲�?
STACK  ENDS

CODE   SEGMENT USE16
       ASSUME CS:CODE,DS:DATA,SS:STACK
BEGIN: MOV AX,DATA
       MOV DS,AX
NEXT:  LEA DX,INPUT
       MOV AH,9
       INT 21;输出Input
       MOV AH,1
       INT 21H;输入一个值到AL
       CMP AL,'0'
       JB ERR
       CMP AL,'9'
       JA ERR
       AND AL,0FH;这个操作有什么意义？不是AL不变么�?
       MOV X,AL
       XOR EBX,EBX
       MOV BL,AL
       MOV AX,TAB[EBX*2]
       MOV XXX,AX
EXIT:  MOV AH,4CH
       INT 21
ERR:   MOV DX,OFFSET INERR
       MOV AH,9
       INT 21H
       JMP NEXT
CODE   ENDS
       END BEGIN


