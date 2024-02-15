#!/usr/bin/perl

$|++;

use strict;
use warnings;

# requires https://github.com/josephryan/JFR-PerlModules
use JFR::Translate;
use JFR::Fasta;

# OLD HARDCODE VERSION
#our $FA = '/bwdata2/jfryan/00-DATA/Bova1.4.fa';
#our $FA = '/bwdata2/jfryan/00-DATA/MlScaffold09.fa';

MAIN: {
    my $fa = $ARGV[0] or die "useage: FASTA\n";
    my $fp = JFR::Fasta->new($fa);
    while (my $rec = $fp->get_record()) {
        foreach my $frame (1, 2, 3, -1, -2, -3) {
            my $tr_seq = JFR::Translate::translate($rec->{'seq'},$frame);
            if ($tr_seq =~ m/FDG[^\*]?D[^\*]D[^\*]E/) {
#                $tr_seq =~ m/(.{,30}FDG.?D.D.E.{,30})/;
#                my $match = $1 || '';
                my $match = '';
                if ($tr_seq =~ m/(.{30}FDG.?D.D.E.{30})/) {
                    $match = $1;
                } elsif ($tr_seq =~ m/(.{30}FDG.?D.D.E.)/) {
                    $match = $1;
                } elsif ($tr_seq =~ m/(FDG.?D.D.E.).{30}/) {
                    $match = $1;
                }
                print "$rec->{'def'} -- FRAME=$frame\n$match\n";
            }
        }
    }
}
