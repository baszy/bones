MBALIGN equ 1 << 0
MEMINFO equ 1 << 1

FLAGS equ MBALIGN | MEMINFO ; Combining flag bits

; Multiboot 1 compliant: 0x1BADB002
; Multiboot 2 compliant: 0xE85250D6
MAGIC equ 0x1BADB002

CHECKSUM equ -(MAGIC + FLAGS)

section .multiboot

align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .bss

; Defining the stack: 16Kb growing downwards
align 16
stack_bottom:
    resb 16384
stack_top:

section .text

global _start:function (_start.end - _start)
_start:
    ; Setting up the stack (put the stack pointer at the top of the stack)
    mov esp, stack_top

    ; Call global constructors
    extern _init
    call _init

    ; Call the next level of the kernel
    extern start_kernel
    call start_kernel

    ; out dx, 0x3f8

    ; Destructor
    extern _fini
    call _fini

    ; At this point, the program is finished, we will disable interrupts
    ; and hang
    cli

.hang:
    ; Halt until next interrupt, but interrupts are disabled, so only
    ; non-maskable interrupts will continue execution
    hlt

    ; Jump back in case of NMI
    jmp .hang

.end:
