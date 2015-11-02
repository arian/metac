#include <assert.h>

bitfields x {
  a: 1;
  b: 7;
};

MaybeError<int, float> error_fn(int a) {
  if (a < 0) return Error(0.0f);
  return a;
}

int main() {
  x a;
  a.b = a.b + 1;

  attempt {
    int b ?= error_fn(1);
  } fail (float e) {
    e;
  }
}
