MaybeError<uint8,int32> f(uint8 test) {
  return Error(1);
}
MaybeError<uint8,int16> g(uint8 test) {
  return Error(1);
}


int8 h() {
  attempt {
    uint8 a ?= f();
    uint8 c ?= f();
    uint8 b ?= g();
  } fail (int16 a) {
    a + 1;
  } fail (int32 b) {
    b + 2;
  }
}
