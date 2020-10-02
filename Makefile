CROSS ?= x86_64-elf

COPS = -Wall -Wextra -nostdlib -nostartfiles -ffreestanding -Iinclude -std=gnu99
LOPS = --nmagic
ASMOPS = -Iinclude

BUILD_DIR = build
SRC_DIR = src
ISO_DIR = iso
KERNEL = kernel.elf
ISO_KRNL = kernel.iso
GRUB_CFG = grub.cfg

all : $(KERNEL)

clean :
	rm -rf $(BUILD_DIR) *.bin *.elf *.iso iso

iso : $(KERNEL)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL) $(ISO_DIR)/boot/$(KERNEL)
	cp $(GRUB_CFG) $(ISO_DIR)/boot/grub/$(GRUB_CFG)
	grub-mkrescue -o $(ISO_KRNL) $(ISO_DIR)

$(BUILD_DIR)/%_c.o: $(SRC_DIR)/%.c
	mkdir -p $(@D)
	$(CROSS)-gcc $(COPS) -MMD -c $< -o $@

$(BUILD_DIR)/%_s.o: $(SRC_DIR)/%.S
	$(CROSS)-as $(ASMOPS) $< -o $@

C_FILES = $(wildcard $(SRC_DIR)/*.c)
ASM_FILES = $(wildcard $(SRC_DIR)/*.S)
OBJ_FILES = $(C_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%_c.o)
OBJ_FILES += $(ASM_FILES:$(SRC_DIR)/%.S=$(BUILD_DIR)/%_s.o)

DEP_FILES = $(OBJ_FILES:%.o=%.d)
-include $(DEP_FILES)

$(KERNEL): $(SRC_DIR)/linker.ld $(OBJ_FILES)
	$(CROSS)-ld $(LOPS) -T $(SRC_DIR)/linker.ld -o $(KERNEL)  $(OBJ_FILES)
