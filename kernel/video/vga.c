#include "vga.h"

void vga_clear(uint8_t color) {
	uint16_t entry = vga_to_entry(0, color, color);
	for (uint32_t x = 0; x < VGA_WIDTH; x++) {
		for (uint32_t y = 0; y < VGA_HEIGHT; y++) {
			vga_put_char_at(entry, x, y);
		}
	}
}

void vga_initialize(void) {
	vga_column = 0;
	vga_row = 0;
	vga_target = VGA_ADDRESS;

	vga_clear(VGA_COLOR_BLACK);
}

void vga_seek(uint32_t x, uint32_t y) {
	vga_column = x;
	vga_row = y;
}

void vga_print(const char * data) {
	for (uint32_t i = 0; i < strlen(data); i++) {
		uint16_t entry = vga_to_entry(data[i], VGA_COLOR_BLACK, VGA_COLOR_LIGHT_GREY);
		vga_put_char(entry);
	}
}

void vga_put_char(uint16_t entry) {
	// Scroll / clear the terminal.
	if (vga_row == VGA_HEIGHT) {
		for (uint32_t x = 0; x < VGA_WIDTH; x++) {
			// TODO: Hack, copies one line below VGA memory into last line of
			// visible memory, hopefully it is zero
			for (uint32_t y = 1; y < VGA_HEIGHT + 1; y++) {
				uint16_t character = vga_target[x + (y * VGA_WIDTH)];
				vga_target[x + ((y - 1) * VGA_WIDTH)] = character;
			}
		}
		vga_row--;
	}

	// Handling special characters
	switch (entry & 0x00FF) {

	case '\n': {
		vga_row++;
		vga_column = 0;
		break;
	}

	case '\r': {
		vga_column = 0;
		break;
	}

	case '\b': {
		vga_column--;
		break;
	}

	default: {
		vga_put_char_at(entry, vga_column, vga_row);

		vga_column++;
		if (vga_column == VGA_WIDTH) {
			vga_row++;
			vga_column = 0;
		}

		break;
	}

	}
}

void vga_put_char_at(uint16_t entry, uint32_t x, uint32_t y) {
	uint32_t index = x + (y * VGA_WIDTH);
	vga_target[index] = entry;
}
