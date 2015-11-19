#include <stdio.h>

// A function that might fail
MaybeError<int32> safe_divide(int32 a, int32 b) {
  if (b == 0) return Error(); 
  else return (a / b);
}

void main() {
  // A function that returns a MaybeError must be
  // used inside a fail-attempt so errors are forced to
  // be handled.
  attempt {
    // this will work fine
    int32 c ?= safe_divide(4, 2);
    // this will jump to the catch block
    int32 d ?= safe_divide(4, 0);
  } fail {
    printf("an error occured\n");
  }
}
