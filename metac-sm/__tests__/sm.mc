#include <assert.h>

enum state {on, calibrate, flying, off};

statemachine X {
  init off;

  enum state state;
  uint8 calibrated;
  uint8 speed;

  event onoff();
  event calibrate();
  event fly(uint8 input_speed);
  event land();

  state on {
    entry { state = on; }
    on onoff -> off;
    on calibrate -> calibrate;
    on fly [calibrated == 1] / speed = input_speed; -> flying;
  }

  state calibrate {
    entry { state = calibrate; calibrated = 1; }
    on -> on;
  }

  state flying {
    entry { state = flying; }
    on land -> on;
  }

  state off {
    entry {
      state = off;
      calibrated = 0;
    }
    on onoff -> on;
  }
}

int32 main() {

  statemachine X x;

  assert(x|>state == off);

  x<|onoff();
  assert(x|>state == on);

  // can't go to flying if it's not calibrated
  x<|fly(10);
  assert(x|>state == on);

  // calibrate, directly go to the on state again
  x<|calibrate();
  assert(x|>state == on);
  assert(x|>calibrated == 1);

  // now we can go to flying
  x<|fly(20);
  assert(x|>state == flying);
  assert(x|>speed == 20);

  x<|land();
  assert(x|>state == on);

  x<|onoff();
  assert(x|>state == off);

  return 0;
}