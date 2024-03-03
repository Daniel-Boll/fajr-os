%define BOOT_SECTOR_OFFSET 0x7c00
%define STACK_OFFSET 0x9000
%define KERNEL_OFFSET 0x1000

org BOOT_SECTOR_OFFSET       ;; set the origin to 0x7c00
bits 16

bios:
    mov [BOOT_DRIVE], dl

    mov bp, STACK_OFFSET   ;; set the stack safely out of the way
    mov sp, bp

    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x86
    mov cx, 0x0F
    mov dx, 0x4240
    int 0x15

    mov si, MSG_REAL_MODE
    call puts

    mov ah, 0x86
    mov cx, 0x0F
    mov dx, 0x4240
    int 0x15

    call load_kernel

    call switch_to_protected_mode
    ;; (unreachable code)

    jmp $

%include "src/boot/lib/io/puts.asm"
%include "src/boot/lib/io/print_string_pm.asm"
%include "src/boot/lib/memory/disk_load.asm"
%include "src/boot/lib/memory/gdt.asm"
%include "src/boot/lib/memory/protected_mode.asm"

bits 16

load_kernel:
    mov si, MSG_LOAD_KERNEL
    call puts

    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

bits 32

begin_pm:
    mov ebx, MSG_PROTECTED_MODE
    call print_string_pm

    call KERNEL_OFFSET

.halt:
    hlt
    jmp .halt

BOOT_DRIVE         db 0
MSG_LOAD_KERNEL    db "Loading kernel...", 0
MSG_REAL_MODE      db "Started in 16-bit Real Mode", 0
MSG_PROTECTED_MODE db "Successfully switched to 32-bit Protected Mode", 0

times 510-($-$$) db 0        ;; fill the rest of the sector with 0s
dw 0xaa55                    ;; BIOS magic number
