# Source files
OBJECTS = src/boot.o src/com.o src/io.o src/itoa.o src/kernel.o src/strlen.o src/vga.o

CRTI = src/crti.o
CRTN = src/crtn.o

# Target executable
BINARY = kernel.bin
TARGET = i686-elf

BINDIR = ../cross/bin/
CC := $(BINDIR)/$(TARGET)-gcc
AS := nasm
LD := $(CC)

# Linker script
LINKLD = link.ld

CFLAGS = -Iinclude/ -g -ffreestanding -Wall -Wextra -fno-exceptions
ASFLAGS = -felf32 -w+orphan-labels
LDFLAGS = -g -ffreestanding -nostdlib -lgcc

# Autogenerate object files
CRTBEGIN := $(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND := $(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)

.PHONY: all clean

.SUFFIXES:
.SUFFIXES: .c .o 
.SUFFIXES: .asm .o

all: $(BINARY)

.c.o:
	$(CC) -c $< -o $@ $(CFLAGS)

.asm.o:
	$(AS) $< -o $@ $(ASFLAGS)

$(BINARY): $(CRTI) $(CRTBEGIN) $(OBJECTS) $(CRTEND) $(CRTN)
	$(LD) -T $(LINKLD) -o $(BINARY) $(CRTI) $(CRTBEGIN) $(OBJECTS) $(CRTEND) $(CRTN) $(LDFLAGS)

clean:
	rm $(BINARY) $(CRTI) $(CRTN) $(OBJECTS) -rf
