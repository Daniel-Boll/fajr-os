; Global Descriptor Table
gdt:
.null:         ;; the mandatory null descriptor
  dd 0x0
  dd 0x0

.code:         ;; the code segment descriptor
               ;; base = 0x0, limit = 0xfffff
               ;; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
               ;; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
               ;; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
  dw 0xffff    ;; Limit (bits 0-15)
  dw 0x0       ;; Base (bits 0-15)
  db 0x0       ;; Base (bits 16-23)
  db 10011010b ;; 1st flags, type flags
  db 11001111b ;; 2nd flags, Limit (bits 16-19)
  db 0x0       ;; Base (bits 24-31)

.data:         ;; Same as code segment, except for the type flags:
               ;; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
  dw 0xffff    ;; Limit (bits 0-15)
  dw 0x0       ;; Base (bits 0-15)
  db 0x0       ;; Base (bits 16-23)
  db 10010010b ;; 1st flags, type flags
  db 11001111b ;; 2nd flags, Limit (bits 16-19)
  db 0x0       ;; Base (bits 24-31)

.end:          ;; The reason for puttin a label at the end of the GDT is to be able to
               ;; calculate the size of the GDT by subtracting the address of the start
               ;; from the address of the end.

gdt_descriptor:
  dw gdt.end - gdt - 1 ;; the size of our GDT
  dd gdt               ;; the address of our GDT

CODE_SEG equ gdt.code - gdt
DATA_SEG equ gdt.data - gdt
