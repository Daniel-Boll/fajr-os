%ifndef HEX
%define HEX

; void hex(short {di})
; Print the hexadecimal representation of {di}
hex:
    pusha               ;; Save registers

    mov ax, di          ;; Move the value to ax
    mov cx, 4           ;; We will print 4 digits, so our counter is 4
    mov si, HEX_OUT + 6 ;; Start at the end of the string (excluding "0x")

.loop:
    mov dx, ax          ;; Move the value to dx
    and dx, 0xF         ;; Mask the lower 4 bits
    cmp dx, 10          ;; If the value is greater than 9, we need to add the byte of 'A' to get the ASCII value
    jl .digit
    add dl, 'A' - 10    ;; Add 55 to get the ASCII value
    jmp .store

.digit:                 ;; If the value is less than 10, we can just add the byte of '0' to get the ASCII value
    add dl, '0'

.store:                 ;; Store the value in the string and shift the value to the right
    dec si              ;; Move the pointer to the left
    mov [si], dl        ;; Store the value
    shr ax, 4           ;; Shift the value to the right
    loop .loop          ;; Loop until we have printed all 4 digits

    mov si, HEX_OUT     ;; Reset SI to point to the start of HEX_OUT
    call puts           ;; Print the string

    popa                ;; Restore registers
    ret

%include "src/boot/lib/io/puts.asm"

HEX_OUT: db "0000", 0

%endif ; HEX
