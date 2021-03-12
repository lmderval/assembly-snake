GLOBAL putnbr

EXTERN putchar

SECTION .text
putnbr:
    PUSH rbp
    MOV rbp, rsp
    CMP edi, 0
    JGE .L1
        PUSH rdi
        MOV rdi, '-'
	    CALL putchar
        POP rdi
        IMUL edi, edi, -1
.L1:
    CMP edi, 10
    JL .L2
        MOV eax, edi
        CDQ
        MOV ecx, 10
        IDIV ecx
        MOV edi, eax
        PUSH rdx
        CALL putnbr
        POP rdx
        MOV edi, edx
        ADD rdi, 48
        CALL putchar
        JMP .L3
.L2:
    ADD rdi, 48
    CALL putchar
.L3:
    MOV rsp, rbp
    POP rbp
    RET
