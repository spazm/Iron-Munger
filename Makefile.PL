use strict;
use warnings;
use inc::Module::Install;

name 'IronMunger';
version '0.001';

requires 'MooseX::Declare';
requires 'signatures';
requires 'autobox::DateTime::Duration';
requires 'MooseX::Types::DateTimeX';
requires 'Text::CSV_XS';

test_requires 'Test::More';
test_requires 'Test::Deep';

auto_install;

WriteAll;
