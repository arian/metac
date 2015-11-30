#include <stdio.h>

// For example with a fixed size stack, there are only
// 10 available spaces.
const int32 SIZE = 10;
int32 stack[10];
// pointer contains the next write position
int32 sptr = 0;
// define errors
enum empty_error {empty};
enum full_error {full};
// add a value to the stack.
// this MaybeError<void> is a parameterized type. C doesn't know this
// kind of types at all, so this needs some hard-coding or bike-shedding.
MaybeError<void, enum empty_error> push(int32 x) {
  if (sptr < SIZE) {
    stack[sptr++] = x; // success, return void
  } else {
    // no space anymore, signal the caller by returning None()
    return Error(full);
  }
}

// get the latest value, if one exists
MaybeError<int32, enum empty_error> pop() {
  if (sptr > 0) {
    return stack[--sptr];
  } else {
    return Error(empty);
  }
}

// consumer end
void main() {
  // using fail-attempt here. Using the Maybe type, it's a bit like
  // the >>= (bind) operator or do notation in Haskell for Monads.
  // fail-attempt might be a bit confusing for C++/Java/Rest-of-the-world.
  attempt {
    void p1 ?= push(1);
    void p2 ?= push(2);
    int32 last1 ?= pop(); // unpack the Maybe
    printf("%d\n", last1); // and use directly
    int32 last2 ?= pop();
    int32 last3 ?= pop(); // oops, None returned, go to the catch
  } fail (enum full_error e) {
    printf("The stack is full\n");
  } fail (enum empty_error e) {
    printf("The stack is empty\n");
  }
}
