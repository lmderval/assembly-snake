GLOBAL putnchar

SECTION .text
putnchar:
    PUSH rbp
    MOV rbp, rsp
    MOV rdx, rsi
    MOV rsi, rdi
    MOV rdi, 1
    MOV rax, 1
    SYSCALL
    MOV rsp, rbp
    POP rbp
    RET
