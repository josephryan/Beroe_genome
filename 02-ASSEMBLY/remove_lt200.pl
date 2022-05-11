#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;

our $FILE = $ARGV[0] or die "usage: $0 FILE\n";

MAIN: {
    my $fp = JFR::Fasta->new($FILE);
    while (my $rec = $fp->get_record()) {
        next unless (length($rec->{'seq'}) >= 200);
        print "$rec->{'def'}\n$rec->{'seq'}\n";
    }
}
