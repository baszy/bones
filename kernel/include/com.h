#ifndef _COM_H
#define _COM_H

#include <stddef.h>
#include <stdint.h>

#include "io.h"
#include "string.h"

char com_get_char(uint16_t port);

void com_start_port(uint16_t port);

void com_print(uint16_t port, const char * data);

void com_put_char(uint16_t port, char data);

#endif
