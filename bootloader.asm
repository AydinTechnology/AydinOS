[org 0x7c00]
[bits 16]

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov bp, 0x7c00
mov sp, bp

main:
  mov si, tekst
  call print_text

print_text:
  cld
  lodsb
  mov ah, 0x0e
  cmp al, 0
  je return
  int 0x10

return:
  ret

text: db "hallo test test", 0

times 510 - ($ - $$) db 0
dw 0xaa55
