use MooseX::Declare;

class IronMunger::Monger {

  use MooseX::Types::Moose qw(ArrayRef Str);
  use IronMunger::Calculate qw(:all);
  use aliased 'IronMunger::Post';
  use signatures;

  has name => (is => 'ro', isa => Str, required => 0, predicate => 'has_name');
  has nick => (is => 'ro', isa => Str, required => 0, predicate => 'has_nick');

  method full_name () {
    join(' aka ',$self->name||'nameless',$self->nick||'anoncow');
  }

  has posts => (
    is => 'ro', isa => ArrayRef[Post], required => 1,
    default => sub { [] },
  );

  has post_count => (
    is => 'ro', lazy => 1,
    default => sub ($self) { successful_sequential_posts(@{$self->posts}) },
  );

  has days_left => (
    is => 'ro', lazy => 1,
    default => sub ($self) { days_remaining_to_post(@{$self->posts}) },
  );

  has level => (
    is => 'ro', lazy => 1,
    default => sub ($self) { level_for_post_count($self->post_count) }
  );

  method debug_dump () {
    join("\n",
      (map join(': ', $_, $self->$_),
        qw(full_name post_count days_left level)),
      'Posts:',
      join('',
        map { my $x = $_->debug_dump; $x =~ s/^/  /m; $x; } @{$self->posts}
      ),
      ''
    );
  }
}

1;
