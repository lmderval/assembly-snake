GLOBAL _start

;; termios
EXTERN tcgets
EXTERN tcsets
EXTERN cfmkraw

;; io
EXTERN getchar
EXTERN print
EXTERN putchar

;; thread
EXTERN sleep
EXTERN thread_create

;; random
EXTERN random
EXTERN rngseed

;; sys
EXTERN exit

;; Grid dimension
WIDTH		EQU 30
HEIGHT		EQU 22

;; Data type size
TERMIOS_TYPE	EQU 60
VECTOR_2D_TYPE	EQU 8
; Snake type : size + head_pos + tail
SNAKE_TYPE	EQU 4 + WIDTH * HEIGHT * VECTOR_2D_TYPE

;; Direction
NORTH		EQU 0x01
SOUTH		EQU 0xFF
EAST		EQU 0x02
WEST		EQU 0xFE

;; Sleep duration
DELAY		EQU 100000000

;; Threads
STACK_SIZE	EQU (4096 * 1024)

SECTION .data
    ;; Print String
    PRINT_INFO:         DB "CHR:", 0x09, "%d", 0x09, "ESC:", 0x09, "%d", 0x09, "SEQ:", 0x09, "%d", 0x00
    PRINT_DIR:          DB "DIR:", 0x09, "%d", 0x00
    PRINT_ARROW:        DB "ARR:", 0x09, "%c", 0x00
    PRINT_SCORE:        DB "SCORE:", 0x09, "%d", 0x00
    PRINT_STOP:         DB "Press <enter> to exit the program.", 0x00
    ;; Escape codes
    SAVE_CURSOR:        DB 0x1B, "[s", 0x00
    RESTORE_CURSOR:     DB 0x1B, "[u", 0x00
    SHOW_CURSOR:        DB 0x1B, "[?25h", 0x00
    HIDE_CURSOR:        DB 0x1B, "[?25l", 0x00
    CURSOR_NL:          DB 0x1B, "[%dB", 0x00
    CURSOR_RIGHT:       DB 0x1B, "[%dC", 0x00
    CLEAR_FROM_CURSOR:  DB 0x1B, "[0K", 0x00
    ;; Snake graphics
    BLANK_SPACE:        DB "  ", 0x00
    SNAKE_HEAD:         DB 0x1B, "[48;5;32m  ", 0x1B, "[0m", 0x00
    SNAKE_BODY:         DB 0x1B, "[48;5;178m  ", 0x1B, "[0m", 0x00
    FRUIT:              DB 0x1B, "[38;5;178m<>", 0x1B, "[0m", 0x00
    ;; Game objects
    SNAKE               TIMES SNAKE_TYPE        DB 0x00
    FRUIT_POS:          TIMES VECTOR_2D_TYPE    DB 0x00
    DIR:                DB EAST
    SCORE:              DD 0x00000000
    ;; Termios config
    T_ORIG:             TIMES TERMIOS_TYPE      DB 0x00
    T_NEW:              TIMES TERMIOS_TYPE      DB 0x00
    ;; Input
    CHR:                DB 0x00
    ESC_ON:             DB 0x00
    SEQ_ON:             DB 0x00
    ;; Iterators
    IT_I:               DD 0x00000000
    IT_J:               DD 0x00000000
    ;; Program
    RNG_SEED:           DD 0x00000000
    STOP:               DB 0x000
    KILL:               DB 0x00

SECTION .text
_start:
    CALL rngseed
    MOV DWORD [RNG_SEED], eax
    LEA rdi, [T_ORIG]
    CALL tcgets
    LEA rdi, [T_NEW]
    CALL tcgets
    LEA rdi, [T_NEW]
    CALL cfmkraw
    LEA rdi, [T_NEW]
    CALL tcsets
    LEA rdi, [SNAKE]
    MOV esi, 0
    MOV edx, 0
    CALL init_snake
    LEA rdi, [RNG_SEED]
    MOV rsi, WIDTH
    CALL random
    MOV DWORD [FRUIT_POS], eax
    LEA rdi, [RNG_SEED]
    MOV rsi, HEIGHT
    CALL random
    MOV DWORD [FRUIT_POS + 4], eax
    CALL hide_cursor
    CALL save_cursor_pos
    LEA rdi, [thread_read]
    MOV rsi, STACK_SIZE
    CALL thread_create
.for_init_01:
    MOV DWORD [IT_J], 0x00000000
.for_cond_01:
    MOV eax, HEIGHT
    CMP DWORD [IT_J], eax
    JGE .for_end_01
.for_loop_01:
    MOV rdi, 0x0A
    CALL putchar
