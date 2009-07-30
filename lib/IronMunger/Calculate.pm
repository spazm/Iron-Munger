package IronMunger::Calculate;

use strict;
use warnings;
use List::Util qw(min);
use autobox;
use autobox::DateTime::Duration;
use signatures;

use Sub::Exporter -setup => {
  exports => [
    qw(successful_sequential_posts days_remaining_to_post level_for_post_count)
  ]
};

sub day_diff ($dt1, $dt2) {
  $dt1 = $dt1->at if $dt1->isa('IronMunger::Post');
  $dt2 = $dt2->at if $dt2->isa('IronMunger::Post');
  $dt1->delta_days($dt2)->delta_days;
}

sub check_post_gap ($aperture, $days, @posts) {
  return scalar @posts if @posts <= $aperture;
  my @next_post = splice(@posts, 0, $aperture);
  if (day_diff(DateTime->now, $next_post[-1]) > $days) {
    while (@next_post && day_diff(DateTime->now, $next_post[-1]) > $days) {
      pop @next_post;
    }
    return scalar(@next_post);
  }
  my $success = $aperture;
  foreach my $post (@posts) {
    if (day_diff($next_post[0],$post) > $days) {
      return $success;
    }
    $success++;
    shift(@next_post);
    push(@next_post, $post);
  }
  return $success;
}

sub check_time_remaining ($aperture, $days, @posts) {
  my @consider = @posts > $aperture ? @posts[0 .. $aperture - 1] : @posts;
  foreach my $cand (reverse @consider) {
    my $days_ago = day_diff(DateTime->now, $cand);
    return $days - $days_ago if $days > $days_ago;
  }
  return $days;
}

sub check_both ($check, @posts) {
  return min(
    $check->(1, 10, @posts), # 10 days between posts
    $check->(4, 32, @posts), # 4 posts within any given 32 days
  );
}

sub successful_sequential_posts (@posts) {
  return check_both(\&check_post_gap, @posts);
}

sub days_remaining_to_post (@posts) {
  return check_both(\&check_time_remaining, @posts);
}

sub level_for_post_count($count) {
  return 'paper' if $count < 4;
  return 'stone' if $count < 12;
  return 'bronze' if $count < 36;
  return 'iron';
}

1;
