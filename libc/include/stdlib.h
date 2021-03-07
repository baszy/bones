#ifndef _STDLIB_H
#define _STDLIB_H

#include <stdint.h>

#define abs(x) ((x) < 0 ? -(x) : (x))

#ifdef __cplusplus
extern "C" {
#endif

char * itoa(uint64_t value, char * str, uint32_t base);

#ifdef __cplusplus
}
#endif

#endif
