#include "com.h"

#include <stddef.h>

#include "string.h"
#include "io.h"

char com_get_byte(com_port port) {
    while ((inb(port + 5) & 1) == 0);
    return inb(port);
}

// Read BIOS data area for serial port addresses
com_port com_get_port_bda(int index) {
    // TODO: assert(index < 5);
    const uint16_t * bda = (uint16_t *) 0x0400;
    return *(bda + index);
}

void com_initialize(com_port port, unsigned int baud) {
    if (com_valid_port(port)) com_start_port(port, baud);
}

void com_print(com_port port, const char * data) {
    for (size_t i = 0; i < strlen(data); i++) {
        com_put_byte(port, data[i]);
    }
}

void com_put_byte(com_port port, char data) {
    while ((inb(port + 5) & 0x20) == 0);
    outb(port, data);
}

void com_start_port(com_port port, unsigned int baud) {
    int divisor = 1;
    for (; (115200U / divisor) > baud; divisor++);
    // Disable interrupts
    outb(port + 1, 0x00);
    // Divisor setup
    outb(port + 3, 0x80);
    // Divisor set to 3 (115200 / 3 = 38400)
    outb(port + 0, divisor & 0xff);
    outb(port + 1, divisor >> 0x10);
    // Set bits 8, no parity, one stop bit
    outb(port + 3, 0x03);
    outb(port + 2, 0xC7);
    outb(port + 4, 0x0B);
}

bool com_valid_port(com_port port) {
    // TODO: There must be some more rigorous check than this
    return (port != 0);
}
