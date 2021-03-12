GLOBAL rngseed

SECTION .text
rngseed:
    PUSH rbp
    MOV rbp, rsp
    XOR rax, rax
    XOR rdx, rdx
    RDTSC
    MOV rsp, rbp
    POP rbp
    RET
