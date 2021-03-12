GLOBAL putstr
EXTERN strlen
EXTERN putnchar

SECTION .text
putstr:
    PUSH rbp
    MOV rbp, rsp
    PUSH rdi
    CALL strlen
    POP rdi
    MOV rsi, rax
    CALL putnchar
    MOV rsp, rbp
    POP rbp
    RET
