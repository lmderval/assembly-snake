GLOBAL strlen

SECTION .text
strlen:
    PUSH rbp
    MOV rbp, rsp
    MOV rcx, 0
.L1:
    MOV dl, [rdi]
    CMP dl, 0
    JE .L2
        INC rdi
        INC rcx
        JMP .L1
.L2:
    MOV rax, rcx
    MOV rsp, rbp
    POP rbp
    RET
