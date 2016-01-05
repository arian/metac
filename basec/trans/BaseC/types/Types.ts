module BaseC/types/Types

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

  define transitive <is:
  define transitive <widens-prim:
  define transitive <widens:

  t <is: Numeric()
    where
         t <is: Int()
      or t <is: Float()

  Char() <is: Int()
  Int8() <is: Int()
  Int16() <is: Int()
  Int32() <is: Int()
  Int64() <is: Int()

  UInt8() <is: Int()
  UInt16() <is: Int()
  UInt32() <is: Int()
  UInt64() <is: Int()

  // enum acts as int
  Enum(_) <is: Int()

  Float32() <is: Float()
  Float64() <is: Float()

  t1 <widens: t2
    where
       t1 == t2
    or t1 <widens-prim: t2

  // Char should be treated equally to Int8()
  Int8() <widens-prim: Char()
  Char() <widens-prim: Int8()

  Int8() <widens-prim: Int16()
  Int8() <widens-prim: Int32()
  Int8() <widens-prim: Int64()
  Int8() <widens-prim: Float32()
  Int8() <widens-prim: Float64()

  Int16() <widens-prim: Int32()
  Int16() <widens-prim: Int64()
  Int16() <widens-prim: Float32()
  Int16() <widens-prim: Float64()

  Int32() <widens-prim: Int64()
  Int32() <widens-prim: Float32()
  Int32() <widens-prim: Float64()

  Int64() <widens-prim: Float32()
  Int64() <widens-prim: Float64()

  UInt8() <widens-prim: UInt16()
  UInt8() <widens-prim: UInt32()
  UInt8() <widens-prim: UInt64()
  UInt8() <widens-prim: Float32()
  UInt8() <widens-prim: Float64()

  UInt16() <widens-prim: UInt64()
  UInt16() <widens-prim: UInt64()
  UInt16() <widens-prim: Float32()
  UInt16() <widens-prim: Float64()

  UInt32() <widens-prim: UInt64()
  UInt32() <widens-prim: Float32()
  UInt32() <widens-prim: Float64()

  UInt64() <widens-prim: Float32()
  UInt64() <widens-prim: Float64()

  Float32() <widens-prim: Float64()

