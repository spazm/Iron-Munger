use strict;
use warnings;
use Test::More qw(no_plan);
use autobox;
use autobox::DateTime::Duration;

BEGIN {
  use_ok aliased => 'IronMunger::Monger';
  use_ok aliased => 'IronMunger::Post';
}

my $monger = Monger->new(
  posts => [
    map { Post->new(url => 'http://localhost', at => $_->days->ago) } (2, 10)
  ]
);

cmp_ok($monger->days_left, '==', 8, 'Eight days to post');
cmp_ok($monger->post_count, '==', 2, 'Two sequential posts');
