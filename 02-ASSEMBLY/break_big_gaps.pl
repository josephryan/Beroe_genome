#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;

MAIN: {
    my $fasta  = $ARGV[0] or die "usage: $0 FASTA MAXGAP\n";
    my $maxgap = $ARGV[1] or die "usage: $0 FASTA MAXGAP\n";
    my $fp = JFR::Fasta->new($fasta);
    my $overmax = $maxgap + 1;
    while (my $rec = $fp->get_record()) {
        if ($rec->{'seq'} =~ m/N{$overmax}/) {
            my @seqs = split /N{$overmax,}/, $rec->{'seq'};
            my $count = 0;
            foreach my $seq (@seqs) {
                $count++;
                my $dl = $rec->{'def'} . '.' . $count;
                print "$dl\n$seq\n";
            }
        } else {
            print "$rec->{'def'}\n$rec->{'seq'}\n";
        }
    }
}

