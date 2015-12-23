#include <stdio.h>
#include <unistd.h>

process fanin4(chan<int> out, chan<int> a, chan<int> b, chan<int> c, chan<int> d) {
  while (1) {
    int x;
    alts {
      case a ? x: out ! x;
      case b ? x: out ! x;
      case c ? x: out ! x;
      case d ? x: out ! x;
    }
  }
}

process print(chan<int> c) {
  while (1) {
    int x;
    c ? x;
    printf("%d\n", x);
  }
}

process counter(chan<int> c, int delay) {
  int i = 0;
  while (1) {
    c ! i++;
    usleep(delay);
  }
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
