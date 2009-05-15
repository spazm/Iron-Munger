package IronMunger::CSVUtils;

use strict;
use warnings;
use Carp qw(confess);
use namespace::clean;
use Sub::Exporter -setup => {
  exports => [ qw(filename_to_name_and_nick name_and_nick_to_filename) ],
};

use signatures;

# So our plagger setup is weird. The filenames are of the form -
#
# my_${name}__${nick}_.csv
# my_${name}.csv
# my_${nick}.csv
#
# This corresponds to either 'My Name (mynick)', 'My Name' or 'mynick'
# in the plagger config.
# Rather than annoy people, I thought I'd just live with it by assuming
# any name has two or more sections.

sub filename_to_name_and_nick ($filename) {
  my ($body) = ($filename =~ m/^my_(.*?)_?\.csv$/);
  confess "Couldn't unpick ${filename} - see comments" unless $body;
  my ($name, $nick) = split(/__/, $body);
  if (!defined $nick && $name !~ /_/) {
    ($name, $nick) = (undef, $name);
  }
  $name = join(' ', split('_', $name)) if defined $name;
  return ($name, $nick);
}

sub name_and_nick_to_filename ($name, $nick) {
  $name = join('_', split(' ', $name)) if defined $name;
  my $body = do {
    my @def = (grep defined, $name, $nick);
    if (@def == 2) {
      "${name}__${nick}_";
    } else {
      $def[0];
    }
  };
  return "my_${body}.csv";
}

1;
