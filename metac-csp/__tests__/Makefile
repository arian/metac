
LIBCSP_DIR = libcsp-master
LIBCSP_SRCDIR = $(LIBCSP_DIR)/src
LIBFILES = $(LIBCSP_SRCDIR)/libcsp.a $(LIBCSP_SRCDIR)/libimscsp.a

CC = gcc -I$(LIBCSP_SRCDIR) -Wall -pthread
LIBFILES = $(LIBCSP_SRCDIR)/libcsp.a $(LIBCSP_SRCDIR)/libimscsp.a
LIBOPT = -L$(LIBCSP_SRCDIR) -limscsp -lcsp

SOURCES = $(wildcard *.c)
TARGETS = $(SOURCES:.c=)

all: $(TARGETS)

libcsp.tar.gz:
	wget https://github.com/arian/libcsp/archive/master.tar.gz -O libcsp.tar.gz

$(LIBFILES): libcsp.tar.gz
	if [ ! -d "$(LIBCSP_DIR)" ]; then tar -xvf $<; fi
	cd "$(LIBCSP_SRCDIR)" && touch depends.mk && $(MAKE)

%: %.c $(LIBFILES)
	$(CC) -o $@ $< $(LIBOPT)

clean:
	rm -rf libcsp.tar.gz $(LIBCSP_DIR) $(TARGETS)

.PHONY: clean all
