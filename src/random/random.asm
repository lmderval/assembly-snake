GLOBAL random

EXTERN rngseed
EXTERN putnbr

SECTION .data
    RND_BOUND:  DD 0x00000000
    PTR_SEED:   DQ 0x0000000000000000

SECTION .text
random:
    PUSH rbp
    MOV rbp, rsp
    MOV [RND_BOUND], rsi
    MOV [PTR_SEED], rdi
    MOV rax, [PTR_SEED]
    MOV rax, [rax]
    ADD rax, 12
    MOV rdx, 1103515245
    IMUL rdx
    SHR rax, 16
    MOV rdx, rax
    MOV rax, [PTR_SEED]
    MOV DWORD [rax], edx
    XOR rax, rax
    MOV eax, edx
    XOR rdx, rdx
    IDIV DWORD [RND_BOUND]
    MOV rax, rdx
    MOV rsp, rbp
    POP rbp
    RET
