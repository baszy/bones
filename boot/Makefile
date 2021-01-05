# Makefile for bones bootloader

# Target executable
BINARIES = boot.bin start.bin
DEPS = $(BINARIES:.bin=.d)

ASFLAGS += -fbin

.PHONY: all clean install

.SUFFIXES:
.SUFFIXES: .asm .bin

all: $(BINARIES)

.asm.bin:
	$(AS) -MD $(patsubst %.asm,%.d,$<) $< -o $@ $(ASFLAGS)

clean:
	rm $(BINARIES) $(DEPS) -rf

install:
	mkdir -p $(ROOT_DIR)/$(BOOT_DIR)
	cp $(BINARIES) $(ROOT_DIR)/$(BOOT_DIR)

# Makefile magic to consider dependencies for once
-include $(DEPS)
