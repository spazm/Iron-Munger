package IronMunger::Calculate;

use strict;
use warnings;
use List::Util qw(min);
use autobox;
use autobox::DateTime::Duration;
use signatures;

use Sub::Exporter -setup => {
  exports => [
    qw(successful_sequential_posts time_remaining_to_post)
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
  return 0 if day_diff(DateTime->now, $next_post[-1]) > $days;
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
  my $cand = (@posts > $aperture ? $posts[$aperture - 1] : $posts[-1]);
  my $days_ago = day_diff(DateTime->now, $cand);
  return $days - $days_ago;
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

1;
