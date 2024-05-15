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

	mov al, 0x11
	out 0x20, al
	out 0xa0, al
	mov al, 0x20
	out 0x21, al
	mov al, 0x28
	out 0xa1, al
	mov al, 4
	out 0x21, al
	mov al, 2
	out 0xa1, al
	mov al, 1
	out 0x21, al
	out 0xa1, al
	mov al, 0xff
	out 0x21, al

	lidt [IDT_DESC]
        sti

	mov al, 0xa7
	out 0x64, al
	mov al, 0xae
	out 0x64, al
	mov al, 0xf4
	out 0x64, al
	
	mov al, 0xfd
	out 0x21, al

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

ignoreint:
	iret

keyboard:
	pusha
	xor eax, eax
	in al, 0x60
	cmp al, 0x59
	jnb nokboutput
	cmp al, 0x0e
	je kbbackspace
	mov esi, kbscancodes
	add esi, eax
	cld
	lodsb
	mov ah, 0x0f
	mov edi, [vram_pointer]
	stosw
	mov [vram_pointer], edi
	jmp nokboutput
kbbackspace:
	mov edi, [vram_pointer]
	std
	xor ax, ax
	stosw
	mov dword [edi], 0
	mov [vram_pointer], edi
	jmp nokboutput
nokboutput:
	mov al, 0x20
	out 0x20, al
	popa
	iret

IDT:
	%rep 0x21
	dw ignoreint
	dw 0x08
	dw 0x8e00
	dw 0
	%endrep

	dw keyboard
	dw 0x08
	dw 0x8e00
	dw 0
IDT_END:

IDT_DESC:
	dw IDT_END - IDT - 1
	dd IDT

vram_pointer: dd 0xb8000
string: db "AydinOS booted succesfully! Last update: keyboard driver", 0
kbscancodes: db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0, 0, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0, 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 39, '`', 0, '\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
times 512 * 10 - ($ - $$) db 0