.for_inc_01:
    INC DWORD [IT_J]
    JMP .for_cond_01
.for_end_01:
    LEA rdi, [SNAKE]
    CALL draw_snake
.while_01:
    CMP BYTE [STOP], 0x01
    JE .while_end_01
    LEA rdx, [SNAKE]
    MOV eax, DWORD [rdx]
    MOV edi, DWORD [rdx + 4 + rax * 8]
    IMUL edi, 2
    MOV esi, DWORD [rdx + 4 + rax * 8 + 4]
    CALL move_cursor
    LEA rdi, [BLANK_SPACE]
    CALL print
    MOV edi, WIDTH
    IMUL edi, 2
    INC edi
    MOV esi, 0
    CALL move_cursor
    LEA rdi, [CLEAR_FROM_CURSOR]
    CALL print
.if_01:
    CMP BYTE [SEQ_ON], 0x01
    JNE .else_01
    CMP BYTE [CHR], 0x41
    JL .else_01
    CMP BYTE [CHR], 0x44
    JG .else_01
    LEA rdi, [PRINT_ARROW]
    MOV sil, BYTE [CHR]
    CALL print
.switch_01:
    MOV dl, BYTE [CHR]
    CMP dl, 0x41
    JE .switch_01_case_01
    CMP dl, 0x42
    JE .switch_01_case_02
    CMP dl, 0x43
    JE .switch_01_case_03
    CMP dl, 0x44
    JE .switch_01_case_04
    JMP .switch_end_01
.switch_01_case_01:
.if_03:
    MOV dl, BYTE [DIR]
    ADD dl, NORTH
    CMP dl, 0x00
    JE .if_end_03
    MOV BYTE [DIR], NORTH
.if_end_03:
    JMP .switch_end_01
.switch_01_case_02:
.if_04:
    MOV dl, BYTE [DIR]
    ADD dl, SOUTH
    CMP dl, 0x00
    JE .if_end_04
    MOV BYTE [DIR], SOUTH
.if_end_04:
    JMP .switch_end_01
.switch_01_case_03:
.if_05:
    MOV dl, BYTE [DIR]
    ADD dl, EAST
    CMP dl, 0x00
    JE .if_end_05
    MOV BYTE [DIR], EAST
.if_end_05:
    JMP .switch_end_01
.switch_01_case_04:
.if_06:
    MOV dl, BYTE [DIR]
    ADD dl, WEST
    CMP dl, 0x00
    JE .if_end_06
    MOV BYTE [DIR], WEST
.if_end_06:
.switch_end_01:
    JMP .if_end_01
.else_01:
    LEA rdi, [PRINT_INFO]
    MOV sil, BYTE [CHR]
    XOR rdx, rdx
    MOV dl, BYTE [ESC_ON]
    XOR rcx, rcx
    MOV cl, BYTE [SEQ_ON]
    CALL print
.if_end_01:
    LEA rdi, [SNAKE]
    MOV sil, [DIR]
    CALL move_snake
    LEA rdi, [SNAKE]
    CALL eat_tail
.if_12:
    CMP eax, 0x00000001
    JNE .if_end_12
    MOV BYTE [STOP], 0x01
.if_end_12:
.if_11:
    MOV edx, DWORD [FRUIT_POS]
    CMP DWORD [SNAKE + 4], edx
    JNE .if_end_11
    MOV edx, DWORD [FRUIT_POS + 4]
    CMP DWORD [SNAKE + 4 + 4], edx
    JNE .if_end_11
    ADD DWORD [SCORE], 10
    LEA rdi, [SNAKE]
    CALL grow_up
    LEA rdi, [RNG_SEED]
    MOV rsi, WIDTH
    CALL random
    MOV DWORD [FRUIT_POS], eax
    LEA rdi, [RNG_SEED]
    MOV rsi, HEIGHT
    CALL random
    MOV DWORD [FRUIT_POS + 4], eax
.if_end_11:
    MOV edi, WIDTH
    IMUL edi, 2
    INC edi
    MOV esi, 1
    CALL move_cursor
    LEA rdi, [CLEAR_FROM_CURSOR]
    CALL print
    MOV rdi, PRINT_DIR
    LEA rdi, [PRINT_DIR]
    XOR rsi, rsi
    MOV sil, BYTE [DIR]
    CALL print
    MOV edi, WIDTH
    IMUL edi, 2
    INC edi
    MOV esi, 2
    CALL move_cursor
    LEA rdi, [CLEAR_FROM_CURSOR]
    CALL print
    LEA rdi, [PRINT_SCORE]
    XOR rsi, rsi
    MOV esi, DWORD [SCORE]
    CALL print
    MOV edi, DWORD [FRUIT_POS]
    IMUL edi, 2
    MOV esi, DWORD [FRUIT_POS + 4]
    CALL move_cursor
    LEA rdi, [FRUIT]
    CALL print
    LEA rdi, [SNAKE]
    CALL draw_snake
    MOV BYTE [CHR], 0x00
    MOV BYTE [ESC_ON], 0x00
    MOV BYTE [SEQ_ON], 0x00
    MOV rdi, DELAY
    CALL sleep
    JMP .while_01
