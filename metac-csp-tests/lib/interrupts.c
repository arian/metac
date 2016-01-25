#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <linux/input.h>
#include <string.h>
#include <stdio.h>
#include <pthread.h>
#include "./interrupts.h"

peripherals_t peripherals;

void (*keyboard_fn)() = NULL;
void (*mouse_fn)() = NULL;

void * keyboard_thread() {
  const char *dev = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  struct input_event ev;
  ssize_t n;
  int fd;

  fd = open(dev, O_RDONLY);
  if (fd == -1) {
    fprintf(stderr, "Cannot open %s: %s.\n", dev, strerror(errno));
    return NULL;
  }

  while (1) {
    n = read(fd, &ev, sizeof ev);
    if (n == (ssize_t) - 1) {
      if (errno == EINTR) {
        continue;
      } else {
        break;
      }
    } else if (n != sizeof ev) {
      errno = EIO;
      break;
    }

    if (ev.type == EV_KEY && ev.value >= 0 && ev.value <= 2) {
      peripherals.keyboard_type = ev.value;
      peripherals.keyboard_code = ev.code;
      if (keyboard_fn != NULL) {
        keyboard_fn();
      }
    }
  }
  fflush(stdout);
  fprintf(stderr, "%s.\n", strerror(errno));
}

void * mouse_thread() {
  int fd, bytes;
  unsigned char data[3];

  const char *pDevice = "/dev/input/mice";

  // Open Mouse
  fd = open(pDevice, O_RDWR);
  if (fd == -1) {
    printf("ERROR Opening %s\n", pDevice);
    return NULL;
  }

  int left, middle, right;
  signed char x, y;
  while (1) {
    // Read Mouse
    bytes = read(fd, data, sizeof(data));

    if (bytes > 0) {
      peripherals.mouse_left = data[0] & 0x1;
      peripherals.mouse_right = data[0] & 0x2;
      peripherals.mouse_middle = data[0] & 0x4;
      peripherals.mouse_x = data[1];
      peripherals.mouse_y = data[2];
      if (mouse_fn != NULL) {
        mouse_fn();
      }
    }
  }
}


pthread_t keyboard_th;
pthread_t mouse_th;

int interrupts_init() {

  if (pthread_create(&keyboard_th, NULL, &keyboard_thread, NULL) != 0) {
    return 1;
  }

  if (pthread_create(&mouse_th, NULL, &mouse_thread, NULL) != 0) {
    perror("pthread_create mouse");
    return 1;
  }

  return 0;
}

void interrupts_set(isr_t type, void (*fn)()) {
  switch (type) {
    case KEYBOARD_ISR:
      keyboard_fn = fn;
      break;
    case MOUSE_ISR:
      mouse_fn = fn;
      break;
    default:
      break;
  }
}

int interrupts_close() {
  if (pthread_join(keyboard_th, NULL)) {
    perror("pthread_join keyboard");
    return 2;
  }

  if (pthread_join(mouse_th, NULL)) {
    perror("pthread_join mouse");
    return 2;
  }
  return 0;
}

