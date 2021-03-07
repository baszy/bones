#ifndef _STRING_H
#define _STRING_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

char * strcpy(char * destination, const char * source);

size_t strlen(const char * string);

#ifdef __cplusplus
}
#endif

#endif
