#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif
 
#define VGA_WIDTH	25
#define VGA_HEIGHT	80

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
};

#define VGA_ENTRY(ch, color)		((ch) | (color << 8))
#define VGA_COLOR_ENTRY(fg, bg)		((fg) | (bg << 4))

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t *terminal_buffer;

void terminal_initialize()
{
	terminal_color = VGA_COLOR_ENTRY(VGA_COLOR_BLACK, VGA_COLOR_CYAN);
	terminal_row = 0;
	terminal_column = 0;
	terminal_buffer = (uint16_t*)0xb8000;
	for (size_t y = 0; y < VGA_HEIGHT; ++y) {
		for (size_t x = 0; x < VGA_WIDTH; ++x) {
			size_t pos = y * VGA_WIDTH + x;
			terminal_buffer[pos] = VGA_ENTRY(' ', terminal_color);
		}
	}
}

void terminal_putchar(const char ch)
{
	size_t pos = terminal_row * VGA_WIDTH + terminal_column++;
	terminal_buffer[pos] = VGA_ENTRY(ch, terminal_color);
	terminal_column %= VGA_WIDTH;
	if (!terminal_column) {
		terminal_row++;
		terminal_row %= VGA_HEIGHT;
	}
}

void terminal_writestring(const char* str)
{
	while (*str != 0)
		terminal_putchar(*str++);
}

void kernel_main()
{
	terminal_initialize();
	terminal_writestring("Hello, kernel!");
}
