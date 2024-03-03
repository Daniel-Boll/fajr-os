%ifndef PUTS
%define PUTS

%include "src/boot/lib/utils/save_and_restore_registers.asm"

; void puts(const char *{si})
; Using the tty mode perform the output of the string pointed to by the register {si}
puts:
  save_registers si, ax, bx

  mov ah, 0x0e ;; tty mode
  xor bh, bh ;; page number

  jmp .next_char

.print_char:
  int 0x10     ;; call the BIOS to print the character in al
.next_char:
  lodsb        ;; load the next byte from the string
  test al, al  ;; check if the byte is zero
  jnz .print_char ;; if not zero, print the character

  ;; restore the registers and return
  restore_registers si, ax, bx
  ret

%endif ; PUTS
