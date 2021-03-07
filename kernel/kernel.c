#include "com.h"
#include "gdt.h"
#include "stdlib.h"
#include "string.h"
#include "vga.h"

void com_print_header(com_port port, const char * title) {
    size_t length = strlen(title);

    if (length > 80) {
        com_print(port, title);
        return;
    }

    int dash_count = (80 - length) / 2;

    // Generate the actual string
    for (int i = 0; i < dash_count; i++) {
        com_put_byte(port, (i % 2) ? '-' : ' ');
    }
    com_print(port, title);
    for (int i = 0; i < dash_count; i++) {
        com_put_byte(port, (i % 2) ? '-' : ' ');
    }
    com_put_byte(port, '\n');
}

void start_kernel(void) {
    vga_initialize();
    vga_clear(VGA_COLOR_WHITE);

    vga_print("VGA text mode test\n");

    for (uint8_t fg = 0; fg < 16; fg++) {
        for (uint8_t bg = 0; bg < 16; bg++) {
            vga_put_char(vga_to_entry('A' + bg + fg, bg, fg));
        }
        vga_print("\n");
    }

    gdt_entry entry = create_gdt_entry(0xaaaaaaaa, 0xfffff,
            GDT_SEGMENT_ACCESS_RING0 | GDT_SEGMENT_TYPE_NORMAL | GDT_SEGMENT_TYPE_DATA | GDT_SEGMENT_GROWS_UP |
            GDT_SEGMENT_CONFORM_DISABLED | GDT_SEGMENT_READ_ONLY | GDT_SEGMENT_UNIT_BYTES | GDT_SEGMENT_MODE_PROTECTED);
    //vga_print(amit);

    com_port com0 = com_get_port_bda(0);
    com_initialize(com0, 38400);

    const char * source = "HELLO BROTHER\r\n";
    char dest[20];
    strcpy(dest, source);

    com_print(com0, source);
    com_print(com0, dest);

    vga_print(source);
    vga_print(dest);
}
