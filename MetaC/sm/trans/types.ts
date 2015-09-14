module MetaC/sm/trans/types

imports

  include/-

type rules

  StateMachineField(e, Identifier(name)): t
    where definition of name: t
