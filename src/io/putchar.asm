GLOBAL putchar

SECTION .text
putchar:
    PUSH rbp
    MOV rbp, rsp
    PUSH rdi
    MOV rdi, 1
    MOV rsi, rsp
    MOV rdx, 1
    MOV rax, 1
    SYSCALL
    MOV rsp, rbp
    POP rbp
    RET
