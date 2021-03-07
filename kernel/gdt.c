#include "gdt.h"

// Only these bits in the flags bytes should be modifiable
#define GDT_ENTRY_SAFETY_MASK 0b1100000011111111

gdt_entry create_gdt_entry(uint32_t base, uint32_t limit, uint16_t flags) {
    gdt_entry result = 0;
    result |= (uint64_t)(limit & 0x0ffff); // Lower 16 bits of limit
    result |= (uint64_t)(base & 0x00ffffff) << 16; // Lower 24 bits of base
    result |= (uint64_t)(flags & GDT_ENTRY_SAFETY_MASK) << 40; // Access byte
    result |= (uint64_t)(limit & 0xf0000) << 32; // Upper 4 bits of limit
    result |= (uint64_t)(base & 0xff000000) << 32; // Upper 8 bits of base
    return result;
}
