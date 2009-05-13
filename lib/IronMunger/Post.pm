use MooseX::Declare;

class IronMunger::Post {

  use MooseX::Types::DateTimeX qw(DateTime);

  has at => (isa => DateTime, is => 'rw', required => 1);
}

1;
