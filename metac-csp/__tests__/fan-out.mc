#include <stdio.h>
#include <unistd.h>

process fanout_one(chan<int> o, int x) {
  o ! x;
}

process fanout(
    chan<int> c, chan<int> stop,
    chan<int> o1, chan<int> s1,
    chan<int> o2, chan<int> s2,
    chan<int> o3, chan<int> s3) {
  int x;
  alts {
    case stop ? x: {
      par {
        fanout_one(s1, x);
        fanout_one(s2, x);
        fanout_one(s3, x);
      }
    }
    case c ? x: {
      par {
        fanout_one(o1, x);
        fanout_one(o2, x);
        fanout_one(o3, x);
      }
      fanout();
    }
  }
}

process print(char *label, chan<int> c, chan<int> stop) {
  int x;
  alts {
    case stop: ;
    case c ? x: {
      printf("%s %d\n", label, x);
      print();
    }
  }
}

process counter(chan<int> stop, chan<int> c @ int i) {
  c ! i;
  usleep(5e5);
  if (i < 2) {
    counter(i + 1);
  } else {
    stop!1;
  }
}

int main() {
  chan<int> x, stop;
  chan<int> a, b, c;
  chan<int> a_s, b_s, c_s;
  par {
    counter(stop, x @ 0);
    fanout(x, stop,
      a, a_s,
      b, b_s,
      c, c_s
    );
    print("a", a, a_s);
    print("b", b, b_s);
    print("c", c, c_s);
  }
  return 0;
}
