#include <assert.h>

bitfields A { x: 3; y: 2; z: 2; };

void f() {
  A a;
  a.z = 1;
  a.x = 7;
  printf("%d", a.z + z.x);
}