.while_end_01:
    MOV edi, 0
    MOV esi, HEIGHT
    CALL move_cursor
.if_13:
    CMP BYTE [KILL], 0x01
    JE .if_end_13
    LEA rdi, [PRINT_STOP]
    CALL print
    MOV edi, 0
    MOV esi, HEIGHT
    CALL move_cursor
.if_end_13:
.while_02:
    CMP BYTE [KILL], 0x01
    JE .while_end_02
    MOV rdi, DELAY
    CALL sleep
    JMP .while_02
.while_end_02:
    MOV edi, 0
    MOV esi, HEIGHT
    CALL move_cursor
    CALL show_cursor
    LEA rdi, [T_ORIG]
    CALL tcsets
    MOV rdi, 0
    CALL exit

thread_read:
    LEA rdi, [CHR]
    CALL getchar
    CMP BYTE [CHR], 0x03
    JE .kill
    CMP BYTE [CHR], 0x0D
    JE .stop
    CMP BYTE [STOP], 0x01
    JE .stop
.if_01:
    CMP BYTE [CHR], 0x1B
    JNE .if_end_01
    MOV BYTE [ESC_ON], 0x01
    LEA rdi, [CHR]
    CALL getchar
.if_02:
    CMP BYTE [CHR], 0x5B
    JNE .if_end_02
    MOV BYTE [SEQ_ON], 0x01
    LEA rdi, [CHR]
    CALL getchar
.if_end_02:
.if_end_01:
    JMP thread_read
.stop:
    CMP BYTE [STOP], 0x01
    JE .kill
    MOV BYTE [STOP], 0x01
    JMP thread_read
.kill:
    MOV BYTE [STOP], 0x01
    MOV BYTE [KILL], 0x01
    MOV rdi, 0
    CALL exit

; void init_vector_2d(vector_2d *vec, int x, int y)
init_vector_2d:
    MOV DWORD [rdi], esi
    MOV DWORD [rdi + 4], edx
    RET

; void init_snake(snake *snk, int x, int y)
init_snake:
    MOV DWORD [rdi], 0x00000000
    ADD rdi, 4
    CALL init_vector_2d
    RET

; void move_snake(snake *snk, char dir)
move_snake:
.for_init_01:
    MOV eax, DWORD [rdi]
    MOV DWORD [IT_J], eax
.for_cond_01:
    CMP DWORD [IT_J], 0x00000000
    JLE .for_end_01
.for_loop_01:
    MOV eax, DWORD [IT_J]
    MOV rcx, QWORD [rdi + 4 + (rax - 1) * 8]
    MOV QWORD [rdi + 4 + rax * 8], rcx
.for_inc_01:
    DEC DWORD [IT_J]
    JMP .for_cond_01
.for_end_01:
.switch_01:
    CMP sil, NORTH
    JE .switch_01_case_01
    CMP sil, SOUTH
    JE .switch_01_case_02
    CMP sil, EAST
    JE .switch_01_case_03
    CMP sil, WEST
    JE .switch_01_case_04
    JMP .switch_end_01
.switch_01_case_01:
.if_01:
    CMP DWORD [rdi + 4 + 4], 0x00000000
    JLE .else_01
    DEC DWORD [rdi + 4 + 4]
    JMP .if_end_01
.else_01:
    MOV edx, HEIGHT
    DEC edx
    MOV DWORD [rdi + 4 + 4], edx
.if_end_01:
    JMP .switch_end_01
.switch_01_case_02:
.if_02:
    MOV edx, HEIGHT
    DEC edx
    CMP DWORD [rdi + 4 + 4], edx
    JGE .else_02
    INC DWORD [rdi + 4 + 4]
    JMP .if_end_02
.else_02:
    MOV DWORD [rdi + 4 + 4], 0x00000000
.if_end_02:
    JMP .switch_end_01
.switch_01_case_03:
.if_03:
    MOV edx, WIDTH
    DEC edx
    CMP DWORD [rdi + 4], edx
    JGE .else_03
    INC DWORD [rdi + 4]
    JMP .if_end_03
