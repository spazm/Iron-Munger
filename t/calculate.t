use strict;
use warnings;
use Test::More qw(no_plan);

use autobox::DateTime::Duration;
use signatures;

BEGIN {
  use_ok 'IronMunger::Post';
  use_ok 'IronMunger::Calculate';
}

sub named_eq ($test_name, $sub_name, $expected, @posts) {
  my $sub_ref = IronMunger::Calculate->can($sub_name);
  my $sub_description = join(' ', split '_', $sub_name);
  cmp_ok(
    $sub_ref->(@posts), '==', $expected,
    "${test_name}: ${expected} ${sub_description}",
  );
}

sub case ($name_spec, $case, $expect) {
  my $name = join(' ', map ucfirst, split '_', $name_spec);
  my @posts = map { IronMunger::Post->new(at => $_) } @$case;
  foreach my $test (sort keys %$expect) {
    named_eq($name, $test, $expect->{$test}, @posts);
  }
}

sub expect (%expect) {
  +{
    successful_sequential_posts => $expect{sequential},
    days_remaining_to_post => $expect{remaining},
  };
}

case two_posts_ok =>
  [ 5->days->ago, 13->days->ago ],
  expect
    sequential => 2,
    remaining => 5;

case two_posts_too_far_apart =>
  [ 5->days->ago, 20->days->ago ],
  expect
    sequential => 1,
    remaining => 5;
