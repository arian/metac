MaybeError<uint8,int32> g(uint8 test) {
  return Error(1);
}
int8 h() {
  attempt {
    uint8 b ?= g();
  } fail {
    1;
  }
}
