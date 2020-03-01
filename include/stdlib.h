#pragma once

#include <stddef.h>
#include <stdint.h>

#define abs(x) ((x) < 0 ? -(x) : (x))

char * itoa(uint32_t value, char * str, uint32_t base);

size_t strlen(const char * string);
