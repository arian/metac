module MetaC/err/trans/types

imports

  include/-
  lib/runtime/nabl/-
  lib/runtime/task/-
  lib/runtime/types/-
  lib/runtime/properties/-
  lib/runtime/relations/-
  BaseC/trans/types/-
  BaseC/trans/desugar/-
  MetaC/err/trans/-

type rules

  d@ErrVarDeclaration(_, _, Call(fn, params)) :-
    where
      (
           fn : FunType(ErrMaybeError(Type(_, it), _, _))
        or fn : FunType(it)
      )
      and definition of d : t
      and (t <is-assignable: it)
        else error $[Incompatible types when initializing type [t] using type [it]]  on fn
