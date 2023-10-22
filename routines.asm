.intel_syntax noprefix
.global cpu_supports_64bit
.global int_keyboard
.global interrupt_keyboard

interrupt_keyboard:
		call int_keyboard
		iret

interrupts_are_enabled:
		pushfd
		pop eax
		shr eax, 9
		and eax, 1
		ret

cpu_supports_64bit:
		mov eax, 0x80000000
		cpuid
		cmp eax, 0x80000001
		jb .unsupported
		mov eax, 0x80000001
		cpuid
		mov eax, edx
		shr eax, 29
		and eax, 1
		ret
.unsupported:
		xor eax, eax
		ret

cpuid_is_supported:
		pushfd
		pop eax
		mov ecx, eax
		xor eax, (1 << 21)
		push eax
		popfd
		pushfd
		pop eax
		cmp eax, ecx
		setne al
		movzx eax, al
		ret
