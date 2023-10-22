
;io_port_read_8:
;		in eax,
;		ret



;x86__get_vendor_name:
;
;
;
;
;
;
;		; what are the features of our hardware?
;		mov eax, 0x80000000
;		cpuid
;		cmp eax, 0x80000001
;		jb label_long_mode_unsupported
;		mov eax, 0x80000001
;		cpuid
;		test edx, (1 << 29)    ; does our hardware support long (64-bit) mode?
;		jnz label_long_mode_supported
;
;label_long_mode_unsupported:
;		mov esi, MESSAGE_UNSUPPORTED_64BIT
;		call routine_print_string_32bit
;		jmp $
;
;label_long_mode_supported:
;
;
;disable_apic_ioapic:
;	mov al, 0xff
;	out 0xa1, al
;	out 0x21, al
;	ret
