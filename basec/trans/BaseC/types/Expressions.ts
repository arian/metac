module BaseC/types/Expressions

imports

  include/-
  runtime/nabl/-
  runtime/task/-
  runtime/types/-
  runtime/properties/-
  runtime/relations/-
  BaseC/types/-
  BaseC/desugar/-

type rules

  Comma(init, middle, last): t
    where last: t

  Assign(v, _, e): et
    where
          v: tv
      and e: et
      and (et <is-assignable: tv)
        else error $[Incompatible types: [tv]; [et]] on e

  Conditional(_, true-b, false-b): t
    where
          true-b: tt
      and false-b: ft
      and (tt <widens: ft
           or ft <widens: tt)
        else error $[Incompatible types: [tt]; [ft]] on false-b
      and <promote> (tt, ft) => t

  LogicalOr(_, _)
  + LogicalAnd(_, _): UInt8()

  InclusiveOr(e1, e2)
  + ExclusiveOr(e1, e2)
  + InclusiveAnd(e1, e2): ty
    where
          e1: aty1
      and e2: aty2
      and aty1 <is: Int()
        else error "Integer expected" on e1
      and aty2 <is: Int()
        else error "Integer expected" on e2
      and <promote> (aty1, aty2) => ty

  ShiftLeft(e1, e2)
  + ShiftRight(e1, e2): t1
    where e1: t1
      and e2: t2
      and t1 <is: Int()
        else error $[Invalid operands: [t1]] on e1
      and t2 <is: Int()
        else error $[Invalid operands: [t2]] on e2

type rules

  // Pointer(e): Pointer(t)
  //   where e : t or e => t

//  TypedefName(Identifier(n)): t
//    where
//      definition of n : t'
//      and (t' : t) or (t' => t)

  Var(Identifier(e)): t'
    where
      definition of e: t
      and <resolve-typedefs> t => t'
      or <resolve-define-type> e => t'

type rules

  Add(e1, e2)
  + Subtract(e1, e2)
  + Mult(e1, e2)
  + Div(e1, e2)
  + Mod(e1, e2) : ty
    where e1: aty1
      and e2: aty2
      and aty1 <is: Numeric()
        else error "Numeric expected" on e1
      and aty2 <is: Numeric()
        else error "Numeric expected" on e2
      and <promote> (aty1, aty2) => ty

  Cast(Type(mods, t), _): t'
    where
      <resolve-typedefs> t => t'

  IncrementPrefix(e)
  + DecrementPrefix(e)
  + Increment(e)
  + Decrement(e): t
    where
          e: t
      and t <is: Numeric()
        else error "Numeric expected" on e

  Address(e): Pointer(type)
    where e: type

  Deref(e): type
    where e: Pointer(type)

  Positive(e)
  + Negative(e): t
    where e: t

  Complement(e): t
    where e: t
      and t <is: Int()
        else error "Integer type expected" on e

  Negate(e): UInt8()

  SizeofExpr(e): UInt8()
  Sizeof(e): UInt8()

  ArrayField(e, index): t'
    where (
        e: Array(t, _)
        or e: Pointer(t)
      )
      and <resolve-typedefs> t => t'
      and index: it
      and it <is: Int()
        else error "Integer expected as index" on index

  Call(e, _): t'
    where e: Function(Type(_, t), ps)
      and <resolve-typedefs> t => t'

  Field(e, Identifier(name)): t'
    where definition of name: t
      and <resolve-typedefs> t => t'

  PointerField(e, Identifier(name)): t'
    where definition of name: t
      and <resolve-typedefs> t => t'

  Paren(e): t
    where e: t

type functions

  // define dummy typedef function, it is actually implemented
  // in typedefs.str
  resolve-typedefs: None() -> None()

  resolve-define-type: None() -> None()

 // See section A6.1/A6.5 of "The C programming language"
 // TODO improve this
  promote: (t1', t2') -> t
    where (
           t1' == Char() and Int8() => t1
        or t1' => t1
      )
    and (
           t2' == Char() and Int8() => t2
        or t2' => t2
      )
    and
       ((t1 == Float64() or t2 == Float64()) and Float64() => t)
    or ((t1 == Float32() or t2 == Float32()) and Float32() => t)
    or ((t1 == UInt64()  or t2 == UInt64())  and UInt64() => t)
    or ((t1 == Int64()   or t2 == Int64())   and Int64() => t)
    or ((t1 == UInt32()  or t2 == UInt32())  and UInt32() => t)
    or ((t1 == Int32()   or t2 == Int32())   and Int32() => t)
    or ((t1 == UInt16()  or t2 == UInt16())  and UInt16() => t)
    or ((t1 == Int16()   or t2 == Int16())   and Int16() => t)
    or ((t1 == UInt8()   or t2 == UInt8())   and UInt8() => t)
    or UInt8() => t
