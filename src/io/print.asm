GLOBAL print

EXTERN strchr
EXTERN putstr
EXTERN putnbr
EXTERN putchar
EXTERN putnchar

SECTION .data
    TEXT: DQ 0
    ARG_N: DQ 0

SECTION .text
print:
    PUSH rbp
    MOV rbp, rsp
    ; Store ARGS
    PUSH rsi
    PUSH rdx
    PUSH rcx
    PUSH r8
    PUSH r9
    ; Store string in TEXT
    MOV rdx, TEXT
    MOV [rdx], rdi
    MOV rcx, ARG_N
    MOV QWORD [rcx], rbp
.L1:
    MOV rcx, ARG_N
    SUB QWORD [rcx], 8
    ; Find pos of the next %
    MOV rdx, TEXT
    MOV rdi, [rdx]
    MOV sil, 0x25
    CALL strchr
    CMP rax, 0
    JE .L5
    ; Find the size of the string before %
    MOV rdx, TEXT
    SUB rax, [rdx]
    ; Print the string with the size bellow
    MOV rsi, rax
    MOV rdx, TEXT
    MOV rdi, [rdx]
    CALL putnchar
    ; Get the format code(s, d, c)
    MOV rdx, TEXT
    INC rax
    ADD [rdx], rax
    MOV rdx, TEXT
    MOV rdi, [rdx]
    ; Print the formatted string
    MOV rcx, ARG_N
    CMP BYTE [rdi], 0x64
    JE .L2
    CMP BYTE [rdi], 0x63
    JE .L3
    CMP BYTE [rdi], 0x73
    JE .L4
    MOV rdi, 0x25
    CALL putchar
    JMP .L1
.L2:
    MOV rdi, [rcx]
    MOV rdi, [rdi]
    MOV rdx, TEXT
    ADD QWORD [rdx], 1
    CALL putnbr
    JMP .L1
.L3:
    MOV rdi, [rcx]
    MOV rdi, [rdi]
    MOV rdx, TEXT
    ADD QWORD [rdx], 1
    CALL putchar
    JMP .L1
.L4:
    MOV rdi, [rcx]
    MOV rdi, [rdi]
    MOV rdx, TEXT
    ADD QWORD [rdx], 1
    CALL putstr
    JMP .L1
.L5:
    ; Print the end of the string
    MOV rdx, TEXT
    MOV rdi, [rdx]
    CALL putstr
    POP r9
    POP r8
    POP rcx
    POP rdx
    POP rsi
    MOV rsp, rbp
    POP rbp
    RET
