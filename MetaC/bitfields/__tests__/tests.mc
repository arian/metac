#include <assert.h>
#include <stdio.h>

bitfields A {
  a: 3;
  b: 3;
  c: 2;
};

int main() {
  A a;

  // set the 2 LSB to 1
  a.c = 3;
  assert(a == 3);

  assert(a.a == 0);
  assert(a.b == 0);
  assert(a.c == 3);

  a.a = 1;
  assert(a.a == 1);
  assert(a.b == 0);
  assert(a.c == 3);

  a.b = a.a;
  assert(a.a == 1);
  assert(a.b == 1);
  assert(a.c == 3);

  puts("all successful\n");

  return 0;
}
