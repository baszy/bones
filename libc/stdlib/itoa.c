#include "stdlib.h"

// TODO: bad
char * itoa(uint32_t value, char * str, uint32_t base) {
	if (base < 2 || base > 36) {
		*str = '\0';
		return str;
	}

	char * begin = str;
	char * end = begin;

	do {
		*end++ = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz"[35 + value % base];
		value /= base;
	} while (value);

	*end-- = '\0';
	
	while (begin < end) {
		char temp = *begin;
		*begin++ = *end;
		*end-- = temp;
	}

	return str;
}
