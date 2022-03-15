<a name="name-and-description"></a>
Kintastic2.Core.Introspection - Introspection utils
===================================================

Provides utils related to introspection.

# TABLE OF CONTENTS

1. [NAME AND DESCRIPTION](#name-and-description)
2. [TABLE OF CONTENTS](#tableofcontents)
3. [SYNOPSIS](#synopsis)
4. [FUNCTIONS](#functions)
    1. [Introspection.get_class](#introspectiongetclass)
    2. [Introspection.is_instance_of](#introspectionisinstanceof)
    3. [Introspection.is_callable](#introspectioniscallable)

# SYNOPSIS

```lua
local Introspection = require( "Kintastic2.Core.Introspection" )
```

# FUNCTIONS

## Introspection.get_class

```lua
local class = Introspection.get_class( x )
```

Returns the class of the argument if applicable, or `nil`
otherwise.

The class of a value is defined as the table found in the
`__index` entry of its metatable.

## Introspection.is_instance_of

```lua
local boolean = Introspection.is_instance_of( x, class )
```

Returns true if the argument is the specified class, a
subclass of it, an instance of it, or an instance of a
subclass of it.

The class of a value is defined as the table found in the
`__index` entry of its metatable.

## Introspection.is_callable

```lua
local boolean = Introspection.is_callable( x )
```

Returns true if the argument is calleable as a fucntion.
This takes into account the `__call` metamethod.
