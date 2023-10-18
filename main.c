#include<stdint.h>

#define WHITE_ON_BLACK 0xf
#define VGA_BUFFER_ADDRESS 0xb8000

typedef int32_t size_t;

typedef struct
{
	int8_t Character;
	int8_t Attribute;
} vga_buffer_cell;

static void*
memset(void* Dest, int Pattern, size_t NumBytes)
{
	char* DestByte = Dest;
	char ByteValue = (char)Pattern;
	while(NumBytes > 0)
	{
		*DestByte = ByteValue;
		DestByte += 1;
		NumBytes -= 1;
	}
	void* Result = (void*)DestByte;
	return Result;
}

static void
vga_clear_screen(void)
{
	memset((void*)VGA_BUFFER_ADDRESS, 0, sizeof(vga_buffer_cell) * 80 * 25);
}

static void
vga_print_string(char* String, int8_t Attribute)
{
	vga_buffer_cell* Cell = (vga_buffer_cell*)VGA_BUFFER_ADDRESS;
	while(*String)
	{
		Cell->Character = *String;
		Cell->Attribute = Attribute;
		Cell += 1;
		String += 1;
	}
}

void _main(void)
{
	vga_clear_screen();
	vga_print_string("Welcome to the matrix!", WHITE_ON_BLACK);
}
