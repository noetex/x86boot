KERNEL_CODE equ $$ + 512
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0xf
CODE_SEG_OFFSET equ (GDT32_CODE - GDT32_BASE)
DATA_SEG_OFFSET equ (GDT32_DATA - GDT32_BASE)

[ORG 0x7c00]
[BITS 16]
		smsw cx                 ; read bottom 16-bits of CR0
		test cx, 0x1            ; did some bootloader enable 32-bit for us?
		jnz label_start32       ; note: keep the CS regsiter intact
		jmp 0x0: label_start16  ; clear CS register for our purposes

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
		jnc label_enter_protected_mode
		mov si, MESSAGE_DISK_ERROR
		mov ah, 0xe         ; teletype output bios routine
.print_message_loop:
		mov al, [si]
		test al, al    ; end of string?
		jz .print_message_end
		int 0x10
		inc si
		jmp .print_message_loop
.print_message_end:
		jmp $

label_enter_protected_mode:
		cli
		lgdt [GDT32_DESC]
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		jmp CODE_SEG_OFFSET: label_setup32  ; flush instruction pipeline

[bits 32]
label_setup32:
		mov ax, DATA_SEG_OFFSET
		mov ds, ax
		mov es, ax
		mov ss, ax

label_start32:
		mov esp, 0x90000
		mov ebp, esp

		; does our hardware support the CPUID instruction?
		pushfd
		pop eax             ; read the flags register
		mov ecx, eax
		xor eax, (1 << 21)  ; attempt to toggle the ID bit
		push eax
		popfd               ; update the flags register
		pushfd
		pop eax             ; read the value again
		cmp eax, ecx        ; was that bit toggled succesfully?
		jne label_cpuid_supported
		mov esi, MESSAGE_UNSUPPORTED_CPUID
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
		jmp $

label_cpuid_supported:
		; push ecx          ; NOTE: do we have to do this?
		; popfd             ; restore old flags state
		call KERNEL_CODE

label_infinite_halt:
		hlt                        ; TODO: revert to real mode
		jmp label_infinite_halt    ; TODO: shutdown


; data
GDT32_BASE: dq 0x0
GDT32_CODE: dq 0x00cf9a000000ffff
GDT32_DATA: dq 0x00cf92000000ffff
GDT32_DESC:
	dw (($ - GDT32_BASE) - 1)
	dd GDT32_BASE

MESSAGE_UNSUPPORTED_CPUID: db "ERROR: This machine does not support the CPUID instruction", 0
MESSAGE_DISK_ERROR: db "ERROR: Could not read from disk", 14, 10, 0

times (510 - ($ - $$)) db 0
dw 0xaa55  ; MBR signature
