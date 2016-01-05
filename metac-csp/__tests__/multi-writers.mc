#include <stdio.h>
#include <unistd.h>

process print(char *label, chan<char> c, chan<int> c2) {
  while (1) {
    char foo = c?;
    printf("%s %c\n", label, foo);
    c2 ! 0;
  }
}

process writer(char label, int delay, chan<char> c, chan<int> c2) {
  while (1) {
    usleep(delay);
    c ! label;
    c2?;
    printf("%c\n", label);
  }
}

int main() {
  chan<char> c;
  chan<int> c2;
  par {
    print("P", c, c2);
    writer('A', 10e4, c, c2);
    writer('B', 10e4, c, c2);
    writer('C', 10e4, c, c2);
  }
  return 0;
}
