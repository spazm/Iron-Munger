use strict;
use warnings;
use Test::More qw(no_plan);
use IO::All;
use File::Temp ();

sub tempdir {
  if ($ENV{UNCLEAN_TEMP}) {
    my $dir = File::Temp::tempdir;
    warn $dir;
    return $dir;
  }
  return File::Temp::tempdir(CLEANUP => 1);
}

BEGIN { use_ok aliased => 'IronMunger::StatsSaver'; }
BEGIN { use_ok aliased => 'IronMunger::Monger'; }

ok(
  (my $saver = StatsSaver->new(dir => 'X')),
  'Constructed object ok'
);

is(
  $saver->_image_symlink_target('male','iron'), '../../badges/male/iron.png',
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

my $dir = tempdir;

$saver = StatsSaver->new(dir => $dir);

$saver->_write_symlinks_for($monger);

my $bdir = io("${dir}/badges");

my $mbdir = io("${dir}/mybadge");

my %found_links;
do {
  my @l = $mbdir->all_links(2);
  @found_links{@l} = (1) x scalar @l;
};

foreach my $gender (qw(male female)) {
  my $desc = "${gender} symlink";
  my $l = io("${mbdir}/${gender}/mst.png");
  ok($l->is_link, "${desc} exists");
  is(
    $l->readlink, "../../badges/${gender}/paper.png",
    "${desc} points to right target",
  );
  ok(delete $found_links{$l}, "${desc} in link list");
}

ok(!(keys %found_links), 'all links accounted for');
