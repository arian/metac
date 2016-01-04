#include <stdio.h>
#include <unistd.h>

process print(char *label, int delay, chan<int> c) {
  while (1) {
    printf("%s %d\n", label, c?);
    usleep(delay);
  }
}

process counter(char *label, int delay, chan<int> c) {
  int i = 0;
  while (1) {
    printf("%s %d\n", label, i);
    c ! i++;
    usleep(delay);
  }
}

int main() {
  chan<int> c;
  par {
    print("P", 1, c);
    counter("A", 10e4, c);
    counter("B", 10e4, c);
    counter("C", 10e4, c);
  }
  return 0;
}
