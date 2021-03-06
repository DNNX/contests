#!/usr/bin/perl -w
use strict;
require '../common.pl';

# X...
# ....
# XX..
# .X..
# 
undef $/;

my @res = sort { $a cmp $b } uniq(map { rotate($_) } split /\n\n/, <>);
print join "\n\n", @res;
