#include <assert.h>

bitfields A {
  x: 4;
  y: 4;
};

struct x {};

int main() {
  uint32 number = 0;
  A *a = &number;
  A *b = a;

  a->x = 1;
  assert(number == 16);

  a->y = 4;
  assert(number == 20);

  return 0;
}
