; Randoseru v0.1.0
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Main file for the first stage of Randoseru.
;
; This stage main function is to load the second
; stage into memory and transfer control to it.
;
BITS 16
ORG 0x7C00

JMP SHORT _entry
NOP

_entry:
    JMP _start

; Includes
%include "disk.asm"
%include "puts.asm"

; Data
BOOT_DRIVE: DB 0
MSG_EXT_CHECK: DB "DSK/EXT/CHK", 0
MSG_EXT_READ: DB "DSK/EXT/RD", 0

DAP:
    DB 0x10
    DB 0
    DB 0x02     ; 1KiB
    DB 0x0
    DW 0x7E00
    DW 0
    DD 1
    DD 0

_start:
    XOR AX, AX
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX
    MOV GS, AX
    MOV SS, AX

    MOV AX, 0x7C00
    MOV BP, AX
    MOV SP, BP

    ; Check for BIOS INT13 extensions.
    MOV [BOOT_DRIVE], BL
    CALL disk_ext_check
    OR AL, AL
    JNZ .err_ext_check

    ; Read the disk using the extensions.
    MOV SI, DAP
    CALL disk_ext_read
    OR AL, AL
    JNZ .err_ext_read

    ; Transfer control to the next stage.
    JMP 0x7E00
    JMP .halt

.err_ext_check:
    MOV SI, MSG_EXT_CHECK
    CALL puts
    JMP .halt

.err_ext_read:
    MOV SI, MSG_EXT_READ
    CALL puts
    JMP .halt

.halt:
    CLI
    HLT
    JMP SHORT .halt

TIMES 510 - ($ - $$) DB 0
DW 0xAA55
