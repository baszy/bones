#ifndef _GDT_H
#define _GDT_H

#include <stdint.h>

// Defines whether the segment is available or not. This is set automatically
// by the ........ function
#define GDT_SEGMENT_PRESENT 0b10000000

// Defines which ring this segment can be accessed from
#define GDT_SEGMENT_ACCESS_RING0 0b00000000
#define GDT_SEGMENT_ACCESS_RING1 0b00100000
#define GDT_SEGMENT_ACCESS_RING2 0b01000000
#define GDT_SEGMENT_ACCESS_RING3 0b01100000

// Defines whether the segment is a regular one like code or data or if it is
// a system segment like a task state segment
#define GDT_SEGMENT_TYPE_SYSTEM 0b00000000
#define GDT_SEGMENT_TYPE_NORMAL 0b00010000

// Defines whether the segment is a code segment or a data segment
#define GDT_SEGMENT_TYPE_DATA 0b00000000
#define GDT_SEGMENT_TYPE_CODE 0b00001000

// Defines whether the segment grows up or grows down. If it grows down then
// offset must be greater than limit
#define GDT_SEGMENT_GROWS_UP   0b00000000
#define GDT_SEGMENT_GROWS_DOWN 0b00000100

// Whether or not code in this segment can be executed from a lower ring
#define GDT_SEGMENT_CONFORM_DISABLED 0b00000000
#define GDT_SEGMENT_CONFORM_ENABLED  0b00000100

// Controls whether a code segment is readable and whether a data segment is
// writeable. Note that only code can be executed and only data can be written
#define GDT_SEGMENT_EXEC_ONLY 0b00000000
#define GDT_SEGMENT_READABLE  0b00000010
#define GDT_SEGMENT_READ_ONLY 0b00000000
#define GDT_SEGMENT_WRITABLE  0b00000010

// Set by the cpu when a segment is currently being accessed. This is set
// automaticallly byu the ........ function
#define GDT_SEGMENT_ACCESS_CLEAR 0b00000000
#define GDT_SEGMENT_ACCESS_SET   0b00000001

// Controls the unit size of the segment
#define GDT_SEGMENT_UNIT_BYTES     0b0000000000000000
#define GDT_SEGMENT_UNIT_4K_PAGES  0b1000000000000000

// Controls the mode of the segment
#define GDT_SEGMENT_MODE_REAL      0b0000000000000000
#define GDT_SEGMENT_MODE_PROTECTED 0b0100000000000000

typedef uint64_t gdt_entry;

gdt_entry create_gdt_entry(uint32_t base, uint32_t limit, uint16_t flags);

#endif
