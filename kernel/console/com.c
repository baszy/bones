#include "com.h"

char com_get_char(com_port port) {
    while ((inb(port + 5) & 1) == 0);
    return inb(port);
}

// Read BIOS data area for serial port addresses
com_port com_get_port_bda(int index) {
    // TODO: assert(index < 5);
    const uint16_t * bda = (uint16_t *) 0x0400;
    return *(bda + index);
}

void com_initialize(com_port port) {
    if (com_valid_port(port)) com_start_port(port);
}

void com_print(com_port port, const char * data) {
    for (size_t i = 0; i < strlen(data); i++) {
        com_put_char(port, data[i]);
    }
}

void com_put_char(com_port port, char data) {
    while ((inb(port + 5) & 0x20) == 0);
    outb(port, data);
}

void com_start_port(com_port port) {
    // Disable all interrupts
    outb(port + 1, 0x00);
    // Divisor setup DLAB
    outb(port + 3, 0x80);
    outb(port + 0, 0x03);
    outb(port + 1, 0x00);
    // 8/N/1
    outb(port + 3, 0x03);
    outb(port + 2, 0xC7);
    outb(port + 4, 0x0B);
}

bool com_valid_port(com_port port) {
    return (port != 0);
}
