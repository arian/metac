int interrupts_init();
void interrupts_set(int, void (*fn)());
int interrupts_close();

char *evval[];

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

typedef enum {
  KEYBOARD_ISR,
  MOUSE_ISR
} isr_t;
