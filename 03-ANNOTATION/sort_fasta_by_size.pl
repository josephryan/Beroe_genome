#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;

MAIN: {
    my $fa = $ARGV[0] or die "usage:$0 FASTA\n";
    my $fp = JFR::Fasta->new($fa);
    my @recs = ();
    while (my $rec = $fp->get_record()) {
        push @recs, $rec;
    }
    foreach my $r (sort {length($b->{'seq'}) <=> length($a->{'seq'})} @recs) {
        my $len = length($r->{'seq'});
        print "$r->{'def'}\n$r->{'seq'}\n";
    }
}
