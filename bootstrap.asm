[org 0x7c00]

[bits 16]
		jmp 0x0: label_start16

gdt_begin:
	gdt_null: dq 0x0
	gdt_code: dq 0x00cf9a000000ffff
	gdt_data: dq 0x00cf92000000ffff
gdt_end:

gdt_desc_begin:
	dw ((gdt_end - gdt_begin) - 1) ; sizeof GDT (16 bits)
	dd gdt_begin                   ; GDT pointer

CODE_SEG_OFFSET equ (gdt_code - gdt_begin)
DATA_SEG_OFFSET equ (gdt_data - gdt_begin)

label_start16:
		xor ax, ax
		mov ds, ax

		mov ah, 0x2    ; read sector routine
		mov al, 0x1    ; num sectors to read
		mov bx, 0x7e00 ; read destination
		mov ch, 0x0    ; select track 0
		mov dh, 0x0    ; select head 0
		mov cl, 0x2    ; sector index (one-based)
		int 0x13

		cli
		lgdt [gdt_desc_begin]
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		jmp CODE_SEG_OFFSET: label_start32 ; clear i-cache

[bits 32]
label_start32:
		mov ax, DATA_SEG_OFFSET
		mov ds, ax
		mov es, ax
		mov ss, ax

times (510 - ($ - $$)) db 0
dw 0xaa55  ; MBR signature
