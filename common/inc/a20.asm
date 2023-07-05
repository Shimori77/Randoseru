; Randoseru v0.1.0
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Routines for verifying and dealing with the state
; of the A20 line.
;
; Meant to be used in 16-bit Real Mode.
;

; Check if BIOS INT15 contains A20 extensions installed.
;
; Returns on success:
;   AX = 0
;
; Returns on failure:
;   AL = 1
;   AH = Error Code
;
a20_ext_check:
    MOV AX, 0x2403
    INT 0x15
    JC  SHORT .err_ns

    XOR AX, AX
    JMP SHORT .exit
.err_ns:
    MOV AL, 1
.exit:
    RET

; Retrieve the status of A20 line using INT15 extensions.
;
; Returns on success:
;   AL = 0
;   AH = Status (1 = Enabled, 0 = Disabled)
;
; Returns on error:
;   AL = 1
;   AH = Error Code
;
a20_ext_status:
    PUSH CX

    MOV AX, 0x2402
    INT 0x15
    JC  SHORT .err

    MOV AH, AL
    XOR AL, AL
    JMP SHORT .exit
.err:
    MOV AL, 1
.exit:
    POP CX
    RET

; Enables the A20 Line using INT15 extensions.
;
a20_ext_enable:
    MOV AX, 0x2401
    INT 0x15
    JC  SHORT .err

    XOR AX, AX
    JMP SHORT .exit
.err:
    MOV AL, 1
.exit:
    RET
