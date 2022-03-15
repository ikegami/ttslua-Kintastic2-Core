<a name="name-and-description"></a>
Kintastic2.Core.ArrayUtils - Array utils
========================================

Provides utils related to array-like tables.

# TABLE OF CONTENTS

1. [NAME AND DESCRIPTION](#name-and-description)
2. [TABLE OF CONTENTS](#tableofcontents)
3. [SYNOPSIS](#synopsis)
4. [FUNCTIONS](#functions)
    1. [ArrayUtils.all](#arrayutilsall)
    2. [ArrayUtils.any](#arrayutilsany)
    3. [ArrayUtils.array_to_dict](#arrayutilsarraytodict)
    4. [ArrayUtils.copy](#arrayutilscopy)
    5. [ArrayUtils.count](#arrayutilscount)
    6. [ArrayUtils.filter](#arrayutilsfilter)
    7. [ArrayUtils.first](#arrayutilsfirst)
    8. [ArrayUtils.first_idx](#arrayutilsfirstidx)
    9. [ArrayUtils.map](#arrayutilsmap)
    10. [ArrayUtils.none](#arrayutilsnone)
    11. [ArrayUtils.not_all](#arrayutilsnotall)
    12. [ArrayUtils.shuffle](#arrayutilsshuffle)
    13. [ArrayUtils.shuffle_i](#arrayutilsshufflei)
    14. [ArrayUtils.shuffle_inplace](#arrayutilsshuffleinplace)
    15. [ArrayUtils.sum](#arrayutilssum)
5. [ITERATOR GENERATORS](#iteratorgenerators)
    1. [ArrayUtils.ivalues](#arrayutilsivalues)
    2. [ArrayUtils.dipairs](#arrayutilsdipairs)
    3. [ArrayUtils.ipairs_desc](#arrayutilsipairsdesc)
    4. [ArrayUtils.divalues](#arrayutilsdivalues)
    5. [ArrayUtils.ivalues_desc](#arrayutilsivaluesdesc)
    6. [ArrayUtils.sivalues](#arrayutilssivalues)
    7. [ArrayUtils.sorted_ivalues](#arrayutilssortedivalues)

# SYNOPSIS

```lua
local ArrayUtils = require( "Kintastic2.Core.ArrayUtils" )
```

# FUNCTIONS

## ArrayUtils.all

```lua
local function test( value, index )
   return boolean
end

local boolean = ArrayUtils.all( test, array )
```

Returns `true` if every elements of the provided array pass
a test or if the array is empty. Returns `false` otherwise.

The test callback function is called with the value and
index of an element as arguments (in that order). If it
returns a false value, `all` returns `false` immediately.

Examples:

```lua
local array = { 3, 4, 5, 6, 7 }
print( ArrayUtils.all( |_|_>=3, array ) )  -- true
print( ArrayUtils.all( |_|_>=5, array ) )  -- false
print( ArrayUtils.all( |_|_>=8, array ) )  -- false
print( ArrayUtils.all( |_|f(), { } ) )     -- true
```

## ArrayUtils.any

```lua
local function test( value, index )
   return boolean
end

local boolean = ArrayUtils.any( test, array )
```

Returns `true` if any elements of the provided array pass a
test. Returns `false` otherwise, including when the array is
empty.

The test callback function is called with the value and
index of an element as arguments (in that order). If it
returns a true value, `any` returns `true` immediately.

Examples:

```lua
local array = { 3, 4, 5, 6, 7 }
print( ArrayUtils.any( |_|_>=3, array ) )  -- true
print( ArrayUtils.any( |_|_>=5, array ) )  -- true
print( ArrayUtils.any( |_|_>=8, array ) )  -- false
print( ArrayUtils.any( |_|f(), { } ) )     -- false
```

## ArrayUtils.array_to_dict

```lua
local function cb( value, index )
   return key, value
end

local dict = ArrayUtils.array_to_dict( array )
local dict = ArrayUtils.array_to_dict( cb, array )
```

Creates a dictionary from an array using a user-defined
mapping.

The callback function is called with the value and key of an
element as arguments (in that order). It must return the key
and value of an element to create in the resulting
dictionary.

If the callback returns nothing or returns `nil` for the
first value, no element will be created in the dictionary
for that array element.

If the callback returns fewer than two values or returns
`nil` for the second value, the array element's index will
be used instead.

If the callback isn't provided, the following default will
be used instead:

```lua
function ( value, index )
   return value, index
end
```

Examples:

```lua
local valid = ArrayUtils.array_to_dict({ "Purple", "Orange", "White", "Yellow" })

-- { "Yellow", "Purple" }
local filtered = ArrayUtils.filter(
   |_|valid[_],
   { "Yellow", "Grey", "Purple", "Teal" }
)
```

```lua
local function key( s )
   return string.lower( s )
end

local canon_case = ArrayUtils.array_to_dict(
   |v|key(v),
   { "Lua", "JSON", "Perl" }
)

-- "Perl"
local fixed = canon_case[ key( "PERL" ) ]
```

## ArrayUtils.copy

Alias for [`copy`](./TableUtils.md#tableutilscopy)
from [`Kintastic2.Core.TableUtils`](./TableUtils.md#name-and-description).

## ArrayUtils.count

Alias for [`count`](./TableUtils.md#tableutilscount)
from [`Kintastic2.Core.TableUtils`](./TableUtils.md#name-and-description).

## ArrayUtils.filter

```lua
local function test( value, index )
   return boolean
end

local filtered_array = ArrayUtils.filter( test, array )
```

Returns an array that contains the values of the provided
array that pass a test. The order of the elements is
preserved.

The test callback function is called with the value and
index of an element as arguments (in that order). It must
return a true value for a value to keep.

Examples:

```lua
-- { 2, 4, 8 }
local even_values = ArrayUtils.filter(
   |v|v % 2 == 0,
   { 2, 4, 5, 7, 8 }
)
```

```lua
-- { "def", "jkl" }
local at_even_indexes = ArrayUtils.filter(
   |v,i|i % 2 == 0,
   { "abc", "def", "ghi", "jkl" }
)
```

## ArrayUtils.first

```lua
local function test( value, index )
   return boolean
end

local match = ArrayUtils.first( test, array )
```

Returns the value of first element of an array that passes
a test, or `nil` if none did. The elements are tested in
order until a match is found.

The test callback function is called with the value and key
of an element as arguments (in that order). It must return
a true value when the target is found.

Example:

```
-- "banana"
local match = ArrayUtils.filter(
   |s|string.sub(s, 1, 1) == "b"
   { "apple", "orange", "banana", "berries" }
)
```

## ArrayUtils.first_idx

```lua
local match_index, match_value = ArrayUtils.first_idx(
   function ( value, index )
      return boolean
   end,
   array
)
```

Returns the index and value of first element of an array
that passes a test, or `nil` if none did. The elements are
tested in order until a match is found.

The test callback function is called with the value and key
of an element as arguments (in that order). It must return
a true value when the target is found.

Example:

```lua
-- 3
local match_idx = ArrayUtils.filter(
   |s|string.sub(s, 1, 1) == "b"
   { "apple", "orange", "banana", "berries" }
)
```

## ArrayUtils.map

Alias for [`map`](./TableUtils.md#tableutilsmap)
from [`Kintastic2.Core.TableUtils`](./TableUtils.md#name-and-description).

## ArrayUtils.none

```lua
local function test( value, index )
   return boolean
end

local boolean = ArrayUtils.none( test, array )
```

Returns `true` if every element of the provided array fails
a test or if the array is empty. Returns `false` otherwise.

The test callback function is called with the value and
index of an element as arguments (in that order). If it
returns a true value, `none` returns `false` immediately.

Examples:

```lua
local array = { 3, 4, 5, 6, 7 }
print( ArrayUtils.none( |_|_>=3, array ) )  -- false
print( ArrayUtils.none( |_|_>=5, array ) )  -- false
print( ArrayUtils.none( |_|_>=8, array ) )  -- true
print( ArrayUtils.none( |_|f(), { } ) )     -- true
```

## ArrayUtils.not_all

```lua
local function test( value, index )
   return boolean
end

local boolean = ArrayUtils.not_all( test, array )
```

Returns `true` if any elements of the provided array fail a
test. Returns `false` otherwise, including when the array is
empty.

The test callback function is called with the value and
index of an element as arguments (in that order). If it
returns a false value, `not_all` returns `true` immediately.

Examples:

```lua
local array = { 3, 4, 5, 6, 7 }
print( ArrayUtils.not_all( |_|_>=3, array ) )  -- false
print( ArrayUtils.not_all( |_|_>=5, array ) )  -- true
print( ArrayUtils.not_all( |_|_>=8, array ) )  -- true
print( ArrayUtils.not_all( |_|f(), { } ) )     -- false
```

## ArrayUtils.shuffle

```lua
local shuffled = ArrayUtils.shuffle( array )
```

Returns an array with the elements of the provided array
in random order.

## ArrayUtils.shuffle_i
## ArrayUtils.shuffle_inplace

```lua
ArrayUtils.shuffle_i( array )
ArrayUtils.shuffle_inplace( array )
```

Randomizes the order of elements of the provided array.

`ArrayUtils.shuffle_inplace` is an alias for
`ArrayUtils.shuffle_i`.

## ArrayUtils.sum

```lua
local sum = ArrayUtils.sum( array )
```

Returns the sum of the values of the elements in the
provided array. Returns zero for empty arrays.

# ITERATOR GENERATORS

## ArrayUtils.ivalues

```lua
for value in ArrayUtils.ivalues( array ) do … end
```

Produces an iterator suitable for `for in` which visits each
element of the array in ascending order. It provides only
the value.

## ArrayUtils.dipairs
## ArrayUtils.ipairs_desc

```lua
for index, value in ArrayUtils.dipairs( array ) do … end
for index, value in ArrayUtils.ipairs_desc( array ) do … end
```

Produces an iterator suitable for `for in` which visits each
element of the array in descending order. It provides the
index and the value.

`ArrayUtils.ipairs_desc` is an alias for
`ArrayUtils.dipairs`.

## ArrayUtils.divalues
## ArrayUtils.ivalues_desc

```lua
for value in ArrayUtils.divalues( array ) do … end
```

Produces an iterator suitable for `for in` which visits each
element of the array in descending order. It provides only
the value.

`ArrayUtils.ivalues_desc` is an alias for
`ArrayUtils.divalues`.

## ArrayUtils.sivalues
## ArrayUtils.sorted_ivalues

```lua
local function compare_func( a, b )
   return boolean
end

for value in ArrayUtils.sivalues( array ) do … end
for value in ArrayUtils.sivalues( compare_func, array ) do … end
```

Produces an iterator suitable for `for in` which visits each
element of the array in the order defined by `compare_func`.
`compare_func` has the same format as `table.sort`'s compare
function'. It provides only the value.

`ArrayUtils.sorted_ivalues` is an alias for
`ArrayUtils.sivalues`.

Example:

```lua
local employees = {
   { name = "Joe",   dept = "IT" },
   { name = "Frank", dept = "HR" }
}

-- Frank
-- Joe
for employee in ArrayUtils.sivalues( |a,b|a.name < b.name, employee ) do
   print( employee.name )
end
```
