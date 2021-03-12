GLOBAL cfmkraw

SECTION .text
cfmkraw:
    PUSH rbp
    MOV rbp, rsp
    AND DWORD [rdi+0], -1516    ; ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON)
    AND DWORD [rdi+4], -2       ; ~OPOST
    AND DWORD [rdi+8], -305     ; ~(CSIZE | PARENB)
    OR  DWORD [rdi+8], 48       ; CS8
    AND DWORD [rdi+12], -32844  ; ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN)
    MOV rsp, rbp
    POP rbp
    RET
