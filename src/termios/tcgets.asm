GLOBAL tcgets

SECTION .text
tcgets:
    PUSH rbp
    MOV rbp, rsp
    MOV rdx, rdi
    MOV rdi, 0
    MOV rsi, 0x5401
    MOV rax, 16
    SYSCALL
    MOV rsp, rbp
    POP rbp
    RET
