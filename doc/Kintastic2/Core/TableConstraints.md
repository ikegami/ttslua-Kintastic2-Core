<a name="name-and-description"></a>
Kintastic2.Core.TableConstraints - Restrict table accesses and changes
======================================================================

Provides a facility to help prevent coding errors by
trapping references to the non-existent fields of a table.
By default, such a constraint violation results in an error,
but this can be changed (e.g. to simply print a message).

It is particularly useful to make the global symbol table
(`_G`) a fixed table, catching a multitude of typos sooner
and with less effort.

# TABLE OF CONTENTS

1. [NAME AND DESCRIPTION](#name-and-description)
2. [TABLE OF CONTENTS](#tableofcontents)
3. [SYNOPSIS](#synopsis)
4. [STRICT MODE](#strictmode)
    1. [TableConstraints.use_strict](#tableconstraintsusestrict)
    2. [TableConstraints.global](#tableconstraintsglobal)
5. [CONSTRAINT-ADDING FUNCTIONS](#constraintaddingfunctions)
6. [FUNCTIONS WHICH BYPASS CONSTRAINTS](#functionswhichbypassconstraints)
    1. [TableConstraints.declare](#tableconstraintsdeclare)
    2. [TableConstraints.set](#tableconstraintsset)
    3. [TableConstraints.get](#tableconstraintsget)
    4. [TableConstraints.merge_into](#tableconstraintsmergeinto)
    5. [TableConstraints.unlock](#tableconstraintsunlock)
7. [GLOBALS](#globals)
    1. [TableConstraints.enabled](#tableconstraintsenabled)
    2. [TableConstraints.on_violation](#tableconstraintsonviolation)

# SYNOPSIS

```lua
local TC = require( "Kintastic2.Core.TableConstraints" )

--

TC.use_strict()  -- Same as TC.struct( _G )

local count = 123  -- ok
print( count )     -- ok (assuming `print` exists)
print( c0unt )     -- TRAPPED!

function global_func() end                  -- TRAPPED!
TC.global( "global_func", function() end )  -- ok
local function func() end                   -- ok

--

local players = TC.const({
   red   = 1,
   green = 2,
   blue  = 3,
})

local player = players.red     -- ok
players.red = 4                -- TRAPPED!

local player = players.yellow  -- TRAPPED!
players.yellow = 5             -- TRAPPED!

--

local players = TC.const_lkup({
   red   = 1,
   green = 2,
   blue  = 3,
})

local player = players.red     -- ok
players.red = 4                -- TRAPPED!

local player = players.yellow  -- ok
players.yellow = 5             -- TRAPPED!

--

local players = TC.struct({
   red   = 1,
   green = 2,
   blue  = 3,
})

local player = players.red     -- ok
players.red = 4                -- ok

local player = players.yellow  -- TRAPPED!
players.yellow = 5             -- TRAPPED!

--

local players = TC.struct_lkup({
   red   = 1,
   green = 2,
   blue  = 3,
})

local player = players.red     -- ok
players.red = 4                -- ok

local player = players.yellow  -- ok
players.yellow = 5             -- TRAPPED!
```

# STRICT MODE

## TableConstraints.use_strict

```lua
TableConstraints.use_strict()
```

Prevents undeclared accesses of the global symbol table.

Short for `TableConstraints.struct( _G )`.

## TableConstraints.global

```lua
TableConstraints.global( name, value )
```

Declares and sets a global symbol.

Short for `TableConstraints.set( _G, name, value )`.

# CONSTRAINT-ADDING FUNCTIONS

```lua
tbl = CONSTRAINT( tbl )
tbl = CONSTRAINT( tbl, on_violation )
tbl = CONSTRAINT( tbl, on_violation, data )
tbl = CONSTRAINT_if( flag, tbl )
tbl = CONSTRAINT_if( flag, tbl, on_violation )
tbl = CONSTRAINT_if( flag, tbl, on_violation, data )
tbl = CONSTRAINT_r( tbl )
tbl = CONSTRAINT_r( tbl, on_violation )
tbl = CONSTRAINT_r( tbl, on_violation, data )
tbl = CONSTRAINT_r_if( flag, tbl )
tbl = CONSTRAINT_r_if( flag, tbl, on_violation )
tbl = CONSTRAINT_r_if( flag, tbl, on_violation, data )
```

where `CONSTRAINT` is one of:

* `const`
* `const_lkup`
* `struct`
* `struct_lkup`

These apply the constraint to the provided table, which is
returned. See the SYNOPSIS for an example of each.

The `_r` variants apply the constraint recursively.

The `_if` variable do nothing if `flag` is a false value.

`on_violation`, if provided, will call on a constraint
violation. If it's not provided, `TableConstraints.on_violation`
will be called instead. By default, it calls `error`.

`data` is an opaque value provided to the constraint
violation handler.

These constraints can only be applied to tables which don't
already have a metatable. And tables with these constraints
added shouldn't be used as the value of another metatable's
`__index` field.

# FUNCTIONS WHICH BYPASS CONSTRAINTS

## TableConstraints.declare

```lua
tbl = TableConstraints.declare( tbl, name1 )
tbl = TableConstraints.declare( tbl, name1, name2 )
tbl = TableConstraints.declare( tbl, name1, name2, … )
```

Declares fields of a table such that later accesses of those
fields don't result in a `struct` or `struct_lkup`
constraint violation.

Fields that existed prior to the addition of the constraint
need not be declared.

Can't be used on a table with `const` or `const_lkup`
constrtaint.

Silently does nothing but return the table if there's no
constraint on the table. As such, it can be used safely on a
table passed to `CONSTRAINT_if( false, … )`.

## TableConstraints.set

```lua
v = TableConstraints.set( tbl, k, v )
```

Sets the value of field, *ignoring any constraint* (if any).

This results in key becoming "declared".

## TableConstraints.get

```lua
local v = TableConstraints.get( tbl, k )
```

Gets the value of field, *ignoring the constraints on the
table* (if any).

## TableConstraints.merge_into

```lua
dst_tbl = TableConstraints.merge_into( dst_tbl, src_tbl )
```

Merges `src_tbl` into `dst_tbl`, *ignoring the constraints on the
table* (if any).

Added elements become "declared".

## TableConstraints.unlock

```lua
TableConstraints.unlock( tbl,
   function( tbl )
      …
   end
)
```

Calls the provided function. Constraints violations for
table `tbl` (if any) are ignored during this call.

# GLOBALS

## TableConstraints.enabled

```lua
TableConstraints.enabled = boolean
```

When this variable is false, the functions which normally
add constraints to table simply returning the provided
table with no changes.

This is useful, for example, for disabling the constraints
in production.

This has no effect on a table to which constraints have
already been added.

Defaults to `true`.

## TableConstraints.on_violation

```lua
TableConstraints.on_violation = function( data, msg, code, ctype, t, k, v )
   error( msg )
   return false
end
```

`TableConstraints.on_violation` is called on a constraint violation. The default
handler calls `error`, but the user may provide a different handler. This has a
global effect.

It is provided the data attached to the table, a human-readable error message, a
code indication the action that resulted in the violation, the type of the
constraint type found on the table, the table itself, the key being accessed,
and the value being assigned (if appropriate).

The code is one of the following strings:

- `access`, when accessing a non-existent field.
- `const`, when attempting to modify a constant field.
- `add`, when attempting to add a field to the table.

The constraint type is one of the following strings:

- `const`
- `const_lkup`
- `struct`
- `struct_lkup`

If the function returns a true value, the operation is permitted. It is
otherwise prevented.

If `TableConstraints.on_violation` is `nil`, the operation is permitted.
