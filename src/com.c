#include "com.h"

char com_getChar(uint16_t port) {
	while ((inb(port + 5) & 1) == 0);
	return inb(port);
}

void com_initialize(uint16_t port) {
	// Disable all interrupts
	outb(0x00, port + 1);
	// Divisor setup DLAB
	outb(0x80, port + 3);
	outb(0x03, port + 0);
	outb(0x00, port + 1);
	// 8/N/1
	outb(0x03, port + 3);
	outb(0xC7, port + 2);
	outb(0x0B, port + 4);
}

void com_print(uint16_t port, const char * data) {
	for (size_t i = 0; i < strlen(data); i++) {
		com_putChar(port, data[i]);
	}
}

void com_putChar(uint16_t port, char data) {
	while ((inb(port + 5) & 0x20) == 0);
	outb(data, port);
}
