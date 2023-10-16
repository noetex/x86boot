#include<stdint.h>

#define WHITE_ON_BLACK 0x1b

typedef struct
{
	int8_t Character;
	int8_t Attribute;
} video_memory_cell;

static void
print_string_to_video_memory(char* String, int8_t Attribute)
{
	video_memory_cell* VideoMemory = (video_memory_cell*)0xb8000;
	while(*String)
	{
		VideoMemory->Character = *String;
		VideoMemory->Attribute = Attribute;
		VideoMemory += 1;
		String += 1;
	}
}

void _main(void)
{
	print_string_to_video_memory("Welcome to the matrix!", WHITE_ON_BLACK);
}
