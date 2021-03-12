GLOBAL exit

SECTION .text
exit:
    PUSH rbp
    MOV rsp, rbp
    MOV rax, 60
    SYSCALL
    MOV rsp, rbp
    POP rbp
    RET
