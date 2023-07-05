[[noreturn]] void _start(unsigned char uc, unsigned char attr)
{
    volatile unsigned short *vmem = (volatile unsigned short *) 0xB8000;
    vmem[0] = (attr << 8) | uc;

    while (1);
}