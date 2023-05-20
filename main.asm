[org 0x7c00]

[bits 16]
		jmp 0x0: start16

start16:
		xor ax, ax
		mov ds, ax
		mov es, ax

disk_read:
		mov ah, 0x2
		mov al, 1
		mov ch, 0
		mov dh, 0
		mov cl, 2
		mov bx, 0x7e00
		int 0x13

enable_protected_mode:
		cli
		xor ax, ax
		mov ds, ax
		lgdt [GDT_DESC]
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		jmp CODE_SEG_OFFSET: reload_segments	; clear i-cache

[bits 32]
reload_segments:
		mov ax, DATA_SEG_OFFSET
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov ss, ax

main:
		mov ebx, 0x7e00
		call print_string
		jmp $

print_string:
		pusha
		mov edx, VIDEO_MEMORY
		mov ah, WHITE_ON_BLACK
	print_string_loop:
		mov al, byte [ebx]
		cmp al, 0
		je print_string_end
		mov word [edx], ax
		add edx, 2
		inc ebx
		jmp print_string_loop
	print_string_end:
		popa
		ret

MESSAGE:
	dd "Now operating in 32-bit protected mode", 0

GDT_BEGIN:
	dq 0x0
GDT_CODE:
	dq 0x00cf9a000000ffff
GDT_DATA:
	dq 0x00cf92000000ffff
GDT_END:

GDT_DESC:
	dw ((GDT_END - GDT_BEGIN) - 1)	; sizeof GDT
	dd GDT_BEGIN	; GDT base address

; macros
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0xf
CODE_SEG_OFFSET equ (GDT_CODE - GDT_BEGIN)
DATA_SEG_OFFSET equ (GDT_DATA - GDT_BEGIN)

; MBR signature
times (510 - ($ - $$)) db 0
dw 0xaa55

; test disk reading
times 15 db 'X'
db 0
