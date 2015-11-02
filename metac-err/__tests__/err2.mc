#include <stdio.h>
#include <assert.h>

MaybeError<uint8> f(uint8 test) {
  if (test) return test;
  else return Error();
}

int8 g(uint8 b) {
  int8 result;
  attempt {
    uint8 a ?= f(b);
    result = a;
  } fail {
    // how ironic ;-)
    result = -1;
  }
  return result;
}

int main() {
  assert(g(0) == -1);
  assert(g(1) == 1);
  assert(g(2) == 2);

  puts("all done\n");
  return 0;
}
