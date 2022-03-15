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
   [ 'copy - array', 'local a = { "a", "b", "c" };  local b = TableUtils.copy( a );  a[ 4 ] = "d";  b[ 4 ] = "e";  return { a, b }', [ [ "a", "b", "c", "d" ], [ "a", "b", "c", "e" ] ] ],
   [ 'copy - dict', 'local d1 ={ a = 3, b = 4, c = 5 }; local d2 = TableUtils.copy( d1 );  d1.d = 6;  d2.d = 7;  return { d1, d2 }', [ { a => 3, b => 4, c => 5, d => 6 }, { a => 3, b => 4, c => 5, d => 7 } ] ],

   [ 'count - array - Default test', 'return TableUtils.count(             { "a", "b", "c", "d", "e" } )',           5 ],
   [ 'count - array - By value',     'return TableUtils.count( |v,i|v>"c", { "a", "b", "c", "d", "e" } )',           2 ],
   [ 'count - array - By index',     'return TableUtils.count( |v,i|i>=3,  { "a", "b", "c", "d", "e" } )',           3 ],
   [ 'count - dict - Default test',  'return TableUtils.count(             { a = 3, b = 4, c = 5, d = 6, e = 7 } )', 5 ],
   [ 'count - dict - By value',      'return TableUtils.count( |v,k|v>=5,  { a = 3, b = 4, c = 5, d = 6, e = 7 } )', 3 ],
   [ 'count - dict - By key',        'return TableUtils.count( |v,k|k>"c", { a = 3, b = 4, c = 5, d = 6, e = 7 } )', 2 ],

   [ 'map - array - By value', 'return TableUtils.map( |s|string.upper(s), { "cat", "dog" } )',                            [ "CAT", "DOG" ] ],
   [ 'map - array - By index', 'return TableUtils.map( |v,i|{ index = i, value = v }, { "cat", "dog" } )',                 [ { index => 1, value => "cat" }, { index => 2, value => "dog" } ] ],
   [ 'map - dict',             'return TableUtils.map( |v,k|{ name = k, animal = v }, { Fluffy = "cat", Fido = "dog" } )', { Fluffy => { name => "Fluffy", animal => "cat" }, Fido => { name => "Fido", animal => "dog" } } ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.TableUtils', @$_ );
}

done_testing();
