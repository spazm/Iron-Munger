use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Deep;

BEGIN {
  use_ok 'IronMunger::CSVUtils', ':all';
}

use signatures;

sub filename ($fname, $means) {
  my $descr = join(' ', map +($_||'(undef)'), '=>', $fname, @$means);
  cmp_deeply(
    [ filename_to_name_and_nick($fname) ], $means,
    "Filename to name and nick for ${descr}",
  );
  is(
    name_and_nick_to_filename(@$means), $fname,
    "Name and nick to filename for ${descr}"
  );
}

sub means (%means) { [ @means{qw(name nick)} ] }

filename 'my_Jess_Robinson.csv',
  means
    name => 'Jess Robinson';

filename 'my_drrho.csv',
  means
    nick => 'drrho';

filename 'my_Wolfgang_Wiese__xwolf_.csv',
  means
    name => 'Wolfgang Wiese',
    nick => 'xwolf';
