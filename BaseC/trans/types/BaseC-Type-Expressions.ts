module BaseC-Types

imports

  include/-
  lib/runtime/nabl/-
  lib/runtime/task/-
  lib/runtime/types/-
  lib/runtime/properties/-
  lib/runtime/relations/-
  BaseC/trans/types/-
  BaseC/trans/desugar/-

type rules

  Comma(init, middle, last): t
    where last: t

  Assign(v, _, e): et
    where
          v: tv
      and e: et
      and (et <widens: tv)
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


  Var(Identifier(e)): t
    where
      definition of e : t

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

  Cast(Type(mods, t), _): t

  IncrementPrefix(e)
  + DecrementPrefix(e): t
    where
          e: t
      and t <is: Numeric()
        else error "Numeric expected" on e

  Field(e, Identifier(name)): t
    where definition of name: t

  PointerField(e, Identifier(name)): t
    where definition of name: t

  Deref(e): type
    where e: Pointer(type)

  Address(e): Pointer(type)
    where e: type

  Call(e, _): t
    where e: FunType(t)

  Paren(e): t
    where e: t

type functions

 // See section A6.1/A6.5 of "The C programming language"
 // TODO improve this
  promote: (t1, t2) -> t
  where
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
