#include<stdint.h>

#include"videomode_vga.h"
#include"videomode_vga.c"


void _main(void)
{
	vga_clear_screen();
	vga_print_string("Welcome to the matrix!", WHITE_ON_BLACK);
}
