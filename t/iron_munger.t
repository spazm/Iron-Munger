use strict;
use warnings;
use Test::More qw(no_plan);
use File::Temp 'tempdir';

BEGIN {
  use_ok "IronMunger";
}

my $munger = IronMunger->load_from_plagger('t/csv');

$munger->save_monger_stats('whut');
