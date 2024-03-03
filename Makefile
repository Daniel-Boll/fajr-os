BUILD=build
SRC=src

KERNEL_SOURCES=$(wildcard $(SRC)/kernel/*.c)
OBJ=$(patsubst $(SRC)/%.c, $(BUILD)/%.o, $(KERNEL_SOURCES))

C_FLAGS=-m32 -ffreestanding -g -c
LD_FLAGS=-melf_i386 -nostdlib --oformat binary
NASM_FLAGS=-felf32
QEMU=qemu-system-i386

all: dir $(BUILD)/boot.bin $(BUILD)/kernel.bin os-image os

run: all
	$(QEMU) -drive file=$(BUILD)/os.img,format=raw,index=0,if=floppy

debug: all
	$(QEMU) -S -gdb tcp::9999 -drive file=$(BUILD)/os.img,format=raw,index=0,if=floppy

os-image:
	cat $(BUILD)/boot.bin $(BUILD)/kernel.bin > $(BUILD)/os-image

os: ${BUILD}/os-image
	dd if=/dev/zero bs=1024 count=1440 > ${BUILD}/$@.img
	dd if=$< of=${BUILD}/$@.img conv=notrunc

$(BUILD)/boot.bin: $(SRC)/boot/loader.asm
	@nasm $(NASM_FLAGS) -o $@ -f bin $<

$(BUILD)/kernel.bin: $(OBJ)
	@ld $(LD_FLAGS) -T linker.ld -o $@ $^

$(BUILD)/%.o: $(SRC)/%.c
	@mkdir -p $(dir $@)
	@gcc $(C_FLAGS) $< -o $@

dir:
	@mkdir -p $(BUILD)

clean:
	@rm -f $(SRC)/**/*.o
	@rm -rf $(BUILD)
