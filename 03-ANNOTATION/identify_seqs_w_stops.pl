#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;

MAIN: {
    my $file = $ARGV[0] or die "usage: $0 AA\n";
    my $fp = JFR::Fasta->new($file);
    while (my $rec = $fp->get_record()) {
        next if ($rec->{'seq'} =~ m/^[^\*]+.$/);
        print "$rec->{'def'}\n$rec->{'seq'}\n";
    }
}
