#include <stdio.h>
#include <assert.h>

MaybeError<uint8,uint16> f(uint8 test, uint16 err) {
  if (test) return test;
  else return Error(err);
}

MaybeError<uint8, float32> h(uint8 x) {
  if (x <= 1) return x;
  return Error(10.0);
}

uint8 g(uint8 b, uint16 c) {
  uint16 result;
  attempt {
    uint8 a ?= f(b, c);
    uint8 x ?= h(b);
    result = a;
  } fail (uint16 e) {
    result = e;
  } fail (float32 e) {
    result = (uint8) e * 2;
  }
  return result;
}

int main() {
  assert(g(0, 31) == 31);
  assert(g(1, 1) == 1);
  assert(g(2, 2) == 20);

  puts("all done\n");
  return 0;
}
