# Bones Kernel
A small kernel built for learning bare-metal programming.

![All VGA text mode color combinations](https://raw.githubusercontent.com/baszy/bones/master/screenshots/boot.png)

## Features
- VGA text mode printing in all 16 colors
- Basic serial console output
- Port I/O

## Building
No custom toolchain is required yet, just use the Makefile by running `make`,
but ensure the `BINDIR` and `TARGET` variables are set properly. Currently it
should only build for the target `i686-elf`.

## Running
Currently, the kernel only boots and runs on an emulator (although the kernel
does have Multiboot 1 support so GRUB should be easy to set up). The compiled
binary can be executed by running:
```qemu-system-i386 --kernel bones.bin --serial stdio```
