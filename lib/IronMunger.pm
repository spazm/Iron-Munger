use MooseX::Declare;

class IronMunger {

  our $VERSION = '0.001000';

  use aliased 'IronMunger::PlaggerLoader';
  use aliased 'IronMunger::StatsSaver';
  use aliased 'IronMunger::Monger';

  use MooseX::Types::Moose qw(HashRef ClassName Str);

  has mongers => (
    is => 'ro', isa => HashRef[Monger], required => 1,
    default => sub { {} },
  );

  method load_from_plagger (ClassName $class: Str $dir) {
    my $loader = PlaggerLoader->new(dir => $dir);
    my $munger = $class->new;
    $munger->mongers->{$_->full_name}
      = $_ for $loader->mongers;
    return $munger;
  }

  method save_monger_stats (Str $dir) {
    my $saver = StatsSaver->new(dir => $dir);
    $saver->mongers([
      sort { $a->full_name cmp $b->full_name }
        values %{$self->mongers}
    ]);
  }
}

1;
