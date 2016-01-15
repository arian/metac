#include <stdio.h>
#include <unistd.h>
#include <time.h>

#define bufsize 10
#define numbers 20

process buffer(chan<int> p, chan<int> c, chan<int> request_c, chan<int> close @ int in, int out) {
  static int buf[bufsize];
  int x;
  alts {
    case close: ;
    case [in < out + bufsize] p ? x: {
      buf[in % bufsize] = x;
      buffer(in + 1, out);
    }
    case [out < in] request_c: {
      c ! buf[out % bufsize];
      buffer(in, out + 1);
    }
  }
}

process P(chan<int> c @ int i) {
  c ! i;
  if ((i+1) % 5 == 0) usleep(5e6);
  if (i > 0) {
    P(i - 1);
  }
}

process C(chan<int> in, chan<int> request_c, chan<int> close @ int i) {
  int x;
  request_c ! 1;
  in ? x;
  printf("C: %03d %d %d\n", ((int) time(NULL)) % 100, x, i);
  usleep(5e5);
  if (i < numbers) {
    C(i + 1);
  } else {
    close ! 1;
  }
}

int main() {
  chan<int> p, c, req, close;
  par {
    C(c, req, close @ 0);
    P(p @ numbers);
    buffer(p, c, req, close @ 0, 0);
  }
  return 0;
}
