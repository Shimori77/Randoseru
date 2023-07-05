STAGE1_DIR:=./stage1
STAGE1_BIN:=$(STAGE1_DIR)/out/stage1.bin

STAGE2_DIR:=./stage2
STAGE2_BIN:=$(STAGE2_DIR)/out/stage2.bin

STAGE3_DIR:=./stage3
STAGE3_BIN:=$(STAGE3_DIR)/out/stage3.bin

OUT_DIR:=./out
BINARY:=$(OUT_DIR)/randoseru.bin

.PHONY: all clean

all: clean $(BINARY)
	truncate -s 16K $(BINARY)

$(BINARY): $(STAGE1_BIN) $(STAGE2_BIN) $(STAGE3_BIN)
	cat $^ >> $@

$(STAGE1_BIN):
	$(MAKE) -C $(STAGE1_DIR)

$(STAGE2_BIN):
	$(MAKE) -C $(STAGE2_DIR)

$(STAGE3_BIN):
	$(MAKE) -C $(STAGE3_DIR)

clean:
	@rm -rf $(OUT_DIR)
	@mkdir -p $(OUT_DIR)

	$(MAKE) -C $(STAGE1_DIR) clean
	$(MAKE) -C $(STAGE2_DIR) clean
	$(MAKE) -C $(STAGE3_DIR) clean