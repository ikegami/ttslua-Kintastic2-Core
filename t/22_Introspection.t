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

my @tests = (
   [ 'get_class',                'local Class = { };  Class.mt = { __index = Class };  local o = setmetatable( { }, Class.mt );  return Introspection.get_class( o ) == Class', true ],
   [ 'get_class - non-instance', '                                                     local x =               { }            ;  return Introspection.get_class( x ) == nil',   true ],

   [ 'is_instance_of - Instance of child class is instance of child class', 'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Class.mt );  return Introspection.is_instance_of( o, Class )', true  ],
   [ 'is_instance_of - Instance of child class is instance of base class',  'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Class.mt );  return Introspection.is_instance_of( o, Base  )', true  ],
   [ 'is_instance_of - Instance of base class is instance of child class',  'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Base.mt  );  return Introspection.is_instance_of( o, Class )', false ],
   [ 'is_instance_of - Instance of base class is instance of base class',   'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local o = setmetatable( { }, Base.mt  );  return Introspection.is_instance_of( o, Base  )', true  ],
   [ 'is_instance_of - Non-instance',                                       'local Base = { };  Base.mt = { __index = Base };  local Class = { };  setmetatable( Class, { __index = Base } );  Class.mt = { __index = Class };  local x =               { }            ;  return Introspection.is_instance_of( x, Class )', false ],

   [ 'is_callable - function', 'local x = ||1;                                        local c1 = Introspection.is_callable( x );  local c2 = pcall( ||x() );  return { c1, c2 }', [ true,  true  ] ],
   [ 'is_callable - __call',   'local x = { };  setmetatable( x, { __call = ||1 } );  local c1 = Introspection.is_callable( x );  local c2 = pcall( ||x() );  return { c1, c2 }', [ true,  true  ] ],
   [ 'is_callable - nil',      'local x = nil;                                        local c1 = Introspection.is_callable( x );  local c2 = pcall( ||x() );  return { c1, c2 }', [ false, false ] ],
   [ 'is_callable - number',   'local x = 123;                                        local c1 = Introspection.is_callable( x );  local c2 = pcall( ||x() );  return { c1, c2 }', [ false, false ] ],
   [ 'is_callable - string',   'local x = "a";                                        local c1 = Introspection.is_callable( x );  local c2 = pcall( ||x() );  return { c1, c2 }', [ false, false ] ],
   [ 'is_callable - table',    'local x = { };                                        local c1 = Introspection.is_callable( x );  local c2 = pcall( ||x() );  return { c1, c2 }', [ false, false ] ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.Introspection', @$_ );
}

done_testing();
