<a name="name-and-description"></a>
Kintastic2.Core.StrUtils - String utils
=======================================

Provides utils related to strings.

# TABLE OF CONTENTS

1. [NAME AND DESCRIPTION](#name-and-description)
2. [TABLE OF CONTENTS](#tableofcontents)
3. [SYNOPSIS](#synopsis)
4. [FUNCTIONS](#functions)
    1. [StrUtils.starts_with](#strutilsstartswith)
    2. [StrUtils.ends_with](#strutilsendswith)
    3. [StrUtils.split](#strutilssplit)

# SYNOPSIS

```lua
local StrUtils = require( "Kintastic2.Core.StrUtils" )
```

# FUNCTIONS

## StrUtils.starts_with

```lua
local boolean = StrUtils.starts_with( str, substr )
```

The returned value indicates whether a string starts with
another or not.

## StrUtils.ends_with

```lua
local boolean = StrUtils.ends_with( str, substr )
```

The returned value indicates whether a string ends with
another or not.

## StrUtils.split

```lua
local substrs = StrUtils.split( str, sep )
local substrs = StrUtils.split( str, sep, opts )
```

Returns the substrings of a string which are separated by
a pattern.

`opts`, if provided, is a table with any number of the
following elements:

* `max`

    If provided, limits the number of parts into which the
    string can be split (not counting the separator).

    Example:

    ```lua
    -- { "a", ".", "b.c" }
    local substrs = StrUtils.split( "a.b.c", ".", { max = 2 } )
    ```

* `pattern`

    If `pattern` is provided and a true value, `sep` is
    treated as a pattern accepted by `string.find`.
    Otherwise, `sep` is matched literally.

* `discard`

    If `discard` is provided and a true value, trailing
    empty strings are removed from the returned table.

* `capture`

    If `capture` is provided and a true value, the
    seperators are included in the returned table.

    Example:

    ```lua
    -- { "a", ".", "b", ".", "c" }
    local substrs = StrUtils.split( "a.b.c", ".", { capture = true } )
    ```

Splitting an empty string returns an empty table.

A pattern matching zero characters results in an error.

Example:

```lua
-- { "a", "b", "c" }
local substrs = StrUtils.split( "a.b.c", "." )
```
