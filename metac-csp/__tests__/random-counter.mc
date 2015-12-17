#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

process counter(chan<int> up, chan<int> down) {
  int counter, v;
  while (1) {
    alts {
      case up: counter++;
      case down ? v: counter -= v;
    }
    printf("counter: %d\n", counter);
  }
}

process random_thing(chan<int> c) {
  while (1) {
    c ! 1;
    usleep((rand() % 1000) * 100);
  }
}

int main() {
  chan<int> up;
  chan<int> down;
  par {
    random_thing(up);
    random_thing(down);
    counter(up, down);
  }
  return 0;
}
