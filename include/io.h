#pragma once

#include <stdint.h>

extern uint8_t inb(uint16_t port);
extern uint16_t inw(uint16_t port);
extern uint32_t inl(uint16_t port);
extern void outb(uint8_t value, uint16_t port);
extern void outw(uint16_t value, uint16_t port);
extern void outl(uint32_t value, uint16_t port);
