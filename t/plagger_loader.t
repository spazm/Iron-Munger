use strict;
use warnings;
use Test::More qw(no_plan);
use IO::All;

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

{
  my %args = (url => 'http://foo.com', at => '2008-04-06T12:00:00');

  ok(my $post = $loader->_expand_post(\%args), 'Expand post constructs object');

  foreach my $key (sort keys %args) {
    is($post->$key, $args{$key}, "Attribute ${key} ok");
  }
}

my @postspecs = map
  +{
    url => 'http://jdv79.blogspot.com/2009/05/testable-v007.html',
    at => $_,
   }, qw(2009-05-13T02:45:00 2009-05-14T16:00:00);

my $jdv_file = io('t/csv/my_Justin_DeVuyst.csv');

my $specs = $loader->_expand_postspecs_from_file($jdv_file);

is_deeply($specs, \@postspecs, 'Post specs from file ok');

my $posts = $loader->_expand_posts_from_file($jdv_file);

cmp_ok(scalar(@$posts), '==', scalar(@postspecs), 'Right number of posts');

foreach my $i (0, 1) {
  my %spec = %{$postspecs[$i]};
  my $post = $posts->[$i];
  foreach my $key (sort keys %spec) {
    is($post->$key, $spec{$key}, "Attribute ${key} ok for post ${i}");
  }
}

