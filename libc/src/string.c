#include "string.h"

char * strcpy(char * destination, const char * source) {
    char * result = destination;

    while (*(destination++) = *(source++));

    return result;
}

size_t strlen(const char * string) {
	size_t result = 0;

	while (string[result])
		result++;

	return result;
}
