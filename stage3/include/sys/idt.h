#pragma once

#include <stdint.h>

typedef struct
{
    uint16_t isr_low;
    uint16_t code_seg;
    uint8_t reserved;
    uint8_t attributes;
    uint16_t isr_high;
}__attribute__((packed)) idt_entry_32_t;

typedef struct
{
    uint16_t limit;
    uint32_t base;
}__attribute__((packed)) idtr_32_t;

typedef struct
{
    uint32_t eip;
    uint32_t cs;
    uint32_t flags;
    uint32_t sp;
    uint32_t ss
}__attribute__((packed)) interrupt_frame_t;

// IDT actual entries
__attribute__((aligned(0x10))) static idt_entry_32_t idt32[256];
static idtr_32_t idtr32;

// Default exception handler (no error code)
__attribute__((interrupt)) void default_exception_handler(interrupt_frame_t *interrupt_frame);

// Default exception handler (with error code)
__attribute__((interrupt)) void default_exception_handler_ec(interrupt_frame_t *interrupt_frame, uint32_t error_code);

// Default interrupt handler
__attribute__((interrupt)) void default_isr(interrupt_frame_t *interrupt_frame);

// Place entries inside the IDT
void set_idt_entry_32(uint8_t entry_number, void *isr, uint8_t flags);

// Initialize the IDT
void init_idt_32(void);