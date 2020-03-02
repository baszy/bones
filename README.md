# Bones Kernel
A small kernel built for learning bare-metal programming.

![All VGA text mode color combinations](https://raw.githubusercontent.com/baszy/bones/master/screenshots/boot.png)

## Features
- VGA text mode printing in all 16 colors
- Basic serial console output
- Port I/O

## Building
Requirements:
```
nasm (any)
```
In order to build, you must also use a functioning cross-toolchain for i686-elf,
built with `--with-sysroot`. The path to these binaries can be specified on the
command line. By default, the program looks in `../cross/bin/`:
```
make BIN_DIR="/path/to/toolchain/bin"
```

## Running
Currently, the kernel only boots and runs on an emulator (although the kernel
does have Multiboot 1 support, and automatically builds a system root, so GRUB
should be easy to set up). The compiled binary can be executed by running:
```
qemu-system-i386 --kernel ./root/boot/bones.bin --serial stdio
```
