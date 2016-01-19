#include <stdio.h>
#include <unistd.h>

process fanin4(chan<int> out, chan<int> a, chan<int> b, chan<int> c, chan<int> d) {
  int x;
  alts {
    case a ? x: out ! x;
    case b ? x: out ! x;
    case c ? x: out ! x;
    case d ? x: out ! x;
  }
  fanin4();
}

process print(chan<int> c) {
  int x;
  c?x;
  printf("%d\n", x);
  print();
}

process counter(chan<int> c, int delay) {
  static int i = 0;
  c ! i++;
  usleep(delay);
  counter();
}

int main() {
  chan<int> x, a, b, c, d;
  par {
    print(x);
    fanin4(x, a, b, c, d);
    counter(a, 1e5);
    counter(b, 2e5);
    counter(c, 3e5);
    counter(d, 5e5);
  }
  return 0;
}
