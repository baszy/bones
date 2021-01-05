/* The bootloader will start execution at this entry point */
ENTRY(_start)
 
/* Defining sections of the os image */ 
SECTIONS {

    /* Start at 0x10000 */
    /* TODO: This should be loaded at 1MiB like normal people do */
    . = 64K;

    /* First put the multiboot header so the bootloader can recognize the file */
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)

        /* Next we'll put our .text section */
        *(.text)
    }

    /* Read-only data section */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* Read and writable data (initialized) */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* Read and writable data (uninitialized) and stack */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }

    /* Compiler may produce other sections and append them */
}
