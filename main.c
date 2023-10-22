#include<stdint.h>
#include<cpuid.h>

#include"header.h"
extern void* memset(void*, int, size_t);

#include"keyboard.h"

#include"x86_idt.h"
#include"videomode_vga.h"

#include"videomode_vga.c"




#define INTERRUPT_VECTOR_TABLE ((interrupt_routine**)0)
#define INTERRUPT_KEYBOARD INTERRUPT_VECTOR_TABLE[9]

typedef void interrupt_routine(void);

static void
int_stub(void)
{
	return;
}

extern int cpu_supports_64bit(void);

#define IDT_SIZE 256
#define CODE_SEGMENT_OFFSET 0x8
#define IDT_INTERRUPT_GATE_32BIT 0x8e

#define PORT_PIC1_COMMAND 0x20
#define PORT_PIC2_COMMAND 0xa0
#define PORT_PIC1_DATA 0x21
#define PORT_PIC2_DATA 0xa1


#define PORT_KEYBOARD_STATUS 0x64
#define PORT_KEYBOARD_DATA 0x60

static uint8_t
io_port_read_8(uint16_t Port)
{
	// "=a" (result) means: put AL register in variable RESULT when finished
	// "d" (port) means: load EDX with port
	uint8_t Result;
	__asm__("in %%dx , %%al" : "=a" (Result) : "d" (Port));
	return Result;
}

static uint16_t
io_port_read_16(uint16_t Port)
{
	uint16_t Result;
	__asm__("in %%dx , %%ax" : "=a" (Result) : "d" (Port));
	return Result;
}

static void
io_port_write_8(uint16_t Port, uint8_t Data)
{
	// "a" (data) means: load EAX with data
	// "d" (port) means: load EDX with port
	__asm__("out %%al , %%dx" : :"a" (Data), "d" (Port));
}

static void
io_port_write_16(uint16_t Port, uint16_t Data)
{
	__asm__("out %%ax , %%dx" : :"a" (Data), "d" (Port));
}

static void
io_wait(void)
{
	io_port_write_8(0x80, 0);
}


static uint32_t CursorPos;

extern void interrupt_keyboard(void);

void _main(void)
{
	vga_print_string("asdf", WHITE_ON_BLACK);

#if 0
	uint32_t IntKbd = (uint32_t)interrupt_keyboard;
	idt_entry Entries[IDT_SIZE] = {0};
	Entries[0x21].OffsetLo = (uint16_t)IntKbd;
	Entries[0x21].Selector = CODE_SEGMENT_OFFSET;
	Entries[0x21].Attribute = IDT_INTERRUPT_GATE_32BIT;
	Entries[0x21].OffsetHi = (uint16_t)(IntKbd >> 16);


	io_port_write_8(PORT_PIC1_COMMAND, 0x11);
	io_port_write_8(PORT_PIC2_COMMAND, 0x11);
	io_port_write_8(PORT_PIC1_DATA, 0x20);
	io_port_write_8(PORT_PIC2_DATA, 0x28);
	io_port_write_8(PORT_PIC1_DATA, 0x4);
	io_port_write_8(PORT_PIC2_DATA, 0x2);

	io_port_write_8(PORT_PIC1_DATA, 0x1);
	io_port_write_8(PORT_PIC2_DATA, 0x1);

	io_port_write_8(PORT_PIC1_DATA, 0x0);
	io_port_write_8(PORT_PIC2_DATA, 0x0);

	idt_desc TheThing;
	TheThing.Size = sizeof(Entries) - 1;
	TheThing.Address = (uint32_t)Entries;
	__asm__ inline ("lidt %0" : : "m"(TheThing));
	io_port_write_8(PORT_PIC1_DATA, 0xfd); // unmasking keyboard interrupt
	__asm__ inline ("sti");

	for(;;)
	{
		__asm__ inline ("hlt");
	}
#endif

}

#include"utility.c"



void int_keyboard(void)
{
	uint8_t Status = io_port_read_8(PORT_KEYBOARD_STATUS);
	if(Status & 1)
	{
		uint8_t Keycode = io_port_read_8(PORT_KEYBOARD_DATA);
		if(Keycode > 0x7f) return;
		vga_buffer_cell* Cell = (vga_buffer_cell*)VGA_BUFFER_ADDRESS + CursorPos;
		Cell->Character = kbdus[Keycode];
		Cell->Attribute = WHITE_ON_BLACK;
		CursorPos += 1;
	}
	io_port_write_8(PORT_PIC2_COMMAND, 0x20); // end of interrupt
	//__asm__ inline("iret");
}

