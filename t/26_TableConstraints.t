#!perl

use v5.14;
use strict;
use warnings;

use lib "t/lib";

use Test::More;
use Test::Deep qw( false true re );

use TestUtils qw( basic_test port_check );

if ( !port_check() ) {
   diag( "**********************************************\n" .
         "****     Problem establishing server.     ****\n" .
         "**** Make sure Atom/VSCode isn't running. ****\n" .
         "**********************************************\n" );
}

my @tests = (
   [ 'const - Access existing',           'local t = TableConstraints.const(       { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.a end );  return { success, rv, t }', [ true,  4,                                                { a => 4, b => 5, c => 6 } ] ],
   [ 'const - Modify existing',           'local t = TableConstraints.const(       { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.a = 7    end );  return { success, rv, t }', [ false, re( qr/Modification of field a of const/       ), { a => 4, b => 5, c => 6 } ] ],
   [ 'const - Access non-existing',       'local t = TableConstraints.const(       { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.d end );  return { success, rv, t }', [ false, re( qr/Access of undeclared field d of const/  ), { a => 4, b => 5, c => 6 } ] ],
   [ 'const - Modify non-existing',       'local t = TableConstraints.const(       { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.d = 8    end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to const/       ), { a => 4, b => 5, c => 6 } ] ],

   [ 'const_lkup - Access existing',      'local t = TableConstraints.const_lkup(  { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.a end );  return { success, rv, t }', [ true,  4,                                                { a => 4, b => 5, c => 6 } ] ],
   [ 'const_lkup - Modify existing',      'local t = TableConstraints.const_lkup(  { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.a = 7    end );  return { success, rv, t }', [ false, re( qr/Modification of field a of const/       ), { a => 4, b => 5, c => 6 } ] ],
   [ 'const_lkup - Access non-existing',  'local t = TableConstraints.const_lkup(  { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.d end );  return { success, rv, t }', [ true,  undef,                                            { a => 4, b => 5, c => 6 } ] ],
   [ 'const_lkup - Modify non-existing',  'local t = TableConstraints.const_lkup(  { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.d = 8    end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to const_lkup/  ), { a => 4, b => 5, c => 6 } ] ],

   [ 'struct - Access existing',          'local t = TableConstraints.struct(      { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.a end );  return { success, rv, t }', [ true,  4,                                                { a => 4, b => 5, c => 6 } ] ],
   [ 'struct - Modify existing',          'local t = TableConstraints.struct(      { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.a = 7    end );  return { success, rv, t }', [ true,  undef,                                            { a => 7, b => 5, c => 6 } ] ],
   [ 'struct - Access non-existing',      'local t = TableConstraints.struct(      { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.d end );  return { success, rv, t }', [ false, re( qr/Access of undeclared field d of struct/ ), { a => 4, b => 5, c => 6 } ] ],
   [ 'struct - Modify non-existing',      'local t = TableConstraints.struct(      { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.d = 8    end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to struct/      ), { a => 4, b => 5, c => 6 } ] ],

   [ 'struct_lkup - Access existing',     'local t = TableConstraints.struct_lkup( { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.a end );  return { success, rv, t }', [ true,  4,                                                { a => 4, b => 5, c => 6 } ] ],
   [ 'struct_lkup - Modify existing',     'local t = TableConstraints.struct_lkup( { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.a = 7    end );  return { success, rv, t }', [ true,  undef,                                            { a => 7, b => 5, c => 6 } ] ],
   [ 'struct_lkup - Access non-existing', 'local t = TableConstraints.struct_lkup( { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() return t.d end );  return { success, rv, t }', [ true,  undef,                                            { a => 4, b => 5, c => 6 } ] ],
   [ 'struct_lkup - Modify non-existing', 'local t = TableConstraints.struct_lkup( { a = 4, b = 5, c = 6 } );  local success, rv = pcall( function() t.d = 8    end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to struct_lkup/ ), { a => 4, b => 5, c => 6 } ] ],

   [ 'on_violation - Absent',        '                  local t = TableConstraints.struct( { a = 4 }                                                           );  local success, rv = pcall( function() t.d = 8 end );  return { success,       t }', [ false,                                                                                               { a => 4         } ] ],
   [ 'on_violation - Returns false', 'local args = nil; local t = TableConstraints.struct( { a = 4 }, function( ... ) args = { ... }; return false; end        );  local success, rv = pcall( function() t.d = 8 end );  return { success, args, t }', [ true,  [ undef, "Addition of new field d to struct", "add", "struct", { a => 4         }, "d", 8 ], { a => 4         } ] ],
   [ 'on_violation - Returns true',  'local args = nil; local t = TableConstraints.struct( { a = 4 }, function( ... ) args = { ... }; return true;  end        );  local success, rv = pcall( function() t.d = 8 end );  return { success, args, t }', [ true,  [ undef, "Addition of new field d to struct", "add", "struct", { a => 4, d => 8 }, "d", 8 ], { a => 4, d => 8 } ] ],
   [ 'on_violation - With data',     'local args = nil; local t = TableConstraints.struct( { a = 4 }, function( ... ) args = { ... }; return true;  end, "xyz" );  local success, rv = pcall( function() t.d = 8 end );  return { success, args, t }', [ true,  [ "xyz", "Addition of new field d to struct", "add", "struct", { a => 4, d => 8 }, "d", 8 ], { a => 4, d => 8 } ] ],

   [ 'const_if - False',         'local t = TableConstraints.const_if(         false,       { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ true,  undef,                                                   { a => 4, d => 8 }   ] ],
   [ 'const_lkup_if - False',    'local t = TableConstraints.const_lkup_if(    false,       { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ true,  undef,                                                   { a => 4, d => 8 }   ] ],
   [ 'struct_if - False',        'local t = TableConstraints.struct_if(        false,       { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ true,  undef,                                                   { a => 4, d => 8 }   ] ],
   [ 'struct_lkup_if - False',   'local t = TableConstraints.struct_lkup_if(   false,       { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ true,  undef,                                                   { a => 4, d => 8 }   ] ],

   [ 'const_if - True',          'local t = TableConstraints.const_if(         true,        { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ false, re( qr/Addition of new field d to const/       ),        { a => 4         }   ] ],
   [ 'const_lkup_if - True',     'local t = TableConstraints.const_lkup_if(    true,        { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ false, re( qr/Addition of new field d to const_lkup/  ),        { a => 4         }   ] ],
   [ 'struct_if - True',         'local t = TableConstraints.struct_if(        true,        { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ false, re( qr/Addition of new field d to struct/      ),        { a => 4         }   ] ],
   [ 'struct_lkup_if - True',    'local t = TableConstraints.struct_lkup_if(   true,        { a = 4 }   );  local success, rv = pcall( function() t.d = 8 end );  return { success, rv, t }',   [ false, re( qr/Addition of new field d to struct_lkup/ ),        { a => 4         }   ] ],

   [ 'const_r',                  'local t = TableConstraints.const_r(                 { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to const/       ), { x => { a => 4         } } ] ],
   [ 'const_lkup_r',             'local t = TableConstraints.const_lkup_r(            { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to const_lkup/  ), { x => { a => 4         } } ] ],
   [ 'struct_r',                 'local t = TableConstraints.struct_r(                { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to struct/      ), { x => { a => 4         } } ] ],
   [ 'struct_lkup_r',            'local t = TableConstraints.struct_lkup_r(           { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to struct_lkup/ ), { x => { a => 4         } } ] ],

   [ 'const_r_if - False',       'local t = TableConstraints.const_r_if(       false, { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ true,  undef,                                            { x => { a => 4, d => 8 } } ] ],
   [ 'const_lkup_r_if - False',  'local t = TableConstraints.const_lkup_r_if(  false, { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ true,  undef,                                            { x => { a => 4, d => 8 } } ] ],
   [ 'struct_r_if - False',      'local t = TableConstraints.struct_r_if(      false, { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ true,  undef,                                            { x => { a => 4, d => 8 } } ] ],
   [ 'struct_lkup_r_if - False', 'local t = TableConstraints.struct_lkup_r_if( false, { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ true,  undef,                                            { x => { a => 4, d => 8 } } ] ],

   [ 'const_r_if - True',        'local t = TableConstraints.const_r_if(       true,  { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to const/       ), { x => { a => 4         } } ] ],
   [ 'const_lkup_r_if - True',   'local t = TableConstraints.const_lkup_r_if(  true,  { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to const_lkup/  ), { x => { a => 4         } } ] ],
   [ 'struct_r_if - True',       'local t = TableConstraints.struct_r_if(      true,  { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to struct/      ), { x => { a => 4         } } ] ],
   [ 'struct_lkup_r_if - True',  'local t = TableConstraints.struct_lkup_r_if( true,  { x = { a = 4 } } );  local success, rv = pcall( function() t.x.d = 8 end );  return { success, rv, t }', [ false, re( qr/Addition of new field d to struct_lkup/ ), { x => { a => 4         } } ] ],

   [ 'declare - Single arg',    'local t = TableConstraints.struct( { a = 4 } );  local t2 = TableConstraints.declare( t,           "d" );  t.d = 8;  return { t, t2 }', [ { a => 4, d => 8 }, { a => 4, d => 8 } ] ],
   [ 'declare - Multi args',    'local t = TableConstraints.struct( { a = 4 } );  local t2 = TableConstraints.declare( t, "a", "c", "d" );  t.d = 8;  return { t, t2 }', [ { a => 4, d => 8 }, { a => 4, d => 8 } ] ],
   [ 'declare - No constraint', 'local t =                          { a = 4 };    local t2 = TableConstraints.declare( t,           "d" );  t.d = 8;  return { t, t2 }', [ { a => 4, d => 8 }, { a => 4, d => 8 } ] ],

   [ 'set - struct - Existing',     'local t = TableConstraints.struct( { a = 4 } );  local v = TableConstraints.set( t, "a", 8 );            return { t, v }', [ { a => 8         }, 8 ] ],
   [ 'set - struct - Non-existing', 'local t = TableConstraints.struct( { a = 4 } );  local v = TableConstraints.set( t, "d", 8 );            return { t, v }', [ { a => 4, d => 8 }, 8 ] ],
   [ 'set - struct - Declared',     'local t = TableConstraints.struct( { a = 4 } );  local v = TableConstraints.set( t, "d", 8 );  t.d = 9;  return { t, v }', [ { a => 4, d => 9 }, 8 ] ],
   [ 'set - const - Existing',      'local t = TableConstraints.const(  { a = 4 } );  local v = TableConstraints.set( t, "a", 8 );            return { t, v }', [ { a => 8         }, 8 ] ],
   [ 'set - const - Non-existing',  'local t = TableConstraints.const(  { a = 4 } );  local v = TableConstraints.set( t, "d", 8 );            return { t, v }', [ { a => 4, d => 8 }, 8 ] ],
   [ 'set - No constraint',         'local t =                          { a = 4 };    local v = TableConstraints.set( t, "d", 8 );            return { t, v }', [ { a => 4, d => 8 }, 8 ] ],

   [ 'get - struct - Existing',     'local t = TableConstraints.struct( { a = 4 } );  local v = TableConstraints.get( t, "a" );               return { t, v }', [ { a => 4 }, 4     ] ],
   [ 'get - struct - Non-existing', 'local t = TableConstraints.struct( { a = 4 } );  local v = TableConstraints.get( t, "d" );               return { t, v }', [ { a => 4 }        ] ],
   [ 'get - const - Existing',      'local t = TableConstraints.const(  { a = 4 } );  local v = TableConstraints.get( t, "a" );               return { t, v }', [ { a => 4 }, 4     ] ],
   [ 'get - const - Non-existing',  'local t = TableConstraints.const(  { a = 4 } );  local v = TableConstraints.get( t, "d" );               return { t, v }', [ { a => 4 }        ] ],
   [ 'get - No constraint',         'local t =                          { a = 4 };    local v = TableConstraints.get( t, "d" );               return { t, v }', [ { a => 4 }        ] ],

   [ 'merge_into - struct',            'local t = TableConstraints.struct( { a = 4, b = 5 } );  local t2 = TableConstraints.merge_into( t, { a = 7, d = 8 } );            return { t, t2 }', [ { a => 7, b => 5, d => 8 }, { a => 7, b => 5, d => 8 } ] ],
   [ 'merge_into - struct - Declared', 'local t = TableConstraints.struct( { a = 4, b = 5 } );  local t2 = TableConstraints.merge_into( t, { a = 7, d = 8 } );  t.d = 9;  return { t, t2 }', [ { a => 7, b => 5, d => 9 }, { a => 7, b => 5, d => 9 } ] ],
   [ 'merge_into - const',             'local t = TableConstraints.const(  { a = 4, b = 5 } );  local t2 = TableConstraints.merge_into( t, { a = 7, d = 8 } );            return { t, t2 }', [ { a => 7, b => 5, d => 8 }, { a => 7, b => 5, d => 8 } ] ],
   [ 'merge_into - No constraint',     'local t =                          { a = 4, b = 5 };    local t2 = TableConstraints.merge_into( t, { a = 7, d = 8 } );            return { t, t2 }', [ { a => 7, b => 5, d => 8 }, { a => 7, b => 5, d => 8 } ] ],

   [ 'unlock - struct - Existing',     'local t = TableConstraints.struct( { a = 4 } );  TableConstraints.unlock( t, function( t ) t.a = 8 end );            return t', { a => 8         } ],
   [ 'unlock - struct - Non-existing', 'local t = TableConstraints.struct( { a = 4 } );  TableConstraints.unlock( t, function( t ) t.d = 8 end );            return t', { a => 4, d => 8 } ],
   [ 'unlock - struct - Declared',     'local t = TableConstraints.struct( { a = 4 } );  TableConstraints.unlock( t, function( t ) t.d = 8 end );  t.d = 9;  return t', { a => 4, d => 9 } ],
   [ 'unlock - const - Existing',      'local t = TableConstraints.const(  { a = 4 } );  TableConstraints.unlock( t, function( t ) t.a = 8 end );            return t', { a => 8         } ],
   [ 'unlock - const - Non-existing',  'local t = TableConstraints.const(  { a = 4 } );  TableConstraints.unlock( t, function( t ) t.d = 8 end );            return t', { a => 4, d => 8 } ],
   [ 'unlock - No constraint',         'local t =                          { a = 4 };    TableConstraints.unlock( t, function( t ) t.d = 8 end );            return t', { a => 4, d => 8 } ],
);

for ( @tests ) {
   basic_test( 'lib', 'Kintastic2.Core.TableConstraints', @$_ );
}

done_testing();
