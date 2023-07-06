#include <sys/idt.h>

static const char *DIV_BY_ZERO_MSG = "DIVIDE BY ZERO ERROR!";

__attribute__((interrupt)) void handle_div_by_zero(interrupt_frame_t *interrupt_frame)
{
    volatile unsigned short *vmem = (volatile unsigned short *) 0xB8000;

    uint64_t len = 0;
    while (DIV_BY_ZERO_MSG[len] != '\0') len++;

    for (uint64_t i = 0; i < len; i++)
    {
        vmem[i] = (0x04 << 8) | DIV_BY_ZERO_MSG[i];
    }

    interrupt_frame->eip++;
}

[[noreturn]] void _start()
{
    init_idt_32();
    set_idt_entry_32(0, handle_div_by_zero, 0x8F);

    while (1);
}