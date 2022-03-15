<a name="name-and-description"></a>
Kintastic2.Core.TableUtils - Table utils
========================================

Provides utils related to both array-like and dictionary-like tables.

# TABLE OF CONTENTS

1. [NAME AND DESCRIPTION](#name-and-description)
2. [TABLE OF CONTENTS](#tableofcontents)
3. [SYNOPSIS](#synopsis)
4. [FUNCTIONS](#functions)
    1. [TableUtils.copy](#tableutilscopy)
    2. [TableUtils.count](#tableutilscount)
    3. [TableUtils.map](#tableutilsmap)

# SYNOPSIS

```lua
local TableUtils = require( "Kintastic2.Core.TableUtils" )
```

# FUNCTIONS

## TableUtils.copy

```lua
local copy = TableUtils.copy( tbl )
```

Returns a shallow copy of the provided table.

## TableUtils.count

```lua
local function test( value, index )
   return boolean
end

local count = TableUtils.count( tbl )
local count = TableUtils.count( test, tbl )
```

Returns the number of matching elements in a table.

The test callback function is called with the value and key
of an element as arguments (in that order). Only the
elements for which this function return a true value are
counted.

If no test callback is provided, returns the number of
elements in the table. For array-like tables, it's more
efficient to use the `#` operator to obtain the number of
elements.

## TableUtils.map

```lua
local function transform( value, key )
   return new_value
end

local modified = TableUtils.map( transform, tbl )
```

Returns a table that's a copy of the provided table, but
with a transformation applied to each value.

The transformation callback function is called with the
value and key of an element as arguments (in that order).

Example:

```lua
-- { "DOG", "CAT" }
local modified = TableUtils.map(
   |s|string.upper(s),
   { "dog", "cat" }
)
```
