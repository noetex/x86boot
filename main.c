#include<stdint.h>

#include"header.h"
#include"utility.c"
#include"videomode_vga.h"
#include"videomode_vga.c"

#define INTERRUPT_VECTOR_TABLE ((void*)0)

typedef void interrupt_routine(void);

static void
int_stub(void)
{
	return;
}

static interrupt_routine* INTERRUPT_VECTORS[256] =
{
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
	int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub, int_stub,
};

void _main(void)
{
	memcpy(INTERRUPT_VECTOR_TABLE, INTERRUPT_VECTORS, sizeof(INTERRUPT_VECTORS));
	//vga_clear_screen();
	//vga_print_string("Welcome to the matrix!", WHITE_ON_BLACK);
	//vga_console Console = {0};
	vga_console Console;
	memset(&Console, 0, sizeof(Console));
	Console.CurrentAttribute = WHITE_ON_BLACK;
	Console.Buffer = VGA_BUFFER_ADDRESS;
	//Console.
	vga_console_clear(&Console);
	vga_console_write(&Console, "Hello");
	vga_console_write(&Console, "World");
}
