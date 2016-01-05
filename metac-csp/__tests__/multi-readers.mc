#include <stdio.h>
#include <unistd.h>

process print(char *label, int delay, chan<int> c) {
  while (1) {
    int x;
    /*alts {
      case c ? x: */c ? x; printf("%s %d\n", label, x);
    //}
    usleep(delay);
  }
}

process counter(int delay, chan<int> c) {
  int i = 0;
  while (1) {
    c ! i++;
    usleep(delay);
  }
}

int main() {
  chan<int> c;
  par {
    print("A", 10e4, c);
    print("B", 11e4, c);
    print("C", 12e4, c);
    print("D", 13e4, c);
    counter(20e4, c);
  }
  return 0;
}
