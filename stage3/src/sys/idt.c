#include <sys/idt.h>

__attribute__((interrupt)) void default_exception_handler(interrupt_frame_t *interrupt_frame)
{
    volatile unsigned short *vmem = (volatile unsigned short *) 0xB8000;
    vmem[0] = (0x04 << 8) | '~';
}

__attribute__((interrupt)) void default_exception_handler_ec(interrupt_frame_t *interrupt_frame, uint32_t error_code)
{
    volatile unsigned short *vmem = (volatile unsigned short *) 0xB8000;
    vmem[0] = (0x04 << 8) | '+';
}

__attribute__((interrupt)) void default_isr(interrupt_frame_t *interrupt_frame)
{
    volatile unsigned short *vmem = (volatile unsigned short *) 0xB8000;
    vmem[0] = (0x04 << 8) | '&';
}

void set_idt_entry_32(uint8_t entry_number, void *isr, uint8_t flags)
{
    idt_entry_32_t *descriptor = &idt32[entry_number];
    descriptor->isr_low = (uint32_t) isr & 0xFFFF;
    descriptor->isr_high = (uint32_t) isr >> 16;
    descriptor->code_seg = 0x08;
    descriptor->attributes = flags;
    descriptor->reserved = 0;
}

void init_idt_32(void)
{
    idtr32.limit = (uint16_t)(sizeof(idt_entry_32_t) * 256);
    idtr32.base = (uint32_t) &idt32[0];

    for (uint8_t i = 0; i < 32; i++)
    {
        if (i == 8 || i == 10 || i == 11 || i == 12 ||
            i == 13 || i == 14 || i == 17 || i == 21)
        {
            set_idt_entry_32(i, default_exception_handler_ec, 0x8F);
            continue;
        }

        set_idt_entry_32(i, default_exception_handler, 0x8F);
    }

    for (uint16_t i = 32; i < 256; i++)
    {
        set_idt_entry_32(i, default_isr, 0x8E);
    }

    __asm__ volatile ("lidt %0" : : "memory"(idtr32));
    // TODO Enable STI after configuring NMI and the APIC.
}