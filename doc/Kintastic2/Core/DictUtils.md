<a name="name-and-description"></a>
Kintastic2.Core.DictUtils - Dictionary utils
============================================

Provides utils related to dictionary-like tables.

# TABLE OF CONTENTS

1. [NAME AND DESCRIPTION](#name-and-description)
2. [TABLE OF CONTENTS](#tableofcontents)
3. [SYNOPSIS](#synopsis)
4. [FUNCTIONS](#functions)
    1. [DictUtils.copy](#dictutilscopy)
    2. [DictUtils.count](#dictutilscount)
    3. [DictUtils.get_keys](#dictutilsgetkeys)
    4. [DictUtils.get_values](#dictutilsgetvalues)
    5. [DictUtils.map](#dictutilsmap)
    6. [DictUtils.pick](#dictutilspick)
    7. [DictUtils.merge](#dictutilsmerge)
    8. [DictUtils.merge_into](#dictutilsmergeinto)
    9. [DictUtils.merge_into_r](#dictutilsmergeintor)
5. [ITERATOR GENERATORS](#iteratorgenerators)
    1. [DictUtils.keys](#dictutilskeys)
    2. [DictUtils.values](#dictutilsvalues)
    3. [DictUtils.spairs](#dictutilsspairs)
    4. [DictUtils.sorted_pairs](#dictutilssortedpairs)

# SYNOPSIS

```lua
local DictUtils = require( "Kintastic2.Core.DictUtils" )
```

# FUNCTIONS

## DictUtils.copy

Alias for [`copy`](./TableUtils.md#tableutilscopy)
from [`Kintastic2.Core.TableUtils`](./TableUtils.md#name-and-description).

## DictUtils.count

Alias for [`count`](./TableUtils.md#tableutilscount)
from [`Kintastic2.Core.TableUtils`](./TableUtils.md#name-and-description).

## DictUtils.get_keys

```lua
local keys = DictUtils.get_keys( dict )
```

Returns an array of the dictionary's keys.

## DictUtils.get_values

```lua
local values = DictUtils.get_values( dict )
```

Returns an array of the dictionary's keys.

## DictUtils.map

Alias for [`map`](./TableUtils.md#tableutilsmap)
from [`Kintastic2.Core.TableUtils`](./TableUtils.md#name-and-description).

## DictUtils.pick

```lua
local function test( value, key )
   return boolean
end

local filtered = DictUtils.pick( test, dict )
```

Returns a dictionary that contains the elements of the
provided dictionary that pass a test.

The test callback function is called with the value and key
of an element as arguments (in that order). It must return
a true value for value to keep.

Examples:

```lua
-- { Yellow = 200, White = 300 }
local even_values = DictUtils.pick(
   |v|v >= 200
   { Purple = 100, Yellow = 200, White = 300 }
)
```

## DictUtils.merge

```lua
local merged = DictUtils.merge( dict1 )
local merged = DictUtils.merge( dict1, dict2 )
```

Returns a dictionary the consists of the elements of `dict1`
and the elements of `dict2`. In the event of duplicate keys,
the element from `dict2` is used.

Examples:

```lua
-- { Purple = 100, Yellow = 200, White = 400 }
local merged = DictUtils.merge(
   { Purple = 100, White = 300 },
   { Yellow = 200, White = 400 }
)
```

## DictUtils.merge_into

```lua
dst_dict = DictUtils.merge_into( dst_dict, src_dict )
```

Adds the elements of the `src_dict` to `dst_dict`. In the
event of duplicate keys, the element from `src_dict` is
used.

As a convenience, it returns its first argument.

Examples:

```lua
local dict = { Purple = 100, White = 300 }

-- { Purple = 100, Yellow = 200, White = 400 }
DictUtils.merge_into(
   { Yellow = 200, White = 400 }
)
```

## DictUtils.merge_into_r

```lua
dst_dict = DictUtils.merge_into_r( dst_dict, src_dict )
```

Recursively merges `src_dict` into `dst_dict`.

As a convenience, it returns its first argument.

Examples:

```lua
local dict = {
   coal = {
      [ "Smithsville" ] = 10,
      [ "Blackburg"   ] =  5,
   },
   iron = {
      [ "Steelville"  ] = 20,
   }
}

-- {
--    coal = {
--       [ "Smithsville" ] = 10,
--       [ "Blackburg"   ] = 10,
--    },
--    copper = {
--       [ "Coppertown"  ] =  3,
--    },
--    iron = {
--       [ "Steelville"  ] = 20,
--    }
-- }
DictUtils.merge_into_r(
   dict,
   {
      coal = {
         [ "Blackburg"   ] = 10,
      },
      copper = {
         [ "Coppertown"  ] =  3,
      }
   }
)
```

# ITERATOR GENERATORS

## DictUtils.keys

```lua
for key in DictUtils.keys( dict ) do … end
```

Produces an iterator suitable for `for in` which visits each
element of the dictionary. It provides only the key.

## DictUtils.values

```lua
for value in DictUtils.values( dict ) do … end
```

Produces an iterator suitable for `for in` which visits each
element of the dictionary. It provides only the value.

## DictUtils.spairs
## DictUtils.sorted_pairs

```lua
local function compare_func( value_a, value_b, key_a, key_b )
   return boolean
end

for value in DictUtils.spairs( dict ) do … end
for value in DictUtils.spairs( compare_func, dict ) do … end
```

Produces an iterator suitable for `for in` which visits each
element of the dictionary in ascending key order (default)
or in the order defined by `compare_func`. It provides the
key and the value.

`DictUtils.sorted_pairs` is an alias for
`DictUtils.spairs`.

Example:

```lua
local characters = {
   Blue = { name = "Legolas", race = "Elf"   },
   Red  = { name = "Aragon",  race = "Human" }
}

-- Aragon
-- Legolas
for player_color, character in DictUtils.spairs( |va,vb|va.name < vb.name, characters ) do
   print( character.name )
end
```
