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
