
#include <assert.h>

bitfields x {
  a: 1;
  b: 7;
};

int main() {
  x a;
  a.b = a.b + 1;
}
