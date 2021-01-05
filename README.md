# bones kernel
A small kernel built for learning bare-metal programming. Name subject to
change.

![All VGA text mode color combinations](https://raw.githubusercontent.com/baszy/bones/master/screenshots/boot.png)

## Features
- BIOS bootloader
- VGA text mode printing in all 16 colors visible to the human eye
- Basic serial console input and output

## Download
Visit the releases page to download a pre-built "floppy" image.

## Running
The kernel has only been tested in QEMU so far. It may be possible to run on
real hardware as long as it supports plain BIOS booting. Otherwise, you can
test it in QEMU by running:
```
qemu-system-i386 -drive file=bones-xyz.bin,format=raw
```

## Building
Requirements:
- nasm (2.00 or newer)

In order to build, you must have a gcc cross-compiler and toolchain targeting
the i686-elf architecture, built with sysroot support (`--with-sysroot`). By
default, the makefile searches `../cross/bin/`, but the path to these binaries
can be specified on the command line:
```
make BIN_DIR="/path/to/toolchain/bin"
```
You can build the entire kernel and bootloader by running `make all install
image`. The makefile will generate an unformatted and unpartitioned disk image
using `dd`, which can be directly booted in QEMU or possibly even on real
hardware. The image is simply formatted as follows:
```
.----------------------.
| Boot sector          |
|----------------------|
|                      |
| Core bootloader code |
|                      |
|----------------------|
|                      |
| Kernel code          |
|                      |
'----------------------'
```

## Contributing
Contributions are appreciated! Please read the short [style guide](STYLE.md)
before making a pull request.
