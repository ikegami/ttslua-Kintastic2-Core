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
   [ 'gcd( a*c, b*c )', 'return Math.gcd( 2*3*3*5, 2*3*3*7  )', 2*3*3   ],
   [ 'gcd( a, b )',     'return Math.gcd( 2*5*11,  3*7*13   )', 1       ],
   [ 'gcd( a, a )',     'return Math.gcd( 2*3*5*5, 2*3*5*5  )', 2*3*5*5 ],
   [ 'gcd( a, a*c )',   'return Math.gcd( 2*2*5,   2*2*5*11 )', 2*2*5   ],
   [ 'gcd( a, 0 )',     'return Math.gcd( 257,     0        )', 257     ],
   [ 'gcd( 0, b )',     'return Math.gcd( 0,       181      )', 181     ],
   [ 'gcd( 0, 0 )',     'return Math.gcd( 0,       0        )', 0       ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.Math', @$_ );
}

done_testing();
