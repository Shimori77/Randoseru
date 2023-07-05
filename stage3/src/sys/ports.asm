BITS 32

SECTION .text
GLOBAL outb:function (outb.end - outb)
GLOBAL inb:function (inb.end - inb)

; Outputs a byte to a CPU 16-bit port.
outb:
    PUSH EBP
    MOV EBP, ESP

    MOV DX, [EBP + 8]
    MOV AL, [EBP + 12]

    OUT DX, AL

    POP EBP
    RET
.end:

; Reads a byte from a CPU 16-bit port.
inb:
    PUSH EBP
    MOV EBP, ESP

    MOV DX, [EBP + 8]
    IN AL, DX

    POP EBP
    RET
.end:
