MetaC
=====


NaBL Hacks
----------

###  Modularity of NaBL

NaBL has the following modularity problems.

The structure of this repository is as follows:

- **BaseC** - Defines the basic C language parsing, naming, typing
- **MetaC** - Defines multiple extensions to BaseC. Ideally to add new extensions
  here, BaseC does not have to be touched. For parsing with SDF3, this is
  basically almost true already.

#### Compose scoping rules

Define extra namespaces that need to be scoped into some tree.

For example **[BaseC/trans/names/BaseC-names.nab](https://github.com/arian/metac/blob/master/BaseC/trans/names/BaseC-names.nab#L14-L18)**:

```
  Program(_):
    scopes Variable, Function, Struct
```

Now in our extension, we add a statemachine construct for defining
statemachines. The statemachine uses the `Statemachine` NaBL namespace:

**MetaC/sm/trans/names.nab**

```
  StateMachine(Identifier(name), _, _):
    defines Statemachine name
```

In the BaseC file, we don't know about statemachines or other extensions from
MetaC. However that is the only place to define the namespaces that need to be
scoped by `Program`.

##### Current [solution/hack](https://github.com/arian/metac/blob/master/BaseC/trans/names/BaseC-names-custom.str#L16-L59)

For the above problem, the current solution is to traverse the tree, and apply
rules for each constructor and collect the NaBL namespaces. The rule
`get-program-scope-nabl-namespace` can be composed modularly. In
**[MetaC/sm/trans/names-custom.str](https://github.com/arian/metac/blob/master/MetaC/sm/trans/names-custom.str#L11-L12)**
the rule `get-program-scope-nabl-namespace` is defined for statemachines, so
the `statemachine` namespace is collected at the original definition.


#### Composing polymorphism of expressions

In MetaC, it is preferable that extensions are idiomatic and blend nicely into
the language. That means that the same syntax that is in Basec can be used by
extensions of MetaC.

For example the bitfields extension can refer to one or more bits of an
integer:

```c
bitfields X {y: 1;};
X a;
a.y = !a.y;
```

The `a.y` is a `Field(lhs, rhs)` binary operator, where the location `y` refers
to depends on the type of `a`.

In the non-modular way, this can be defined in NaBL already. For example this
same syntax is used for both structs and unions.

```
  Field(e, Identifier(field)):
    refers to Field field in Struct s
      where e has type Struct(Identifier(s))
    otherwise refers to Field field in Union s
      where e has type Union(Identifier(s))
```

The `otherwise` defines the choices the field can refer to depending on (some
some property, the type, of) `e`.

For MetaC extensions however, it is not possible to add new 'otherwise' cases
to this declaration. For the bitfields case, that would look like:

```
  otherwise refers to Bitfield field in Bitfields s
    where e has type Bitfields(field, _)
```

##### MetaC [solution/hack](https://github.com/arian/metac/blob/master/BaseC/trans/names/BaseC-structs-custom.str#L17-L67)

The `refers to` and `otherwise refers to` compile to some stratego code, which
is basically a list of `UseCandidate` objects. The solution is to build this
list up manually, by collecting all possible options.

Such an option is defined by the `field-lookup` rule

```
  field-lookup = register-field-lookup(|"rewrite-struct-name", NablNsStruct(), NablNsField())
  task-rewrite: ("rewrite-struct-name", Struct(Identifier(s))) -> s
```

This defines which how to match the type, in which namespace to search for the
field, and which namespaces fields have in the surrounding namespace.

The `register-field-lookup` returns a new strategy such that it can be called
with a list of 'lookup', which succeeds if this lookup was not in this list and
returns a new list with this lookup added, otherwise it fails. Eventually there
is a list with all types of field lookups, so the `nabl-use-site` rule for
`Field(e, Identifier(field))` works for all types of lookups.

#### Recursive Type Relations

Types can be composed out of multiple other types. For example you could have
a `List` of `Int`s. In the case of C, an example would be a pointer type of
some interger: `Pointer(Int32())`.

For assignment expressions, you would like to know if you could assign the
right hand side to the left hand side expression.

By matching on the `Assign(lhs, operator, rhs)`:

```
  Assign(v, _, e): et
    where
          v: tv
      and e: et
      and (et <is-assignable: tv)
        else error $[Incompatible types: [tv]; [et]] on e
```

and defining the relation `<is-assignable:`.

```
relations

  Pointer(t1) <is-assignable: Pointer(t2)
    where t1 <is-assignable: t2

  t1 <is-assignable: t2
    where t1 == t2
      or (t1 <is: Numeric() and t2 <is: Numeric())

  Int8() <is: Numeric()
  Int16() <is: Numeric()
```


