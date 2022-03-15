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
   [ 'starts_with( "abc", "ab"  )', 'return StrUtils.starts_with( "abc", "ab"  )', true  ],
   [ 'starts_with( "abc", "bc"  )', 'return StrUtils.starts_with( "abc", "bc"  )', false ],
   [ 'starts_with( "abc", "abc" )', 'return StrUtils.starts_with( "abc", "abc" )', true  ],
   [ 'starts_with( "abc", ""    )', 'return StrUtils.starts_with( "abc", ""    )', true  ],
   [ 'starts_with( "ab",  "abc" )', 'return StrUtils.starts_with( "ab",  "abc" )', false ],
   [ 'starts_with( "",    "abc" )', 'return StrUtils.starts_with( "",    "abc" )', false ],

   [ 'ends_with( "cba", "ba"  )', 'return StrUtils.ends_with( "cba", "ba"  )', true  ],
   [ 'ends_with( "cba", "cb"  )', 'return StrUtils.ends_with( "cba", "cb"  )', false ],
   [ 'ends_with( "cba", "cba" )', 'return StrUtils.ends_with( "cba", "cba" )', true  ],
   [ 'ends_with( "cba", ""    )', 'return StrUtils.ends_with( "cba", ""    )', true  ],
   [ 'ends_with( "ba",  "cba" )', 'return StrUtils.ends_with( "ba",  "cba" )', false ],
   [ 'ends_with( "",    "cba" )', 'return StrUtils.ends_with( "",    "cba" )', false ],

   [ 'split( "abc.def.ghi", "." )',                                      'return StrUtils.split( "abc.def.ghi", "." )',                                      [ "abc", "def", "ghi"           ] ],
   [ 'split( "abc.def.ghi", ".", { max = 2 } )',                         'return StrUtils.split( "abc.def.ghi", ".", { max = 2 } )',                         [ "abc", "def.ghi"              ] ],
   [ 'split( "abc.def.ghi", "%p" )',                                     'return StrUtils.split( "abc.def.ghi", "%p" )',                                     [ "abc.def.ghi"                 ] ],
   [ 'split( "abc.def.ghi", "%p", { pattern = true } )',                 'return StrUtils.split( "abc.def.ghi", "%p", { pattern = true } )',                 [ "abc", "def", "ghi"           ] ],
   [ 'split( "abc.def.", "." )',                                         'return StrUtils.split( "abc.def.", "." )',                                         [ "abc", "def", ""              ] ],
   [ 'split( "abc.def.", ".", { discard = true } )',                     'return StrUtils.split( "abc.def.", ".", { discard = true } )',                     [ "abc", "def"                  ] ],
   [ 'split( "abc.def.ghi", ".", { max = 2, capture = true } )',         'return StrUtils.split( "abc.def.ghi", ".", { max = 2, capture = true } )',         [ "abc", ".", "def.ghi"         ] ],
   [ 'split( "abc.def.ghi", "%p", { capture = true, pattern = true } )', 'return StrUtils.split( "abc.def.ghi", "%p", { capture = true, pattern = true } )', [ "abc", ".", "def", ".", "ghi" ] ],
   [ 'split( "", "." )',                                                 'return StrUtils.split( "", "." )',                                                 [                               ] ],
   [ 'split( "abc", "." )',                                              'return StrUtils.split( "abc", "." )',                                              [ "abc"                         ] ],
   [ 'split( "abc..def", "." )',                                         'return StrUtils.split( "abc..def", "." )',                                         [ "abc", "", "def"              ] ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.StrUtils', @$_ );
}

done_testing();
