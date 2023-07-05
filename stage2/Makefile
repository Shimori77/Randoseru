AS:=nasm

SRC_DIR:=src
OUT_DIR:=out
COMMON_INC:=../common/inc

MAIN_FILE:=$(SRC_DIR)/main.asm
BINARY:=$(OUT_DIR)/stage2.bin

ASFLAGS:=-fbin -I$(COMMON_INC)

.PHONY: all clean

all: clean $(BINARY)

$(BINARY):
	$(AS) $(ASFLAGS) $(MAIN_FILE) -o $(BINARY)

clean:
	@rm -rf $(OUT_DIR)
	@mkdir -p $(OUT_DIR)