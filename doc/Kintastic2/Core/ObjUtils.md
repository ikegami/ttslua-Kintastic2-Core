<a name="name-and-description"></a>
Kintastic2.Core.ObjUtils - Object utils
=======================================

Provides utils related to objects.

# TABLE OF CONTENTS

1. [NAME AND DESCRIPTION](#name-and-description)
2. [TABLE OF CONTENTS](#tableofcontents)
3. [SYNOPSIS](#synopsis)
4. [FUNCTIONS](#functions)
    1. [ObjUtils.get_class](#objutilsgetclass)
    2. [ObjUtils.is_instance_of](#objutilsisinstanceof)
    3. [ObjUtils.make_delegate](#objutilsmakedelegate)

# SYNOPSIS

```lua
local ObjUtils = require( "Kintastic2.Core.ObjUtils" )
```

# FUNCTIONS

## ObjUtils.get_class

Alias for `get_class` from [`Kintastic2.Core.Introspection`](`./Introspection.md`).

## ObjUtils.is_instance_of

Alias for `is_instance_of` from [`Kintastic2.Core.Introspection`](`./Introspection.md`).

## ObjUtils.make_delegate

```lua
local f = ObjUtils.make_delegate( o, method_name )
local f = ObjUtils.make_delegate( o, method_name, extra_arg1 )
local f = ObjUtils.make_delegate( o, method_name, extra_arg1, extra_arg2 )
local f = ObjUtils.make_delegate( o, method_name, extra_arg1, extra_arg2, … )
```

Creates a function that calls the provided method name of
the provided object. All extra arguments passed to this
function and all arguments passed to the function when it's
called are passed to the method.

This is useful to create a callback function.

This handles `nil` arguments correctly.

Example:

```lua
-- Same as: `local rv = o:some_method( "foo", "bar" )`
local f = ObjUtils.make_delegate( o, "some_method", "foo" )
local rv = f( "bar" )
```
