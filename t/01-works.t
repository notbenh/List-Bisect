#!/usr/bin/perl 

use strict;
use warnings;

use Test::More qw{no_plan};
BEGIN{ print qq{\n} for 1..10};

#-----------------------------------------------------------------
BEGIN {

   use_ok 'List::Bisect';
   can_ok 'main', qw{ bisect };

};
#---------------------------------------------------------------------------

my ($a,$b) = bisect {$_ <= 5} 1..10;
is_deeply $a, [1..5],  q{a is 1..5};
is_deeply $b, [6..10], q{b is 6..10};
