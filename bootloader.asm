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
  call linedown
  jmp $

print_text:
  cld
  lodsb
  mov ah, 0x0e
  cmp al, 0
  je return
  int 0x10

linedown:
  mov ah, 0x03
  xor bx, bx
  int 0x10
  mov ah, 0x02
  xor dl, dl
  inc dh
  int 0x10
  ret

return:
  ret

text: db "AydinOS 1.0", 0

times 510 - ($ - $$) db 0
dw 0xaa55
