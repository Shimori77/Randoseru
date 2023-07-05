; Randoseru v0.1.0
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Main file for the second stage of Randoseru.
;
; This stage function is to load the third stage into memory,
; switch to 32-bit protected mode, reallocate the third stage
; into memory and then transfer control to it.
;
BITS 16
ORG 0x7E00

JMP _start

%include "puts.asm"
%include "disk.asm"
%include "a20.asm"
%include "gdt.asm"

ERR_A20_EXT_CHK: DB "ERR/A20/EXT/CHK", 0
ERR_A20_EXT_ST: DB "ERR/A20/EXT/ST", 0
ERR_A20_EXT_ENB: DB "ERR/A20/EXT/ENB", 0
ERR_A20_SYS_ENB: DB "ERR/A20/SYS/ENB", 0
ERR_DSK_EXT_RD: DB "ERR/DSK/EXT/RD", 0

DAP:
    DB 0x10
    DB 0
    DB 0x1D     ; 14.5 KiB
    DB 0x0
    DW 0x8200
    DW 0
    DD 3
    DD 0

_start:
    ; Check if extension is present.
    CALL a20_ext_check
    OR  AX, AX
    JNZ .err_a20_ext_check

    ; If present, get status. If enabled, skip enablement.
    CALL a20_ext_status
    OR AL, AL
    JNZ .err_a20_ext_status

    CMP AH, 1
    JE  SHORT .a20_enabled

    ; If not enabled, enable it.
    CALL a20_ext_enable
    OR AX, AX
    JNZ .err_a20_ext_enable

    ; Test again, if still disabled. Faults!
    CALL a20_ext_status
    OR AL, AL
    JNZ .err_a20_ext_status

    CMP AH, 1
    JNE .err_a20_sys_enable
    ; Success, A20 enabled.
.a20_enabled:
    ; Reads next 14.5 KiB into memory
    MOV SI, DAP
    CALL disk_ext_read
    OR AL, AL
    JNZ .err_ext_read

    ; Switch to 32-bit protected mode
    CLI
    LGDT [gdtr]
    MOV EAX, CR0
    OR AL, 1
    MOV CR0, EAX

    ; Jump to code reallocation routine
    JMP 0x08:realloc
.err_a20_ext_check:
    MOV SI, ERR_A20_EXT_CHK
    CALL puts
    JMP .halt

.err_a20_ext_status:
    MOV SI, ERR_A20_EXT_ST
    CALL puts
    JMP .halt

.err_a20_ext_enable:
    MOV SI, ERR_A20_EXT_ENB
    CALL puts
    JMP .halt

.err_a20_sys_enable:
    MOV SI, ERR_A20_SYS_ENB
    CALL puts
    JMP .halt

.err_ext_read:
    MOV SI, ERR_DSK_EXT_RD
    CALL puts
    JMP .halt

.halt:
    CLI
    HLT
    JMP SHORT .halt

BITS 32
realloc:
    MOV EAX, 0x10
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX
    MOV GS, AX
    MOV SS, AX

    ; Temporary stack, will be replaced on third stage.
    MOV EBP, 0x00080000
    MOV ESP, EBP

    CLD
    MOV ECX, 0x3A00
    MOV ESI, 0x8200
    MOV EDI, 0x00100000
    REP MOVSB

    ; Transfer control to third stage.
    JMP 0x00100000

TIMES 1024 - ($ - $$) DB 0
