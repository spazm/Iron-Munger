use MooseX::Declare;

class IronMunger::StatsSaver {

  use MooseX::Types::Path::Class qw(Dir);
  use aliased 'IronMunger::Monger';
  use IO::All;
  use File::Path qw(mkpath);
  use Text::CSV_XS;

  has dir => (is => 'ro', isa => Dir, required => 1, coerce => 1);

  my @types = qw(male female);

  method _image_symlink_target (Str $type, Str $level) {
    $self->dir->subdir('badges')->subdir($type)->file("${level}.png");
  }

  method _image_symlink_from (Str $user, Str $type) {
    $self->dir->subdir('mybadge')->subdir($type)->file("${user}.png");
  }

  method _write_image_symlink (Str $user, Str $type, Str $level) {
    my ($from, $target) = (
      $self->_image_symlink_from($user, $type),
      $self->_image_symlink_target($type, $level),
    );
    my $dir = File::Spec->catpath((File::Spec->splitpath($from))[0,1]);
    mkpath($dir);
    symlink($target, $from)
      or confess "Couldn't symlink ${from} to ${target}: $!";
    return;
  }

  method _write_symlinks_for (IronMunger::Monger $monger) {
    foreach my $type (@types) {
      foreach my $name (
          map $monger->$_,
            grep $monger->${\"has_$_"},
              qw(name nick)
        ) {
        $self->_write_image_symlink($name, $type, $monger->level);
      }
    }
  }

  method _write_summary_csv (ArrayRef[IronMunger::Monger] $mongers) {
  }

  method mongers (ArrayRef[IronMunger::Monger] $mongers) {
    $self->_write_summary_csv($mongers);
    $self->_write_symlinks_for($_) for @$mongers;
  }

}

1;
