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

  // further defined in type-relations
  0 <lt: 1

type functions

  // defined further in type-functions.str
  length: [] -> 0

type rules

  BlockInitializer([]): Array(Int32(), Some(0))
  BlockInitializer(b@[x | _]): Array(t, Some(len))
    where x : t
    and <length> b => len

  d@VarDeclaration(_, _, _, Some(init)) :-
    where init : it
      and definition of d : t
      and (it <is-assignable: t)
        else error $[Incompatible types when initializing variable of type [t] using an expression of type [it]] on init
      or (
        it => Array(_, Some(init-array-size))
        and t => Array(_, Some(decl-array-size))
        and not (decl-array-size <lt: init-array-size)
          else error $[excess elements in array initializer] on init
      )
