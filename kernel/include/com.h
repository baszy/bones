#ifndef _COM_H
#define _COM_H

#include <stdint.h>
#include <stdbool.h>

typedef uint16_t com_port;

char com_get_byte(com_port port);

com_port com_get_port_bda(int index);

void com_initialize(com_port port, unsigned int baud);

void com_print(com_port port, const char * data);

void com_put_byte(com_port port, char data);

void com_start_port(com_port port, unsigned int baud);

bool com_valid_port(com_port port);

#endif
