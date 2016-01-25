#ifndef INTERRUPTS_H
#define INTERRUPTS_H

typedef enum {
  KEYBOARD_ISR,
  MOUSE_ISR
} isr_t;

static const char *const evval[3] = {
  "RELEASED",
  "PRESSED ",
  "REPEATED"
};

typedef struct {
  int keyboard_code;
  int keyboard_type;
  unsigned char mouse_x;
  unsigned char mouse_y;
  int mouse_left;
  int mouse_middle;
  int mouse_right;
} peripherals_t;

extern peripherals_t peripherals;

int interrupts_init();
void interrupts_set(isr_t, void (*fn)());
int interrupts_close();

#endif
