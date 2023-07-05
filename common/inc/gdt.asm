; Randoseru v0.1.0
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; This file contains the GDTR and a flat GDT for 32-bit
; protected mode.
;

gdtr:
    DW gdt.end - gdt
    DD gdt

gdt:
.null_desc:
    DD 0
    DD 0
.code_desc_32:
    DW 0xFFFF
    DW 0
    DB 0
    DB 0b10011010
    DB 0b11001111
    DB 0
.data_desc_32:
    DW 0xFFFF
    DW 0
    DB 0
    DB 0b10010010
    DB 0b11001111
    DB 0
.end:
