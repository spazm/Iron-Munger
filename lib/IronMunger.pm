use MooseX::Declare;

class IronMunger {

  our $VERSION = '0.001000';

  use aliased 'IronMunger::Monger';
  use aliased 'IronMunger::PlaggerLoader';
  use aliased 'IronMunger::StatsSaver';

  use MooseX::Types::Moose qw(HashRef ClassName Str);

  has mongers => (
    is => 'ro', isa => HashRef[Monger], required => 1
    default => sub { {} },
  );

  method load_from_plagger (ClassName $class: Str $dir) {
    my $loader = PlaggerLoader->new(dir => $dir);
    my $munger = $class->new;
    $munger->mongers->{$_->full_name}
      = $_ for @{$loader->mongers};
  }

  method save_monger_stats (Str $dir) {
    my $saver = StatsSaver->new(dir => $dir);
    $saver->mongers([ sort $_->full_name, values %{$self->mongers} ]);
  }
}

1;
