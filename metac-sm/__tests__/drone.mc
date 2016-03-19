#include <assert.h>
statemachine Drone {
  init off;

  uint8 calibrated;
  uint8 speed;

  event onoff();
  event calibrate();
  event fly(uint8 input_speed);
  event land();

  state on {
    on onoff -> off;
    on calibrate -> calibrate;
    on fly [calibrated == 1] / speed = input_speed; -> flying;
  }

  state calibrate {
    entry { calibrated = 1; }
    on -> on;
  }

  state flying {
    on land -> on;
  }

  state off {
    entry { calibrated = 0; }
    on onoff -> on;
  }
}

int32 main() {

  statemachine Drone x;

  x<|onoff();

  // can't go to flying if it's not calibrated
  x<|fly(10);

  // calibrate, directly go to the on state again
  x<|calibrate();
  assert(x|>calibrated == 1);

  // now we can go to flying
  x<|fly(20);
  assert(x|>speed == 20);

  x<|land();

  x<|onoff();

  return 0;
}