#include <stdio.h>
#include <unistd.h>

process fanout_one(chan<int> o, int x) {
  o ! x;
}

process fanout(chan<int> c, chan<int> o1, chan<int> o2, chan<int> o3, chan<int> o4) {
  int x;
  c ? x;
  par {
    fanout_one(o1, x);
    fanout_one(o2, x);
    fanout_one(o3, x);
    fanout_one(o4, x);
  }
  fanout();
}

process print(chan<int> c) {
  int x;
  c ? x;
  printf("%d\n", x);
  print();
}

process counter(chan<int> c @ int i) {
  c ! i;
  usleep(5e5);
  if (i < 5) {
    counter(i + 1);
  }
}

int main() {
  chan<int> x, a, b, c, d;
  par {
    counter(x @ 0);
    fanout(x, a, b, c, d);
    print(a);
    print(b);
    print(c);
    print(d);
  }
  return 0;
}
