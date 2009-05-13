use strict;
use warnings;
use inc::Module::Install;

name 'IronMunger';

requires 'MooseX::Declare';
requires 'signatures';
requires 'autobox::DateTime::Duration';

WriteAll;
