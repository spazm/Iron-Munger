use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN {
  use_ok 'IronMunger::Post';
  use_ok 'IronMunger::Calculate';
}

use autobox;
use autobox::DateTime::Duration;
use signatures;

sub named_eq ($test_name, $sub_name, $expected, @posts) {
  my $sub_ref = IronMunger::Calculate->can($sub_name);
  die "Couldn't find $sub_name in IronMunger::Calculate" unless $sub_ref;
  my $sub_description = join(' ', split '_', $sub_name);
  cmp_ok(
    $sub_ref->(@posts), '==', $expected,
    "${test_name}: ${expected} ${sub_description}",
  );
}

sub case ($name_spec, $case, $expect) {
  my $name = join(' ', map ucfirst, split '_', $name_spec);
  my @posts = map { IronMunger::Post->new(at => $_->days->ago) } @$case;
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
  [ 5, 13 ],
  expect
    sequential => 2,
    remaining => 5;

case two_posts_too_far_apart =>
  [ 5, 20 ],
  expect
    sequential => 1,
    remaining => 5;

case five_posts_ok_last_needed =>
  [ 4, 11, 18, 25, 32 ],
  expect
    sequential => 5,
    remaining => 6;

case five_posts_ok_aperture_needed =>
  [ 4, 11, 18, 28, 32 ],
  expect
    sequential => 5,
    remaining => 4;
