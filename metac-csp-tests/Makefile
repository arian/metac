
CC ?= gcc
CFLAGS = -I$(LIBCSP_SRCDIR) -Ilib -Wall -pthread
LFLAGS = -L$(LIBCSP_SRCDIR) -lcsp

LIBCSP_DIR = libcsp
LIBCSP_SRCDIR = $(LIBCSP_DIR)/src
LIBFILES = $(LIBCSP_SRCDIR)/libcsp.a
LIBINT = lib/libinterrupts.a

SOURCES = $(wildcard *.c)
TARGETS = $(SOURCES:.c=)

all: $(TARGETS)

$(LIBFILES):
	if [ ! -d "$(LIBCSP_DIR)" ]; then git clone https://github.com/arian/libcsp.git; fi
	cd "$(LIBCSP_SRCDIR)" && touch depends.mk && $(MAKE)

$(LIBINT):
	$(CC) -c lib/interrupts.c -o lib/interrupts.o
	ar cq $@ lib/interrupts.o

inputs: inputs.c lib/libinterrupts.a $(LIBFILES)
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS) -Llib -linterrupts

%: %.c $(LIBFILES)
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

clean:
	rm -rf $(LIBCSP_DIR) $(LIBINT) $(TARGETS)

.PHONY: clean all
