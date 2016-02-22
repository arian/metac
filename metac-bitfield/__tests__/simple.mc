#include <assert.h>

// definiëer de layout van de velden
bitfields A {
  x: 3; // 'x' is de naam, 3 is het aantal bits
  y: 4;
  z: 1;
};

int main() {

  bitfields X {
    x: 3;
    y: 4;
    z: 1;
  };

  // declareer een variabele a voor layout A
  X a;
  // zet veld naar waarde 1
  a.z = 1;
  // test dat de bit inderdaad is aangepast
  assert((a & 1) == a.z);
  // veld x met 3 bits krijgt waarde 6
  a.x = 6;
  a.y = a.x;
  return 0;
}
