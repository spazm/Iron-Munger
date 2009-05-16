use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN { use_ok aliased => 'IronMunger::StatsSaver'; }

ok(
  (my $saver = StatsSaver->new(dir => 'X')),
  'Constructed object ok'
);

is(
  $saver->_image_symlink_target('male','iron'), 'X/badges/male/iron.png',
  'Symlink target ok',
);

is(
  $saver->_image_symlink_from('mst', 'female',), 'X/mybadge/female/mst.png',
  'Symlink from ok',
);
