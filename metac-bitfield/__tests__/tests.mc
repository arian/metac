#include <assert.h>
#include <stdio.h>

bitfields A {
  a: 3;
  b: 3;
  c: 2;
};

void test_local_bitfields_variable() {
  A a;
  A *b = &a;

  // set the 2 LSB to 3 via the pointer field expression
  b->c = 3;

  // this doesn't actually change anything, as it should
  // refer to the exact same thing
  a.c = b->c;
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

  puts("local bitfields variable successful\n");
}

void test_pointer_bitfields() {
  uint32 a_ = 0;
  A *a = &a_;
  a->a = 1;
  assert(a->a == 1);
  puts("pointer bitfields variable successful\n");
}

int main() {
  test_local_bitfields_variable();
  test_pointer_bitfields();
  return 0;
}
