module BaseC-Types

imports

  include/-
  lib/runtime/nabl/-
  lib/runtime/task/-
  lib/runtime/types/-
  lib/runtime/properties/-
  lib/runtime/relations/-
  BaseC/trans/types/-

relations

  define transitive <is:
  define transitive <widens-prim:
  define transitive <widens:

  t <is: Numeric()
    where
      t <is: Int() or <is: Float()

  Int8() <is: Int()
  Int16() <is: Int()
  Int32() <is: Int()
  Int64() <is: Int()

  UInt8() <is: Int()
  UInt16() <is: Int()
  UInt32() <is: Int()
  UInt64() <is: Int()

  Float() <is: Float()
  Double() <is: Float()

  t1 <widens: t2
    where
        t1 == t2
    or  t1 <widens-prim: t2

  Int8() <widens-prim: Int16()
  Int8() <widens-prim: Int32()
  Int8() <widens-prim: Int64()

  Int16() <widens-prim: Int32()
  Int16() <widens-prim: Int64()

  Int32() <widens-prim: Int64()

  UInt8() <widens-prim: UInt16()
  UInt8() <widens-prim: UInt32()
  UInt8() <widens-prim: UInt64()

  UInt16() <widens-prim: UInt64()
  UInt16() <widens-prim: UInt64()

  UInt32() <widens-prim: UInt64()
