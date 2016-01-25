#include <stdio.h>
#include <interrupts.h>

void keyboard_isr() {
  printf("%s %d\n", evval[peripherals.keyboard_type], peripherals.keyboard_code);
}

void mouse_isr() {
  printf("(%d %d)\n", peripherals.mouse_x, peripherals.mouse_x);
}

int main() {

  if (interrupts_init() != 0) {
    perror("interrupt_init");
    return 1;
  }

  interrupts_set(KEYBOARD_ISR, &keyboard_isr);
  interrupts_set(MOUSE_ISR, &mouse_isr);

  if (interrupts_close() != 0) {
    perror("interrupt_init");
    return 1;
  }

  return 0;
}
