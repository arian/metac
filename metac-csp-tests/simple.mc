#include <stdio.h>

struct x { int a, b; };

process P(chan<int> c, chan<struct x> c2) {
  struct x a;
  a.a = 1;
  c ! 1;
  c2 ! a;
}
process C(chan<int> c, chan<struct x> c2) {
  int a;
  struct x b;
  c ? a;
  c2 ? b;
  printf("%d %d\n", a, b.a);
}

int main() {
  chan<int> c;
  chan<struct x> c_;
  par {
    P(c, c_);
    C(c, c_);
  }
  return 0;
}