.else_03:
    MOV WORD [rdi + 4], 0x00000000
.if_end_03:
    JMP .switch_end_01
.switch_01_case_04:
.if_04:
    CMP DWORD [rdi + 4], 0x00000000
    JLE .else_04
    DEC DWORD [rdi + 4]
    JMP .if_end_04
.else_04:
    MOV edx, WIDTH
    DEC edx
    MOV DWORD [rdi + 4], edx
.if_end_04:
    JMP .switch_end_01
.switch_end_01:
    RET

; void grow_up(snake *snk)
grow_up:
    PUSH rbp
    MOV rbp, rsp
    MOV esi, DWORD [rdi + 4 + rax * 8]
    MOV edx, DWORD [rdi + 4 + rax * 8 + 4]
    INC DWORD [rdi]
    MOV eax, DWORD [rdi]
    LEA rdi, [rdi + 4 + rax * 8]
    CALL init_vector_2d
    MOV rsp, rbp
    POP rbp
    RET

; int eat_tail(snake *snk)
eat_tail:
    PUSH rbp
    MOV rbp, rsp
    XOR eax, eax
.for_init_01:
    MOV DWORD [IT_J], 0x00000001
.for_cond_01:
    MOV ecx, DWORD [rdi]
    CMP DWORD [IT_J], ecx
    JG .for_end_01
.for_loop_01:
    MOV ecx, DWORD [IT_J]
    MOV rdx, QWORD [rdi + 4 + rcx * 8]
.if_01:
    CMP QWORD [rdi + 4], rdx
    JNE .if_end_01
    INC eax
    JMP .for_end_01
.if_end_01:
.for_inc_01:
    INC DWORD [IT_J]
    JMP .for_cond_01
.for_end_01:
    MOV rsp, rbp
    POP rbp
    RET

; void draw_snake(snake *snk)
draw_snake:
    PUSH rbp
    MOV rbp, rsp
    PUSH rdi
.for_init_01:
    MOV DWORD [IT_J], 0x00000001
.for_cond_01:
    MOV rdi, QWORD [rbp - 8]
    MOV eax, DWORD [rdi]
    CMP DWORD [IT_J], eax
    JG .for_end_01
.for_loop_01:
    MOV rdx, rdi
    MOV eax, DWORD [IT_J]
    MOV edi, DWORD [rdx + 4 + rax * 8]
    IMUL edi, 2
    MOV esi, DWORD [rdx + 4 + rax * 8 + 4]
    CALL move_cursor
    LEA rdi, [SNAKE_BODY]
    CALL print
.for_inc_01:
    INC DWORD [IT_J]
    JMP .for_cond_01
.for_end_01:
    MOV rdx, rdi
    MOV edi, DWORD [rdx + 4]
    IMUL edi, 2
    MOV esi, DWORD [rdx + 4 + 4]
    CALL move_cursor
    LEA rdi, [SNAKE_HEAD]
    CALL print
    MOV rsp, rbp
    POP rbp
    RET

save_cursor_pos:
    PUSH rbp
    MOV rbp, rsp
    LEA rdi, [SAVE_CURSOR]
    CALL print
    MOV rsp, rbp
    POP rbp
    RET

restore_cursor_pos:
    PUSH rbp
    MOV rbp, rsp
    LEA rdi, [RESTORE_CURSOR]
    CALL print
    MOV rsp, rbp
    POP rbp
    RET

show_cursor:
    PUSH rbp
    MOV rbp, rsp
    LEA rdi, [SHOW_CURSOR]
    CALL print
    MOV rsp, rbp
    POP rbp
    RET

hide_cursor:
    PUSH rbp
    MOV rbp, rsp
    LEA rdi, [HIDE_CURSOR]
    CALL print
    MOV rsp, rbp
    POP rbp
    RET

move_cursor:
    PUSH rbp
    MOV rbp, rsp
    SHL rdi, 32
    ADD rdi, rsi
    PUSH rdi
    CALL restore_cursor_pos
.if_01:
    CMP DWORD [rbp - 8], 0x00000000
    JLE .if_end_01
    LEA rdi, [CURSOR_NL]
    MOV esi, DWORD [rbp - 8]
    CALL print
.if_end_01:
.if_02:
    CMP DWORD [rbp - 4], 0x00000000
    JLE .if_end_02
    LEA rdi, [CURSOR_RIGHT]
    MOV esi, DWORD [rbp - 4]
    CALL print
.if_end_02:
    POP rdi
    MOV rsp, rbp
    POP rbp
    RET
