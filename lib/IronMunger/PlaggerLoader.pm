use MooseX::Declare;

class IronMunger::PlaggerLoader {

  use MooseX::Types::Path::Class qw(Dir);
  use MooseX::Types::Moose qw(HashRef);
  use Moose::Util::TypeConstraints qw(class_type);

  BEGIN { class_type 'IO::All::File'; }

  use IronMunger::CSVUtils qw(:all);

  use aliased 'IronMunger::Post';

  use IO::All;
  use Text::CSV_XS;

  has dir => (is => 'ro', isa => Dir, required => 1, coerce => 1);

  method _target_files () {
    grep $_->name =~ /\.csv$/, io($self->dir)->all_files;
  }

  method _expand_post (HashRef $post_spec) {
    Post->new($post_spec);
  }

  method _expand_posts_from_file(IO::All::File $file) {
    return [
      map $self->_expand_post($_),
        @{$self->_expand_postspecs_from_file($file)},
    ];
  }

  method _csv_column_order () {
    my $x;
    return map +($_ => $x++), qw(author title url at);
  }

  method _expand_postspecs_from_file(IO::All::File $file) {
    my $csv = Text::CSV_XS->new;
    my $io = $file->open;
    my @post_specs;
    my %col_order = $self->_csv_column_order;
    while (my $post_raw = $csv->getline($io)) {
      my %post_spec;
      @post_spec{qw{url at}} = @{$post_raw}[@col_order{qw{url at}}];
      push(@post_specs, \%post_spec);
    }
    return \@post_specs;
  }

  method _expand_monger (IO::All::File $file) {
    my ($name, $nick) = name_and_nick_from_filename($file->name);
    Monger->new(
      (defined $name ? (name => $name) : ()),
      (defined $nick ? (nick => $nick) : ()),
      posts => $self->_expand_posts_from_file($file),
    );
  }

  method mongers () {
    map $self->_expand_monger($_), $self->_target_files;
  }
}

1;
