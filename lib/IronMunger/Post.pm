use MooseX::Declare;

class IronMunger::Post {

  use MooseX::Types::Moose qw(Str);
  use MooseX::Types::DateTimeX qw(DateTime);

  has at => (isa => DateTime, is => 'ro', required => 1, coerce => 1);

  has url => (isa => Str, is => 'ro', required => 1);

  method debug_dump () {
    join("\n", (map join(': ', $_, $self->$_), qw(at url)), '');
  }
}

1;
