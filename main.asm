[bits 16]
[org 0x7c00]

main:
		mov bx, MESSAGE
		call print_string
		jmp $

print_string:
		pusha
		mov ah, 0x0e	;bios teletype output routine
	print_string_loop:
		mov al, [bx]	;bx: pointer to char string
		cmp al, 0
		je print_string_end
		int 0x10
		inc bx
		jmp print_string_loop
	print_string_end:
		popa
		ret

MESSAGE:
	dw "Currently operating in 16-bit real mode", 0

; MBR signature
times (510 - ($ - $$)) db 0
dw 0xaa55
