module BaseC-Types

imports

  include/-
  lib/runtime/nabl/-
  lib/runtime/task/-
  lib/runtime/types/-
  lib/runtime/properties/-
  lib/runtime/relations/-
  BaseC/trans/types/-

type rules

  Var(Identifier(e)): t
    where
      definition of e : t

  Add(e1, e2)
  + Subtract(e1, e2)
  + Mult(e1, e2)
  + Div(e1, e2) : ty
    where
      e1: aty1
      and e2: aty2
      and aty1 <is: Numeric()
        else error "Numeric expected" on e1
      and aty2 <is: Numeric()
        else error "Numeric expected" on e2
      and <promote> (aty1, aty2) => ty

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
