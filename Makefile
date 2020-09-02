# Top level Makefile

export ROOT_DIR := $(CURDIR)/root/

export BOOT_DIR := /boot/
export INCLUDE_DIR := /usr/include/
export LIBRARY_DIR := /usr/lib/

export TARGET = i686-elf

BIN_DIR ?= $(CURDIR)/../../program/cross/bin/
export AR := $(BIN_DIR)/$(TARGET)-ar
export AS := nasm # $(BIN_DIR)/$(TARGET)-as
export CC := $(BIN_DIR)/$(TARGET)-gcc --sysroot=$(ROOT_DIR) -isystem=$(INCLUDE_DIR)
export LD := $(CC)

export CFLAGS ?= -g -ffreestanding -Wall -Wextra -fno-exceptions
export ASFLAGS ?= -felf32 -w+orphan-labels
export LDFLAGS ?= -g -ffreestanding -nostdlib

.PHONY: all clean install

all:
	$(MAKE) -C libc/ all
	$(MAKE) -C libc/ install
	$(MAKE) -C kernel/ all
	$(MAKE) -C kernel/ install

clean:
	$(MAKE) -C libc/ clean
	$(MAKE) -C kernel/ clean

install: all
