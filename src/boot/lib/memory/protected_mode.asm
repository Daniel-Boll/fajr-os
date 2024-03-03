bits 16

switch_to_protected_mode:
    cli                         ;; Disable interrupts
    lgdt [gdt_descriptor]       ;; Load the GDT descriptor
    mov eax, cr0                ;; To make the switch to protected mode, we need to set the first bit of the CR0 register
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:protected_mode ;; Make a far jump. Flush the CPU pipeline and start executing code in the new mode

bits 32

protected_mode:
    mov ax, DATA_SEG ;; Now in protected mode, we need to reload all the segment registers
    mov ds, ax       ;; with the appropriate values, so we point to our data segment defined in the GDT
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ;; Update the stack pointer to be at the top of the free space
    mov esp, ebp

    call begin_pm
