#include <stdio.h>
#include <unistd.h>

process P(chan<int> c1, chan<uint8> c2) {
  int i = 0;
  uint8 str[15] = "hello world";
  while (1) {
    c1 ! i++;
    uint8 c;
    uint8 counter = 0;
    do {
      c2 ! (c = str[counter++]);
    } while (c != '\0');
    usleep(1e6);
  }
}

process C(chan<int> c1, chan<uint8> c2) {
  while (1) {
    int x = c1?;
    while (1) {
      int8 c = c2?;
      if (c == '\0') {
        break;
      }
      printf("%c", c);
    }
    printf("\n%d\n", x);
  }
}

int main() {
  buffered[10] chan<int> c1;
  chan<uint8> c2;
  par {
    P(c1, c2);
    C(c1, c2);
  }
  return 0;
}
