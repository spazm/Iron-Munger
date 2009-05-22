use strict;
use warnings;
use Test::More qw(no_plan);
use IO::All;
use File::Temp qw(tempdir);

BEGIN { use_ok aliased => 'IronMunger::StatsSaver'; }
BEGIN { use_ok aliased => 'IronMunger::Monger'; }

ok(
  (my $saver = StatsSaver->new(dir => 'X')),
  'Constructed object ok'
);

is(
  $saver->_image_symlink_target('male','iron'), 'X/badges/male/iron.png',
  'Symlink target ok',
);

is(
  $saver->_image_symlink_from('mst', 'female'), 'X/mybadge/female/mst.png',
  'Symlink from ok',
);

my $monger = Monger->new(
  nick => 'mst',
  posts => []
);

is($monger->level, 'paper', 'mst sucks');

my $dir = tempdir(CLEANUP => 1);

$saver = StatsSaver->new(dir => $dir);

$saver->_write_symlinks_for($monger);

my @links = sort map $_->readlink, grep -l, io($dir)->all_files;

warn join("\n", @links);
