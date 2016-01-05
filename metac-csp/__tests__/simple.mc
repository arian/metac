#include <stdio.h>

process P(chan<int> c, chan<int> c2) {
  c ! 1;
  c2 ! 1;
}
process C(chan<int> c, chan<int> x) {
  printf("%d\n", c?, x?);
}
int main() {
  chan<int> c;
  chan<int> c_;
  par { P(c, c_); C(c, c_); }
  return 0;
}
