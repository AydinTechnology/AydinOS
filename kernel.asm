[bits 16]
[org 0x8000]

	mov ax, 0x0003
	int 0x10

	cli
	lgdt [GDT_DESC]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp 0x08:clear_pipe

GDT:
GDT_NULL:
	dq 0
GDT_CODE:
	dw 0xffff
	dw 0
	db 0
	db 10011010b
	db 11001111b
	db 0
GDT_DATA:
	dw 0xffff
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0
GDT_END:

GDT_DESC:
	dw GDT_END - GDT
	dd GDT

[bits 32]
clear_pipe:
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov ebp, 0x09ffff
	mov esp, ebp

	mov esi, string
	mov edi, [vram_pointer]
	call printstring
	jmp $

printstring:
	cld
	lodsb
	cmp al, 0
	je endstring
	mov ah, 0x0f
	stosw
	jmp printstring
endstring:
	mov [vram_pointer], edi
	ret

vram_pointer: dd 0xb8000
string: db "AydinOS booted succesfully! (For now, who knows what future updates will break)", 0
times 512 * 10 - ($ - $$) db 0
