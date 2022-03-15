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
   [ 'all - All',          'return ArrayUtils.all(     |_|_>=3,  { 3, 4, 5, 6, 7 } )', true  ],
   [ 'all - Some',         'return ArrayUtils.all(     |_|_>=5,  { 3, 4, 5, 6, 7 } )', false ],
   [ 'all - None',         'return ArrayUtils.all(     |_|_>=8,  { 3, 4, 5, 6, 7 } )', false ],
   [ 'all - Empty (F)',    'return ArrayUtils.all(     |_|false, {               } )', true  ],
   [ 'all - Empty (T)',    'return ArrayUtils.all(     |_|true,  {               } )', true  ],

   [ 'any - All',          'return ArrayUtils.any(     |_|_>=3,  { 3, 4, 5, 6, 7 } )', true  ],
   [ 'any - Some',         'return ArrayUtils.any(     |_|_>=5,  { 3, 4, 5, 6, 7 } )', true  ],
   [ 'any - None',         'return ArrayUtils.any(     |_|_>=8,  { 3, 4, 5, 6, 7 } )', false ],
   [ 'any - Empty (F)',    'return ArrayUtils.any(     |_|false, {               } )', false ],
   [ 'any - Empty (T)',    'return ArrayUtils.any(     |_|true,  {               } )', false ],

   [ 'none - All',         'return ArrayUtils.none(    |_|_>=3,  { 3, 4, 5, 6, 7 } )', false ],
   [ 'none - Some',        'return ArrayUtils.none(    |_|_>=5,  { 3, 4, 5, 6, 7 } )', false ],
   [ 'none - None',        'return ArrayUtils.none(    |_|_>=8,  { 3, 4, 5, 6, 7 } )', true  ],
   [ 'none - Empty (F)',   'return ArrayUtils.none(    |_|false, {               } )', true  ],
   [ 'none - Empty (T)',   'return ArrayUtils.none(    |_|true,  {               } )', true  ],

   [ 'not_all- All',       'return ArrayUtils.not_all( |_|_>=3,  { 3, 4, 5, 6, 7 } )', false ],
   [ 'not_all- Some',      'return ArrayUtils.not_all( |_|_>=5,  { 3, 4, 5, 6, 7 } )', true  ],
   [ 'not_all- None',      'return ArrayUtils.not_all( |_|_>=8,  { 3, 4, 5, 6, 7 } )', true  ],
   [ 'not_all- Empty (F)', 'return ArrayUtils.not_all( |_|false, {               } )', false ],
   [ 'not_all- Empty (T)', 'return ArrayUtils.not_all( |_|true,  {               } )', false ],

   [ 'array_to_dict - Default callback',                        'return ArrayUtils.array_to_dict(                                          { "a", "b", "c" } )', { a => 1, b => 2, c => 3 }          ],
   [ 'array_to_dict - Callback returns a single value',         'return ArrayUtils.array_to_dict( function( v, i ) return v .. v      end, { "a", "b", "c" } )', { aa => 1, bb => 2, cc => 3 }       ],
   [ 'array_to_dict - Callback returns `nil` for second value', 'return ArrayUtils.array_to_dict( function( v, i ) return v .. v, nil end, { "a", "b", "c" } )', { aa => 1, bb => 2, cc => 3 }       ],
   [ 'array_to_dict - Callback returns two values',             'return ArrayUtils.array_to_dict( function( v, i ) return v, i .. i   end, { "a", "b", "c" } )', { a => "11", b => "22", c => "33" } ],
   [ 'array_to_dict - Callback returns `nil`',                  'return ArrayUtils.array_to_dict( function( v, i ) return nil         end, { "a", "b", "c" } )', [ ]                                 ],  # Empty table returned as array.
   [ 'array_to_dict - Callback returns nothing',                'return ArrayUtils.array_to_dict( function( v, i )                    end, { "a", "b", "c" } )', [ ]                                 ],  # Empty table returned as array.

   [ 'copy', 'local a = { "a", "b", "c" };  local b = ArrayUtils.copy( a );  a[ 4 ] = "d";  b[ 4 ] = "e";  return { a, b }', [ [ "a", "b", "c", "d" ], [ "a", "b", "c", "e" ] ] ],

   [ 'count - Default test', 'return ArrayUtils.count(             { "a", "b", "c", "d", "e" } )', 5 ],
   [ 'count - By value',     'return ArrayUtils.count( |v,i|v>"c", { "a", "b", "c", "d", "e" } )', 2 ],
   [ 'count - By index',     'return ArrayUtils.count( |v,i|i>=3,  { "a", "b", "c", "d", "e" } )', 3 ],

   [ 'filter - By value', 'return ArrayUtils.filter( |v|v % 2 == 0,   { 2, 4, 5, 7, 8      } )', [ 2, 4, 8 ]  ],
   [ 'filter - By index', 'return ArrayUtils.filter( |v,i|i % 2 == 0, { "a", "b", "c", "d" } )', [ "b", "d" ] ],

   [ 'first - By value',    'return ArrayUtils.first( |v|v % 2 == 0,   { 2, 4, 5, 7, 8      } )', 2     ],
   [ 'first - By index',    'return ArrayUtils.first( |v,i|i % 2 == 0, { "a", "b", "c", "d" } )', "b"   ],
   [ 'first - No matching', 'return ArrayUtils.first( ||false,         { "a", "b", "c", "d" } )', undef ],
   [ 'first - No values',   'return ArrayUtils.first( ||true,          {                    } )', undef ],

   [ 'first_idx - By value',    'return ArrayUtils.first_idx( |v|v % 2 == 0,   { 2, 4, 5, 7, 8      } )', 1     ],
   [ 'first_idx - By index',    'return ArrayUtils.first_idx( |v,i|i % 2 == 0, { "a", "b", "c", "d" } )', 2     ],
   [ 'first_idx - No matching', 'return ArrayUtils.first_idx( ||false,         { "a", "b", "c", "d" } )', undef ],
   [ 'first_idx - No values',   'return ArrayUtils.first_idx( ||true,          {                    } )', undef ],

   [ 'map - By value', 'return ArrayUtils.map( |s|string.upper(s), { "cat", "dog" } )',  [ "CAT", "DOG" ] ],
   [ 'map - By index', 'return ArrayUtils.map( |v,i|{ index = i, value = v }, { "cat", "dog" } )',  [ { index => 1, value => "cat" }, { index => 2, value => "dog" } ] ],

   # Poor tests. Should mock `math.random`, and check both `a` and `b`. But at least this checks for symbol leaks.
   [ 'shuffle',         'local a = { 1, 2, 3, 4, 5 };  local b = ArrayUtils.shuffle( a );  return true', true ],
   [ 'shuffle_i',       'local a = { 1, 2, 3, 4, 5 };  ArrayUtils.shuffle_i(       a );    return true', true ],
   [ 'shuffle_inplace', 'local a = { 1, 2, 3, 4, 5 };  ArrayUtils.shuffle_inplace( a );    return true', true ],

   [ 'sum',             'return ArrayUtils.sum( { 1, 2, 3, 4, 5 } )', 15 ],
   [ 'sum - No values', 'return ArrayUtils.sum( {               } )',  0 ],

   [ 'ivalues',                          'local rv = { };  for value        in ArrayUtils.ivalues(        { "a", "b", "c" }                     ) do table.insert( rv, value            ) end;  return rv', [ "a", "b", "c" ]                      ],
   [ 'dipairs',                          'local rv = { };  for index, value in ArrayUtils.dipairs(        { "a", "b", "c" }                     ) do table.insert( rv, { index, value } ) end;  return rv', [ [ 3, "c" ], [ 2, "b" ], [ 1, "a" ] ] ],
   [ 'ipairs_desc',                      'local rv = { };  for index, value in ArrayUtils.ipairs_desc(    { "a", "b", "c" }                     ) do table.insert( rv, { index, value } ) end;  return rv', [ [ 3, "c" ], [ 2, "b" ], [ 1, "a" ] ] ],
   [ 'divalues',                         'local rv = { };  for value        in ArrayUtils.divalues(       { "a", "b", "c" }                     ) do table.insert( rv, value            ) end;  return rv', [ "c", "b", "a" ]                      ],
   [ 'ivalues_desc',                     'local rv = { };  for value        in ArrayUtils.ivalues_desc(   { "a", "b", "c" }                     ) do table.insert( rv, value            ) end;  return rv', [ "c", "b", "a" ]                      ],
   [ 'sivalues - Default compare',       'local rv = { };  for value        in ArrayUtils.sivalues(                 { 1, 10, 20, 100, 2, 4, 3 } ) do table.insert( rv, value            ) end;  return rv', [ 1, 2, 3, 4, 10, 20, 100 ]            ],
   [ 'sorted_ivalues - Default compare', 'local rv = { };  for value        in ArrayUtils.sorted_ivalues(           { 1, 10, 20, 100, 2, 4, 3 } ) do table.insert( rv, value            ) end;  return rv', [ 1, 2, 3, 4, 10, 20, 100 ]            ],
   [ 'sivalues - Custom compare',        'local rv = { };  for value        in ArrayUtils.sivalues(       |a,b|b<a, { 1, 10, 20, 100, 2, 4, 3 } ) do table.insert( rv, value            ) end;  return rv', [ 100, 20, 10, 4, 3, 2, 1 ]            ],
   [ 'sorted_ivalues - Custom compare',  'local rv = { };  for value        in ArrayUtils.sorted_ivalues( |a,b|b<a, { 1, 10, 20, 100, 2, 4, 3 } ) do table.insert( rv, value            ) end;  return rv', [ 100, 20, 10, 4, 3, 2, 1 ]            ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.ArrayUtils', @$_ );
}

done_testing();
