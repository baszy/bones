#include "com.h"
#include "stdlib.h"
#include "vga.h"

void start_kernel(void) {
	vga_initialize();
	vga_print("VGA console established\n");

	for (uint8_t fg = 0; fg < 16; fg++) {
		for (uint8_t bg = 0; bg < 16; bg++) {
			vga_putChar(vga_toEntry('X', bg, fg));
		}
		vga_print("\n");
	}

	com_initialize(0x03F8);
	com_print(0x03F8, "Serial console initialized\n");
}
