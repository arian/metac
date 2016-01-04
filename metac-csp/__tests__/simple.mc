#include <stdio.h>

process P(chan<int> c, chan<int> c2, int num) {
  c ! num;
  c2 ! (num * 2);
}

process C(chan<int> c, chan<int> x) {
  printf("%d\n", c?, x?);
}

int main() {
  chan<int> c;
  chan<int> c_;
  par {
    P(c, c_, 4);
    C(c, c_);
  }
  return 0;
}
