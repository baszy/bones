# Makefile for libc and libk

# Sources and target executable
OBJECTS = stdlib/itoa.o string/strlen.o
BINARY = libk.a

CFLAGS += -Iinclude/
ASFLAGS += -felf32

.PHONY: all clean install install-headers install-libraries

.SUFFIXES:
.SUFFIXES: .c .o
.SUFFIXES: .asm .o

all: $(BINARY)

.c.o:
	$(CC) -c $< -o $@ $(CFLAGS)

.asm.o:
	$(AS) $< -o $@ $(ASFLAGS)

$(BINARY): $(OBJECTS)
	$(AR) -rcs $@ $^

clean:
	rm $(BINARY) $(OBJECTS) -rf

install: install-headers install-libaries

install-headers:
	mkdir -p $(ROOT_DIR)/$(INCLUDE_DIR)
	cp -R include/. $(ROOT_DIR)/$(INCLUDE_DIR)/.

install-libaries:
	mkdir -p $(ROOT_DIR)/$(LIBRARY_DIR)
	cp $(BINARY) $(ROOT_DIR)/$(LIBRARY_DIR)
