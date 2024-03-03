BUILD=build
SRC=src

KERNEL_SOURCES_C=$(wildcard $(SRC)/kernel/*.c)
OBJ_C=$(patsubst $(SRC)/%.c, $(BUILD)/%.o, $(KERNEL_SOURCES_C))
KERNEL_SOURCES_ASM=$(wildcard $(SRC)/kernel/*.asm)
OBJ_ASM=$(patsubst $(SRC)/%.asm, $(BUILD)/%.o, $(KERNEL_SOURCES_ASM))
OBJ=$(OBJ_ASM) $(OBJ_C)

C_FLAGS=-m32 -ffreestanding -fno-pie -g -c
LD_FLAGS=-melf_i386 --oformat binary
NASM_FLAGS=-felf32
QEMU=qemu-system-i386

all: dir $(BUILD)/boot.bin $(BUILD)/kernel.bin os-image os

run: all
	$(QEMU) -drive file=$(BUILD)/os.img,format=raw,index=0,if=floppy

debug: all
	$(QEMU) -S -gdb tcp::9999 -drive file=$(BUILD)/os.img,format=raw,index=0,if=floppy

os-image:
	cat $(BUILD)/boot.bin $(BUILD)/kernel.bin > $(BUILD)/os-image

os: $(BUILD)/os-image
	dd if=/dev/zero bs=1024 count=1440 > $(BUILD)/$@.img
	dd if=$< of=$(BUILD)/$@.img conv=notrunc

$(BUILD)/boot.bin: $(SRC)/boot/loader.asm
	@nasm $(NASM_FLAGS) -o $@ -f bin $<

$(BUILD)/kernel/kernel_entry.o: $(SRC)/kernel/kernel_entry.asm
	@nasm $(NASM_FLAGS) -o $@ $<

$(BUILD)/kernel.bin: $(OBJ)
	@ld -o $@ $(LD_FLAGS) -T$(SRC)/kernel/kernel.ld $^

$(BUILD)/%.o: $(SRC)/%.c
	@gcc $(C_FLAGS) $< -o $@

dir:
	@mkdir -p $(BUILD)/kernel

clean:
	@rm -rf $(BUILD)
