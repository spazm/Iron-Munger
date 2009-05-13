use strict;
use warnings;
use inc::Module::Install;

name 'IronMunger';
version '0.001';

requires 'MooseX::Declare';
requires 'signatures';
requires 'autobox::DateTime::Duration';
requires 'MooseX::Types::DateTimeX';

WriteAll;
