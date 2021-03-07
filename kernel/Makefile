# Makefile for bones kernel

# Sources and target executable
OBJECTS = multiboot.o console/com.o video/vga.o gdt.o io.o kernel.o
BINARY = bones-$(TARGET).bin

CRTI = crti.o
CRTN = crtn.o

CFLAGS += -Iinclude/
ASFLAGS += -felf32
LDFLAGS += -lk -lgcc

# Linker script
LINKLD = link.ld

# Autogenerate object files
CRTBEGIN := $(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND := $(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)

.PHONY: all clean install install-headers install-kernel

.SUFFIXES:
.SUFFIXES: .c .o
.SUFFIXES: .asm .o

all: $(BINARY)

.c.o:
	$(CC) -c $< -o $@ $(CFLAGS)

.asm.o:
	$(AS) $< -o $@ $(ASFLAGS)

$(BINARY): $(CRTI) $(CRTBEGIN) $(OBJECTS) $(CRTEND) $(CRTN)
	$(LD) -T $(LINKLD) -o $@ $^ $(LDFLAGS)

clean:
	rm $(BINARY) $(OBJECTS) $(CRTI) $(CRTN) -rf

install: install-headers install-kernel

install-headers:
	mkdir -p $(ROOT_DIR)/$(INCLUDE_DIR)
	cp -R include/. $(ROOT_DIR)/$(INCLUDE_DIR)/.

install-kernel:
	mkdir -p $(ROOT_DIR)/$(BOOT_DIR)
	cp $(BINARY) $(ROOT_DIR)/$(BOOT_DIR)
