#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;

#our $DIR = 'I10.multi';
#our $OUTDIR = 'I10.renamed';
our $DIR = 'I1.5.multi';
our $OUTDIR = 'I1.5.renamed';
our $THREADS = 250;
our $MODEL = 'LG+G4';
our $MIN_TAXA = 4;

MAIN: {
    my $ra_files = get_files($DIR);
    my $ra_seqs = process_files($ra_files);
    my $ra_pre = run_mafft_and_iqtree($ra_seqs);
}

sub run_mafft_and_iqtree {
    my $ra_s = shift;
    foreach my $fa (@{$ra_s}) {
        $fa =~ m|(.*).fa| or die "unexpected $fa";
        my $pre = $1;
        system "mafft $fa > $pre.mafft";
        system "iqtree -s $pre.mafft -m $MODEL -nt $THREADS";
    }
}

sub process_files {
    my $ra_f = shift;
    my @seqs = ();

    foreach my $file (@{$ra_f}) {
        my %seen = ();
        my $fp = JFR::Fasta->new($file);
        my $seqs = '';
        my $total = 0;
        while (my $rec = $fp->get_record()) {
            $total++;
            my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
            if ($id =~ m/^(Bova1_5\.\d+\.g\d+)\.t\d+/) {
                my $bid = $1;
                next if ($seen{$bid});
                $seen{$bid}++;
                $seen{'Bo'}++;
#                $id =~ s/^Bova/Bova\@/;
                $seqs .= ">$id\n$rec->{'seq'}\n";
            } elsif ($id =~ m/^ML/) {
                $seen{'Ml'}++;
#                $id =~ s/^ML/ML\@/;
                $seqs .= ">$id\n$rec->{'seq'}\n";
            } else {
                die "unexpected sequence";
            }
        }
        next unless ($total >= $MIN_TAXA);
        if ($seen{'Bo'} && $seen{'Ml'}) {
            # the following skips seqs that are 1-to-1 but have isoforms
            next if (($seen{'Bo'} == 1) && ($seen{'Ml'} == 1)); 
            $file =~ m|[^/]+/(.*)| or die "unexpected $file";
            my $fi = $1;
            open OUT, ">$OUTDIR/$fi" or die "cannot open >$OUTDIR/$fi:$!";
            print OUT $seqs;
            push @seqs, "$OUTDIR/$fi";
        }
    }
    return \@seqs;
}

sub get_files {
    my $dir = shift;
    my @files = ();
    opendir DIR, $dir or die "cannot opendir $dir:$!";
    my @nodots = grep { /^[^.]/ } readdir DIR;
    foreach my $nd (@nodots) {
        push @files, "$dir/$nd";
    }
    return \@files;
}
