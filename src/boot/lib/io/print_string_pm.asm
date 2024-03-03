%ifndef PRINT_STRING_PM
%define PRINT_STRING_PM

bits 32

%define VIDEO_MEMORY 0xb8000
%define WHITE_ON_BLACK 0x0f

;; Print a string to the screen
;; Inputs:
;;   {EBX} - The address of the string to print
;; Outputs:
;;   None
print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY  ;; Set the location of the video memory

.loop:
  mov al, [ebx]          ;; Store the chat at {EBX} in {AL}
  mov ah, WHITE_ON_BLACK ;; Store the attribute in {AH}

  cmp al, 0              ;; if ({AL} == 0), then we've reached the end of the string
  je .done

  mov [edx], ax          ;; Store {AX} at the location in {EDX}
  add ebx, 1             ;; Move to the next character in the string
  add edx, 2             ;; Move to the next character cell in the video memory

  jmp .loop

.done:
  popa
  ret

%endif ; PRINT_STRING_PM
