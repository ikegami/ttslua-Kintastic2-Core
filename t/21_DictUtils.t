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
   [ 'copy', 'local d1 ={ a = 3, b = 4, c = 5 }; local d2 = DictUtils.copy( d1 );  d1.d = 6;  d2.d = 7;  return { d1, d2 }', [ { a => 3, b => 4, c => 5, d => 6 }, { a => 3, b => 4, c => 5, d => 7 } ] ],

   [ 'count - Default test', 'return DictUtils.count(             { a = 3, b = 4, c = 5, d = 6, e = 7 } )', 5 ],
   [ 'count - By value',     'return DictUtils.count( |v,k|v>=5,  { a = 3, b = 4, c = 5, d = 6, e = 7 } )', 3 ],
   [ 'count - By key',       'return DictUtils.count( |v,k|k>"c", { a = 3, b = 4, c = 5, d = 6, e = 7 } )', 2 ],

   [ 'keys',   'return DictUtils.get_keys(   { a = 3, b = 4, c = 5 } )', [ "a", "b", "c" ] ],
   [ 'values', 'return DictUtils.get_values( { a = 3, b = 4, c = 5 } )', [ 3, 4, 5 ]       ],

   [ 'map', 'return DictUtils.map( |v,k|{ name = k, animal = v }, { Fluffy = "cat", Fido = "dog" } )', { Fluffy => { name => "Fluffy", animal => "cat" }, Fido => { name => "Fido", animal => "dog" } } ],

   [ 'pick - By value', 'return DictUtils.pick( |v|v % 2 == 0,                   { a = 2, b = 4, c = 5, d = 7, e = 8 } )', { a => 2, b => 4, e => 8 } ],
   [ 'pick - By key',   'return DictUtils.pick( |v,k|string.sub(k, 1, 1) == "a", { a1 = 3, a2 = 4, b1 = 5 } )',            { a1 => 3, a2 => 4 }       ],

   [ 'merge',        'local d1 = { a = 3, b = 4 };                         local d2 = { b = 5, c = 6 };                   local d3 = DictUtils.merge(        d1, d2 ); return { d1, d2, d3 }', [ { a => 3, b => 4 },                                               { b => 5, c => 6 },                     { a => 3, b => 5, c => 6 }                                       ] ],
   [ 'merge_into',   'local d1 = { a = 3, b = 4 };                         local d2 = { b = 5, c = 6 };                   local d3 = DictUtils.merge_into(   d1, d2 ); return { d1, d2, d3 }', [ { a => 3, b => 5, c => 6 },                                       { b => 5, c => 6 },                     { a => 3, b => 5, c => 6 }                                       ] ],
   [ 'merge_into_r', 'local d1 = { a = { Z = 10, Y = 5 }, b = { X = 3 } }; local d2 = { a = { Y = 10 }, c = { W = 20 } }; local d3 = DictUtils.merge_into_r( d1, d2 ); return { d1, d2, d3 }', [ { a => { Z => 10, Y => 10 }, b => { X => 3 }, c => { W => 20 } }, { a => { Y => 10 }, c => { W => 20 } }, { a => { Z => 10, Y => 10 }, b => { X => 3 }, c => { W => 20 } } ] ],

   [ 'keys',   'local rv = { }; for key   in DictUtils.keys(   { a = 3, b = 4, c = 5 } ) do table.insert( rv, key   ); end; return rv', [ "a", "b", "c" ] ],
   [ 'values', 'local rv = { }; for value in DictUtils.values( { a = 3, b = 4, c = 5 } ) do table.insert( rv, value ); end; return rv', [ 3, 4, 5 ]       ],

   [ 'spairs - Default compare',       'local rv = { };  for key, value in DictUtils.spairs(                                                                                          { a = 3, b = 4, c = 5, d = 4 } ) do table.insert( rv, { key, value } ) end;  return rv', [ [ "a", 3 ], [ "b", 4 ], [ "c", 5 ], [ "d", 4 ] ] ],
   [ 'spairs - Custom compare',        'local rv = { };  for key, value in DictUtils.spairs(       function( va, vb, ka, kb ) if va ~= vb then return vb < va end return ka < kb end, { a = 3, b = 4, c = 5, d = 4 } ) do table.insert( rv, { key, value } ) end;  return rv', [ [ "c", 5 ], [ "b", 4 ], [ "d", 4 ], [ "a", 3 ] ] ],
   [ 'sorted_pairs - Default compare', 'local rv = { };  for key, value in DictUtils.sorted_pairs(                                                                                    { a = 3, b = 4, c = 5, d = 4 } ) do table.insert( rv, { key, value } ) end;  return rv', [ [ "a", 3 ], [ "b", 4 ], [ "c", 5 ], [ "d", 4 ] ] ],
   [ 'sorted_pairs - Custom compare',  'local rv = { };  for key, value in DictUtils.sorted_pairs( function( va, vb, ka, kb ) if va ~= vb then return vb < va end return ka < kb end, { a = 3, b = 4, c = 5, d = 4 } ) do table.insert( rv, { key, value } ) end;  return rv', [ [ "c", 5 ], [ "b", 4 ], [ "d", 4 ], [ "a", 3 ] ] ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.DictUtils', @$_ );
}

done_testing();
