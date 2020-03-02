#ifndef _VGA_H
#define _VGA_H

#include <stdint.h>
#include <stddef.h>

#include "string.h"

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15
};

size_t vga_column, vga_row;
uint16_t * vga_target;

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static uint16_t * const VGA_ADDRESS = (uint16_t *) 0xB8000;

/* VGA Text buffer format
 * LBBBFFFFAAAAAAAA
 * bits 0-7 ASCII code
 * bits 8-11 foreground color
 * bits 12-14 background color
 * bit 15 blink or bg color bit 3 on some hardware
 */

static inline uint16_t vga_toEntry(unsigned char character, uint8_t bg, uint8_t fg) {
	uint8_t color = bg << 4 | fg;
	return (uint16_t) character | (uint16_t) color << 8;
}

void vga_clear(uint8_t color);

void vga_initialize(void);

void vga_print(const char * data);

void vga_putChar(uint16_t entry);

void vga_putCharAt(uint16_t entry, uint32_t x, uint32_t y);

void vga_seek(uint32_t x, uint32_t y);

#endif
