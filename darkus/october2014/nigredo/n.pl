#!/usr/bin/perl -w
use strict;
require '../common.pl';

# ..xx
# ..xx
# xxxx
# xxxx

undef $/;
my @res = sort { $a cmp $b } uniq (map { tr/.x/X./; rotate($_) } split /\n\n/, <>);
print join "\n\n", @res;