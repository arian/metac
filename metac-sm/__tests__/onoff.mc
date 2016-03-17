int peripheral[];
#define BUTTON_ON_OFF 0

statemachine Drone {
  init off;

  event onoff_button();
  int x;

  state off {
    on onoff_button -> on;
  }

  state on {
    on onoff_button -> off;
  }
}

int main() {
  statemachine Drone drone;

  while (1) {
    if (peripheral[BUTTON_ON_OFF]) {
      drone<|onoff_button();
      peripheral[BUTTON_ON_OFF] = 0;
      drone|>x = 3;
    }
  }
}