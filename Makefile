# Top level Makefile

export ROOT_DIR := $(CURDIR)/root/

export BOOT_DIR := /boot/
export INCLUDE_DIR := /include/
export LIBRARY_DIR := /lib/

export TARGET = i686-elf
export IMAGE_FILE = bones-$(TARGET).img

BIN_DIR ?= $(CURDIR)/../../program/cross/bin/
export AR := $(BIN_DIR)/$(TARGET)-ar
export AS := nasm # $(BIN_DIR)/$(TARGET)-as
export CC := $(BIN_DIR)/$(TARGET)-gcc --sysroot=$(ROOT_DIR) -isystem=$(INCLUDE_DIR)
export LD := $(CC)

export CFLAGS ?= -g -O2 -ffreestanding -Wall -Wextra -fno-exceptions
export ASFLAGS ?= -w+orphan-labels -w-zeroing
export LDFLAGS ?= -g -ffreestanding -nostdlib

.PHONY: all clean install iso

all:
	$(MAKE) -C libc/ all
	$(MAKE) -C libc/ install
	$(MAKE) -C boot/ all
	$(MAKE) -C boot install
	$(MAKE) -C kernel/ all
	$(MAKE) -C kernel/ install

clean:
	$(MAKE) -C libc/ clean
	$(MAKE) -C boot/ clean
	$(MAKE) -C kernel/ clean
	rm $(IMAGE_FILE) -rf

install: all

# TODO: Hardcoded block counts in these files
image: install
	dd if=boot/boot.bin of=$(IMAGE_FILE) bs=512 count=1
	dd if=boot/start.bin of=$(IMAGE_FILE) bs=512 count=1 seek=1
	dd if=root/boot/bones-i686-elf.bin of=$(IMAGE_FILE) bs=512 count=41 seek=2
