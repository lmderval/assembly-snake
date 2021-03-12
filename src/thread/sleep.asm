GLOBAL sleep

SECTION .data
    REQ:    TIMES 16 DB 0x00
    REM:    TIMES 16 DB 0x00

SECTION .text
sleep:
    MOV rax, rdi
    MOV ecx, 1000000000
    XOR rdx, rdx
    IDIV ecx
    MOV QWORD [REQ], rax
    MOV QWORD [REQ + 8], rdx
    MOV rax, 0x23
    MOV rdi, REQ
    MOV rsi, REM
    SYSCALL
    RET
