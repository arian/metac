module MetaC-Err/types

imports

  runtime/nabl/-
  runtime/task/-
  runtime/types/-
  runtime/properties/-
  runtime/relations/-
  signatures/MetaC-Err-sig
  BaseC/types/Constructors
  BaseC/desugar/-
  MetaC-Err/-

type rules

  d@ErrVarDeclaration(_, _, Call(fn, params)) :-
    where
      (
           fn : Function(Type(_, ErrMaybeError(Type(_, it), _, _)), _)
        or fn : Function(Type(_, it), _)
      )
      and definition of d : t
      and (it <is-assignable: t)
        else error $[Incompatible types when initializing variable of type [t] using an expression of type [it]] on fn
