#include <stdio.h>
#include <unistd.h>
#include <time.h>

process buffer(chan<int> p, chan<int> c, chan<int> request_c, chan<int> close) {
  int bufsize = 10;
  int buf[10];
  int in = 0, out = 0, running = 1, x;
  while (running) {
    alts {
      case close: running = 0;
      case [in < out + bufsize] p ? x: buf[in++ % bufsize] = x;
      case [out < in] request_c: c ! buf[out++ % bufsize];
    }
  }
}
process P(chan<int> c) {
  int i;
  for (i = 0; i < 25; i++) {
    c ! i;
    if ((i+1) % 5 == 0) usleep(10e6);
  }
}
process C(chan<int> in, chan<int> request_c, chan<int> close) {
  int i = 0, x;
  while (1) {
    request_c ! 1;
    in ? x;
    printf("C: %03d %d\n", ((int) time(NULL)) % 100, x);
    usleep(1e6);
    if (++i == 25) {
      close ! 1;
      break;
    }
  }
}
int main() {
  chan<int> p, c, req, close;
  par {
    P(p);
    C(c, req, close);
    buffer(p, c, req, close);
  }
  return 0;
}
