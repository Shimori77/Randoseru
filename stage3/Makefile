AS:=nasm
CC:=x86_64-elf-gcc
LD:=x86_64-elf-ld
OBJCPY:=x86_64-elf-objcopy

OUT_DIR:=./out
SRC_DIR:=./src
INC_DIR:=./include
ETC_DIR:=./etc
COMMON_INC:=../common/inc

OBJS:=$(patsubst %.asm,%.o,$(shell find $(SRC_DIR) -type f -name '*.asm'))
OBJS+=$(patsubst %.c,%.o,$(shell find $(SRC_DIR) -type f -name '*.c'))

ELF:=$(OUT_DIR)/stage3.elf
BINARY:=$(OUT_DIR)/stage3.bin

AS_FLAGS:=-Wall -felf32 -I$(COMMON_INC)
C_FLAGS:=-Wall -Wextra -pedantic -std=c2x \
		-ffreestanding \
		-fno-stack-protector -fno-stack-check -fno-lto \
		-fPIE \
		-m32 \
		-march=i386 -mabi=sysv \
		-mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone \
		-I$(INC_DIR)
LD_FLAGS:=-T$(ETC_DIR)/linker.ld -m elf_i386 \
		-nostdlib -static -no-pie \
		--no-dynamic-linker \
		-z text \
		-z max-page-size=0x1000
OC_FLAGS:=-O binary

.PHONY: all clean

all: clean $(ELF)
	$(OBJCPY) $(OC_FLAGS) $(ELF) $(BINARY)

clean:
	@rm -rf $(OUT_DIR)
	@rm -f $(OBJS)
	@mkdir $(OUT_DIR)

$(ELF): $(OBJS)
	$(LD) $(LD_FLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(AS_FLAGS) -o $@ $<

%.o: %.c
	$(CC) $(C_FLAGS) -c $< -o $@