use MooseX::Declare;

class IronMunger::StatsSaver {

  use MooseX::Types::Path::Class qw(Dir);

  has dir => (is => 'ro', isa => Dir, required => 1, coerce => 1);

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
    symlink($target, $from)
      or confess "Couldn't symlink ${from} to ${target}: $!";
    return;
  }
}

1;
