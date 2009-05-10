
sub check_post_gap (@posts) {
  my $next_post = shift(@posts);
  my $success = 1;
  foreach my $post (@posts) {
    return $success if $next_post->at - $post->at > 7->days;
    $success++;
    $next_post = $post;
  }
  return $success;
}

sub check_posts_rolling (@posts) {
  return @posts if @posts <= 3;
  my @next_post = splice(@posts, 0, 3);
  my $success = 3;
  foreach my $post (@posts) {
    return $success if $next_post[0]->at - $post->at > 30->days;
    $success++;
    shift(@next_post);
    push(@next_post, $post);
  }
  return $success;
}
