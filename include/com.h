#pragma once

#include <stddef.h>
#include <stdint.h>

#include "io.h"
#include "stdlib.h"

// TODO: get COM1 address from BDA
static const uint16_t * const bda = (uint16_t *) 0x0400;
static const uint16_t com1 = 0x03F8; 

char com_getChar(uint16_t port);

void com_initialize(uint16_t port);

void com_print(uint16_t port, const char * data);

void com_putChar(uint16_t port, char data);
