use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN {
  use_ok aliased => 'IronMunger::PlaggerLoader';
}

ok(my $loader = PlaggerLoader->new(dir => 't/csv'), 'build loader');


