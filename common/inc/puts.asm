; Randoseru v0.1.0
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Routines for printing messages into the screen
; using BIOS VGA commands.
;
; Meant to be used in 16-bit Real Mode.
;

;
; Prints a string to the screen using BIOS INT10.
;
; Parameters:
;   SI - Char buffer pointer
;
puts:
    PUSH AX
    PUSH SI

    MOV AH, 0x0E
.loop:
    LODSB
    OR AL, AL
    JZ SHORT .end

    INT 0x10
    JMP SHORT .loop
.end:
    POP SI
    POP AX
    RET
