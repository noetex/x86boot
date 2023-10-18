#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

#define WHITE_ON_BLACK 0xf
#define VGA_BUFFER_ADDRESS 0xb8000

enum vga_text_color
{
	VGA_TEXT_COLOR_BLACK = 0,
	VGA_TEXT_COLOR_BLUE = 1,
	VGA_TEXT_COLOR_GREEN = 2,
	VGA_TEXT_COLOR_CYAN = 3,
	VGA_TEXT_COLOR_RED = 4,
	VGA_TEXT_COLOR_MAGENTA = 5,
	VGA_TEXT_COLOR_BROWN = 6,
	VGA_TEXT_COLOR_GRAYLIGHT = 7,
	VGA_TEXT_COLOR_GRAYDARK = 8,
	VGA_TEXT_COLOR_LIGHTBLUE = 9,
	VGA_TEXT_COLOR_LIGHTGREEN = 10,
	VGA_TEXT_COLOR_LIGHTCYAN = 11,
	VGA_TEXT_COLOR_LIGHTRED = 12,
	VGA_TEXT_COLOR_PINK = 13,
	VGA_TEXT_COLOR_YELLOW = 14,
	VGA_TEXT_COLOR_WHITE = 15,
};

typedef int32_t size_t;

#if 0
typedef enum vga_text_mode;
static void vga_set_text_mode(vga_text_mode);
#endif

typedef struct
{
	int8_t Character;
	int8_t Attribute;
} vga_buffer_cell;

