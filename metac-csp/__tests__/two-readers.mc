#include <stdio.h>

process print(char *label, chan<int> c) {
  while (1) printf("%s %d\n", label, c?);
}

process counter(chan<int> c) {
  int i = 0;
  while (1) c ! i++;
}

int main() {
  chan<int> c;
  par {
    print("A", c);
    print("B", c);
    counter(c);
  }
  return 0;
}
