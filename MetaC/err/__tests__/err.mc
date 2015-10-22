
MaybeError<volatile int8> f() {
  return Error();
}

int8 h(int32 a) {
  return 1;
}

int main() {
  int32 *z = &h();
  attempt {
    int32 x <= f();
    int32 y = h();
    return x + y;
  } fail {
    return -1;
  }
}
