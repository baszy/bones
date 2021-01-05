#include "com.h"
#include "stdlib.h"
#include "vga.h"

void start_kernel(void) {
    vga_initialize();
    vga_clear(VGA_COLOR_WHITE);

    vga_print("VGA text mode test\n");

    for (uint8_t fg = 0; fg < 16; fg++) {
        for (uint8_t bg = 0; bg < 16; bg++) {
            vga_put_char(vga_to_entry('X', bg, fg));
        }
        vga_print("\n");
    }

    com_port com0 = com_get_port_bda(0);
    com_initialize(com0);
    com_print(com0, "Serial console test\n");
}
