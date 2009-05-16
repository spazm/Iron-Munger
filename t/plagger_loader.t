use strict;
use warnings;
use Test::More qw(no_plan);


BEGIN {
  use_ok aliased => 'IronMunger::PlaggerLoader';
}

my @names = ('Jess Robinson', 'Justin DeVuyst');

my @files = ('my_Jess_Robinson.csv', 'my_Justin_DeVuyst.csv');

ok(my $loader = PlaggerLoader->new(dir => 't/csv'), 'build loader');

my @target = $loader->_target_files;

cmp_ok(@target, '==', 2, '2 files in CSV directory');

is_deeply(
  [ sort map { ($_->splitpath)[-1] } @target ], \@files,
  'filenames ok'
);
