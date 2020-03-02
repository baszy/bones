/* The bootloader will start execution at this entry point */
ENTRY(_start)

OUTPUT(kernel.bin)
 
/* Defining sections of the os image */ 
SECTIONS {

	/* Start at 1 MiB, the usual place for kernels to be loaded by the bootloader. */
	. = 1M;

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

	/* Compiler may produce other sections and put them in a section with the same name.*/
}
