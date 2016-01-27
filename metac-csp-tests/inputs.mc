#include <stdio.h>
#include <interrupts.h>
#include <unistd.h>

#define MOUSE_BUFFER_SIZE 10

typedef struct mouse_diff {
  int x;
  int y;
} MouseDiff;

buffered chan<int> enters;
buffered[MOUSE_BUFFER_SIZE] chan<MouseDiff> mouse;

void keyboard_isr() {
  if (peripherals.keyboard_code == 28 && peripherals.keyboard_type == 0) {
    printf("enter\n");
    enters ! peripherals.keyboard_code;
  }
}

void mouse_isr() {
  MouseDiff md;
  md.x = peripherals.mouse_x;
  md.y = peripherals.mouse_y;
  mouse ! md;
}

process select_x_or_y(
    chan<int> keyboard_enters,
    chan<MouseDiff> mouse,
    chan<int> out @
    int direction) {
  MouseDiff md;
  usleep(1e6); // artificial delay
  alts {
    case keyboard_enters: {
      printf("switching from %d\n", direction);
      select_x_or_y(direction ? 0 : 1);
    }
    case mouse?md: {
      printf("direction %d\n", direction);
      if (direction == 1) {
        out ! md.x;
      } else {
        out ! md.y;
      }
      select_x_or_y(direction);
    }
  }
}

process print_value(chan<int> values) {
  printf("%d\n", values?);
  print_value();
}

int main() {

  if (interrupts_init() != 0) {
    perror("interrupt_init");
    return 1;
  }

  interrupts_set(KEYBOARD_ISR, &keyboard_isr);
  interrupts_set(MOUSE_ISR, &mouse_isr);

  chan<int> values;

  par {
    select_x_or_y(enters, mouse, values @ 0);
    print_value(values);
  }

  if (interrupts_close() != 0) {
    perror("interrupt_init");
    return 1;
  }

  return 0;
}
