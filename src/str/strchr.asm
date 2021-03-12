GLOBAL strchr

SECTION .text
strchr:
    PUSH rbp
    MOV rbp, rsp
    XOR rax, rax
.L1:
    CMP BYTE [rdi], 0
    JE .L3
        CMP BYTE [rdi], sil
        JE .L2
            INC rdi
            JMP .L1
.L2:
    MOV rax, rdi
.L3:
    MOV rsp, rbp
    POP rbp
    RET
