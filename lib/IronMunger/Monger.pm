use MooseX::Declare;

class IronMunger::Monger {

  use MooseX::Types::Moose qw(ArrayRef);
  use IronMunger::Calculate qw(:all);
  use aliased 'IronMunger::Post';
  use signatures;

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
}

1;
