#include <stdio.h>

typedef enum {cent50, euro1} Coin;

statemachine VendingMachine {
  init empty;
  event make_selection(int selection);
  event input_coin(Coin coin);
  int selected = 0;
  state empty {
    on make_selection / {
      selected = selection;
    } -> accept_coins;
  }
  state accept_coins {
    on input_coin [ coin == cent50 ] -> has_50cents;
    on input_coin [ coin == euro1 ] -> dispence;
  }
  state has_50cents {
    on input_coin [ coin == cent50 ] -> dispence;
  }
  state dispence {
    entry { printf("dispencing %d\n", selected); }
  }
}


int main() {
  statemachine VendingMachine vm;
  vm<|input_coin(cent50);
  vm<|make_selection(4);
}
