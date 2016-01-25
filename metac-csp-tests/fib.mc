#include <stdio.h>

process fib(chan<int> out, chan<int> quit) {
  int a = 0, b = 1, f;
  int q = 0;
  while (!q) {
    f = a + b;
    out ! f;
    a = b;
    b = f;
    quit ? q;
  }
}

process print_fib_to(chan<int> fib, chan<int> quit, int n) {
  int f = 0;
  while (1) {
    fib ? f;
    if (f < n) {
      quit ! 0;
      printf("%d\n", f);
    } else {
      quit ! 1;
      break;
    }
  }
}

int main() {
  chan<int> fib_chan;
  chan<int> quit;
  par {
    print_fib_to(fib_chan, quit, 3000);
    fib(fib_chan, quit);
  }
  return 0;
}
