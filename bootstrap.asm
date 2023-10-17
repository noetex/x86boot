[ORG 0x7c00]
[BITS 16]
		jmp 0x0: label_start16  ; clear cs register prior to any execution

routine_print_string:
		pusha
		mov ah, 0xe    ; teletype output bios routine
.print_string_loop:
		mov al, [bx]
		test al, al    ; end of string?
		jz .pring_string_end
		int 0x10
		inc bx
		jmp .print_string_loop
.pring_string_end:
		popa
		ret

label_start16:
		xor ax, ax
		mov ds, ax

		; read more sectors from disk
		mov ah, 0x2         ; read sector routine
		mov al, 0x1         ; num sectors to read
		mov bx, KERNEL_CODE ; destination
		mov ch, 0x0         ; source cylinder
		mov dh, 0x0         ; source head
		mov cl, 0x2         ; sector index (one-based)
		int 0x13            ; TODO: error checking

		; enter 32-bit protected mode
		cli
		lgdt [gdt_desc_begin]
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		jmp CODE_SEG_OFFSET: label_start32  ; flush instruction pipeline

[bits 32]
routine_print_string_32bit:
		pusha
		mov edi, VIDEO_MEMORY
.print_string_32bit_loop:
		mov al, [esi]
		test al, al
		jz .print_string_32bit_end
		mov ah, WHITE_ON_BLACK
		mov [edi], ax
		inc esi
		add edi, 2
		jmp .print_string_32bit_loop
.print_string_32bit_end:
		popa
		ret

label_start32:
		mov ax, DATA_SEG_OFFSET
		mov ds, ax
		mov es, ax
		mov ss, ax

		mov esp, 0x90000
		mov ebp, esp

;		; does our hardware support the CPUID instruction?
;		pushfd
;		pop eax             ; read the flags register
;		mov ecx, eax
;		xor eax, (1 << 21)  ; attempt to toggle the ID bit
;		push eax
;		popfd               ; update the flags register
;		pushfd
;		pop eax             ; read the value again
;		cmp eax, ecx        ; was that bit toggled succesfully?
;		jne label_cpuid_supported
;		mov esi, MESSAGE_UNSUPPORTED_CPUID
;		call routine_print_string_32bit
;		jmp $
;
;label_cpuid_supported:
;		; push ecx          ; NOTE: do we have to do this?
;		; popfd             ; restore old flags state
;
;		; does our hardware support 64-bit mode?
;		mov eax, 0x80000000
;		cpuid
;		cmp eax, 0x80000001
;		jb label_long_mode_unsupported
;		mov eax, 0x80000001
;		cpuid
;		test edx, (1 << 29)
;		jnz label_long_mode_supported
;
;label_long_mode_unsupported:
;		mov esi, MESSAGE_UNSUPPORTED_64BIT
;		call routine_print_string_32bit
;		jmp $

label_long_mode_supported:
		call KERNEL_CODE

label_infinite_halt:
		hlt                        ; TODO: revert to real mode
		jmp label_infinite_halt    ; TODO: shutdown


; data
gdt_begin:
	gdt_null: dq 0x0
	gdt_code: dq 0x00cf9a000000ffff
	gdt_data: dq 0x00cf92000000ffff
gdt_end:

gdt_desc_begin:
	dw GDT_DESC_SIZE
	dd GDT_DESC_ADDRESS

MESSAGE_UNSUPPORTED_CPUID: db "ERROR: This machine does not support the CPUID instruction", 0
MESSAGE_UNSUPPORTED_64BIT: db "ERROR: This image is built for 64-bit mode, which is not supported by this machine", 0
MESSAGE_TEST: db "REACHED HERE!!!", 14, 10, 0


times (510 - ($ - $$)) db 0
dw 0xaa55  ; MBR signature

; constants
KERNEL_CODE equ $$ + 512
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x1b
GDT_DESC_SIZE equ ((gdt_end - gdt_begin) - 1)
GDT_DESC_ADDRESS equ gdt_null
CODE_SEG_OFFSET equ (gdt_code - gdt_begin)
DATA_SEG_OFFSET equ (gdt_data - gdt_begin)
