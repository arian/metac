#include <stdio.h>

#define REPEATS 2

process print(chan<int> read @ int count) {
  int x;
  if (count > 0) {
    read?x;
    printf("%d\n", x);
    print(count - 1);
  }
}

process foo(chan<int> write) {
  write!1;
}

process a(@int count) {
  if (count < REPEATS) {
    chan<int> c;
    par {
      foo(c);
      // foo(c);
      print(c @ 1);
    }
    a(count + 1);
  }
}

int main() {
  par { a(@0); }
  return 0;
}
