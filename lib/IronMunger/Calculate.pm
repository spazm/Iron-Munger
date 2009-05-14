package IronMunger::Calculate;

use strict;
use warnings;
use autobox;
use autobox::DateTime::Duration;
use signatures;

use Sub::Exporter -setup => {
  exports => [
    qw(successful_sequential_posts time_remaining_to_post)
  ]
};

sub check_post_gap ($aperture, $days, @posts) {
  return @posts if @posts <= $aperture;
  my @next_post = splice(@posts, 0, $aperture);
  return 0 if DateTime->now - $next_post[-1]->at > $days->days;
  my $success = $aperture;
  foreach my $post (@posts) {
    return $success if $next_post[0]->at - $post->at > $days->days;
    $success++;
    shift(@next_post);
    push(@next_post, $post);
  }
  return $success;
}

sub check_time_remaining ($aperture, $days, @posts) {
  my $cand = (@posts > $aperture ? $posts[$aperture - 1] : $posts[-1]);
  return $days->days - (DateTime->now - $cand->at)->in_units('days');
}

sub check_both ($check, @posts) {
  return max(
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
