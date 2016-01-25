
LIBCSP_DIR = libcsp-master
LIBCSP_SRCDIR = $(LIBCSP_DIR)/src
LIBFILES = $(LIBCSP_SRCDIR)/libcsp.a

CC ?= gcc
CFLAGS = -I$(LIBCSP_SRCDIR) -Ilib -Wall -pthread

LIBFILES = $(LIBCSP_SRCDIR)/libcsp.a

LFLAGS = -L$(LIBCSP_SRCDIR) -lcsp

SOURCES = $(wildcard *.c)
TARGETS = $(SOURCES:.c=)

all: $(TARGETS)

libcsp.tar.gz:
	wget https://github.com/arian/libcsp/archive/master.tar.gz -O libcsp.tar.gz

$(LIBFILES): libcsp.tar.gz
	if [ ! -d "$(LIBCSP_DIR)" ]; then tar -xvf $<; fi
	cd "$(LIBCSP_SRCDIR)" && touch depends.mk && $(MAKE)

lib/libinterrupts.a:
	$(CC) -c lib/interrupts.c -o lib/interrupts.o
	ar cq $@ lib/interrupts.o

inputs: inputs.c lib/libinterrupts.a $(LIBFILES)
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS) -Llib -linterrupts

%: %.c $(LIBFILES)
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

clean:
	rm -rf libcsp.tar.gz $(LIBCSP_DIR) $(TARGETS)

.PHONY: clean all
