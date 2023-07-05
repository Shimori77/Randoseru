BITS 32

SECTION .text
ALIGN 4
EXTERN _start
GLOBAL _entry:function (_entry.end - _entry)
_entry:
    ; Setup the new stack
    MOV EAX, stack_top
    MOV EBP, EAX
    MOV ESP, EBP

    ; Call the C entry point
    MOV EAX, 0x02
    PUSH EAX
    MOV EAX, 'Y'
    PUSH EAX
    CALL _start

    ; Should not reach here!
    CLI
    HLT
    JMP $
.end:

SECTION .bss
ALIGN 16
stack_bottom:
    RESB 16384
stack_top:
