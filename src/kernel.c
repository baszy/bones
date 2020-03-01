#include "io.h"
#include "stdlib.h"
#include "vga.h"

void start_kernel(void) {
	uint16_t * bda = (uint16_t *) 0x0400;

	vga_initialize();
	vga_print("VGA console established");

	char buffer[16];
	vga_print("\nCOM1 0x"); vga_print(itoa(*(bda + 0), buffer, 16));
	vga_print("\n");

	for (uint8_t fg = 0; fg < 16; fg++) {
		for (uint8_t bg = 0; bg < 16; bg++) {
			vga_putChar(vga_toEntry('X', bg, fg));
		}
		vga_print("\n");
	}

	// TODO: Seperate serial console code

	// Disable all interrupts
	outb(0x00, *bda + 1);
	
	// Divisor setup DLAB
	outb(0x80, *bda + 3);
	outb(0x02, *bda + 0);
	outb(0x00, *bda + 1);

	outb(0x03, *bda + 3);
	outb(0xC7, *bda + 2);
	outb(0x0B, *bda + 4);

	char * data = "Serial console established\n";
	for (size_t i = 0; i < strlen(data); i++) {
		outb(data[i], *bda);
	}
}
