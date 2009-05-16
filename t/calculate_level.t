use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN {
  use_ok 'IronMunger::Calculate', 'level_for_post_count';
}

my @spec = qw(
  0 paper
  3 paper
  4 stone
  11 stone
  12 bronze
  35 bronze
  36 iron
  50 iron
);

while (@spec > 2) {
  my ($count, $level) = (shift(@spec),shift(@spec));
  is(level_for_post_count($count), $level, "${count} posts means ${level} man");
}
