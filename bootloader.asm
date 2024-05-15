[org 0x7c00]
[bits 16]

	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov bp, 0xffff
	mov sp, bp
	mov [bootdisk], dl

bootfunc_main:
	mov ax, 0x0003
	int 0x10

	mov si, bootmsg
	call bootfunc_printstring
	call bootfunc_linedown
	mov si, bootreadingdisk
	call bootfunc_printstring
	call bootfunc_linedown

	mov ax, 0x020B
	mov cx, 0x0002
	xor dh, dh
	mov dl, [bootdisk]
	mov bx, 0x7e00
	int 0x13

	cmp byte [0x7e00], 25
	jne bootfunc_diskfailure

	mov si, bootstartingkernel
	call bootfunc_printstring
	call bootfunc_linedown

	jmp 0x8000

bootfunc_printstring:
	cld
	lodsb
	mov ah, 0x0e
	cmp al, 0
	je bootfunc_return
	int 0x10
	jmp bootfunc_printstring

bootfunc_linedown:
	mov ah, 0x03
	xor bx, bx
	int 0x10
	mov ah, 0x02
	xor dl, dl
	inc dh
	int 0x10
	ret

bootfunc_diskfailure:
	mov si, bootdiskfailure
	call bootfunc_printstring
	jmp $
	

bootfunc_return:
	ret

bootmsg: db "Booting AydinOS...", 0
bootreadingdisk: db "Reading disk...", 0
bootdiskfailure: db "Disk read failure - booting halted.", 0
bootstartingkernel: db "Starting AydinOS kernel...", 0

bootdisk: db 0

times 510 - ($ - $$) db 0
dw 0xaa55

db 25

times 512 * 2 - ($ - $$) db 0
