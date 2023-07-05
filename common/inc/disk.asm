; Randoseru v0.1.0
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Routines for reading data from the disk
; either in LBA mode using the Enhanced Disk Drive specification.
;
; Meant to be used in 16-bit Real Mode.
;

; Check if the BIOS Enhanced Disk Drive features are installed
; in the BIOS.
;
; Returns on success:
;   AX = 0
;
; Returns on failure:
;   AL = 1
;   AH = Error Code
;
disk_ext_check:
    PUSH BX
    PUSH CX

    MOV AH, 0x41
    MOV BX, 0x55AA
    INT 0x13
    JC SHORT .error

    XOR AX, AX
    JMP SHORT .exit
.error:
    MOV AL, 1
.exit:
    POP CX
    POP BX
    RET

; Read the disk using BIOS EDD feature.
;
; Returns on success:
;   AX = 0
;
; Returns on failure:
;   AL = 1
;   AH = Error Code
;
disk_ext_read:
    XOR AX, AX
    MOV AH, 0x42
    INT 0x13
    JC SHORT .error

    XOR AX, AX
    JMP SHORT .exit
.error:
    MOV AL, 1
.exit:
    RET
