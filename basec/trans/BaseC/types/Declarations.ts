module BaseC/types/Declarations

imports

  include/-
  runtime/nabl/-
  runtime/task/-
  runtime/types/-
  runtime/properties/-
  runtime/relations/-
  BaseC/desugar/-
  BaseC/types/-

relations

  // define a <is-assignable: relation, so it can be used in .ts files without
  // errors. The actual implementation is in the .str file.
  None() <is-assignable: None()

type rules

  BlockInitializer([]): Array(Int32())
  BlockInitializer([x | _]): Array(t)
    where x : t

  d@VarDeclaration(_, _, _, _, Some(init)) :-
    where init : it
      and definition of d : t
      and (it <is-assignable: t)
        else error $[Incompatible types when initializing variable of type [t] using an expression of type [it]] on init
