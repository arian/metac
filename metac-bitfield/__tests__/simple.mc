#include <assert.h>

// definiëer de layout van de velden
bitfields A {
  x: 3; // 'x' is de naam, 3 is het aantal bits
  y: 2;
  z: 2;
};

void f(A *x) {
  x->x = 2;
}

int main() {

  // declareer een variabele a voor layout A
  A a;
  // zet veld naar waarde 1
  a.z = 1;

  uint8 x = 1;
  A b = a;

  b.x = 3;

  // test dat de bit inderdaad is aangepast
  assert(a == 1);
  // veld x met 3 bits krijgt waarde 6
  a.x = 6;
  a.y = 10;

  assert(a.x == 6);
  assert(a.y == 2);

  return 0;
}
