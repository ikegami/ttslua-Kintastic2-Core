#!perl

use v5.14;
use strict;
use warnings;

use lib "t/lib";

use Test::More;
use Test::Deep qw( false true );

use TestUtils qw( basic_test port_check );

if ( !port_check() ) {
   diag( "**********************************************\n" .
         "****     Problem establishing server.     ****\n" .
         "**** Make sure Atom/VSCode isn't running. ****\n" .
         "**********************************************\n" );
}

my $denil_func = '
   local function denil( ... )
      local n = select( "#", ... )
      local t = { ... }
      for i = 1, n do
         if t[i] == nil then
            t[i] = "[nil]"
         end
      end

      return t
   end
';

my @tests = (
   [ 'get_class',                'local Class = { };  Class.mt = { __index = Class };  local o = setmetatable( { }, Class.mt );  return ObjUtils.get_class( o ) == Class', true ],
   [ 'get_class - non-instance', '                                                     local x =               { }            ;  return ObjUtils.get_class( x ) == nil',   true ],

   [ 'is_instance_of - Instance of child class is instance of child class', 'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Class.mt );  return ObjUtils.is_instance_of( o, Class )', true  ],
   [ 'is_instance_of - Instance of child class is instance of base class',  'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Class.mt );  return ObjUtils.is_instance_of( o, Base  )', true  ],
   [ 'is_instance_of - Instance of base class is instance of child class',  'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Base.mt  );  return ObjUtils.is_instance_of( o, Class )', false ],
   [ 'is_instance_of - Instance of base class is instance of base class',   'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Base.mt  );  return ObjUtils.is_instance_of( o, Base  )', true  ],
   [ 'is_instance_of - Non-instance',                                       'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local x =               { }            ;  return ObjUtils.is_instance_of( x, Class )', false ],

   [ 'make_delegate',                 $denil_func . ';  local o = { }; o.f = denil;  local d = ObjUtils.make_delegate( o, "f", "a", "b", "c" );  local rv = d( "x", "y", "z" );  rv[1] = rv[1] == o;  return rv', [ true, "a", "b", "c", "x", "y", "z" ] ],
   [ 'make_delegate - nil arg',       $denil_func . ';  local o = { }; o.f = denil;  local d = ObjUtils.make_delegate( o, "f", "a"           );  local rv = d( "x", nil, "y" );  rv[1] = rv[1] == o;  return rv', [ true, "a", "x", "[nil]", "y"       ] ],
   [ 'make_delegate - nil extra arg', $denil_func . ';  local o = { }; o.f = denil;  local d = ObjUtils.make_delegate( o, "f", "a", nil, "b" );  local rv = d( "x"           );  rv[1] = rv[1] == o;  return rv', [ true, "a", "[nil]", "b", "x"       ] ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.ObjUtils', @$_ );
}

done_testing();
