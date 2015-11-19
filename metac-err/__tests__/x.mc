MaybeError<int32,uint8> f(uint8 a) {
  if (a == 0) return Error(1 + 2);
  return a;
}
void h() {
  attempt[a] {
    uint8 x ?= f(1);
  } fail (uint8 a) {
    a;
  }
}
