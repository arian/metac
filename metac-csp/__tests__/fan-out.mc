#include <stdio.h>
#include <unistd.h>

process fanout(chan<int> c, chan<int> *outs) {
  while (1) {
    int x, i = 0;
    c ? x;
    while (1) {
      chan<int> out = outs[i++];
      if (out != NULL) {
        out ! x;
      } else {
        break;
      }
    }
  }
}

process print(chan<int> c) {
  while (1) printf("%d\n", c?);
}

process counter(chan<int> c) {
  int i = 0;
  while (1) {
    c ! i++;
    usleep(5e5);
  }
}

int main() {
  chan<int> x, a, b, c, d;
  chan<int> xs[5] = {a, b, c, d, NULL};
  par {
    counter(x);
    fanout(x, xs);
    print(a);
    print(b);
    print(c);
    print(d);
  }
  return 0;
}
