module BaseC-Type-Declarations

imports

  include/-
  lib/runtime/nabl/-
  lib/runtime/task/-
  lib/runtime/types/-
  lib/runtime/properties/-
  lib/runtime/relations/-
  BaseC/trans/desugar/-
  BaseC/trans/types/-

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
      and (t <is-assignable: it)
        else error $[Incompatible types when initializing type [t] using type [it]]  on init
