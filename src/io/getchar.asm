GLOBAL getchar

SECTION .text
getchar:
    PUSH rbp
    MOV rbp, rsp
    MOV rsi, rdi
    MOV rdi, 1
    MOV rdx, 1
    MOV rax, 0
    SYSCALL
    MOV rsp, rbp
    POP rbp
    RET
