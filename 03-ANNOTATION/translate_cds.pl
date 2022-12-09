#!/usr/bin/perl

our $VERSION = 0.02;

use lib qw(/home/s9/jfryan/lib);
use strict;
use warnings;
use JFR::Translate;
use JFR::Fasta;
use Data::Dumper;

our $BLAST = 'tmp3.blastx';

MAIN: {
    my $file = $ARGV[0] or usage();
    usage() if ($ARGV[1] && $ARGV[1] ne '--shortdef');
    my $rh_blast_frames = get_blast_frames($BLAST);
    my $fp = JFR::Fasta->new($file);
    my $frame = 1;
    while (my $rec = $fp->get_record()) {
        my $tr_seq = JFR::Translate::translate($rec->{'seq'},$frame);
        my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
        if ($rh_blast_frames->{$id}) {
            $tr_seq = JFR::Translate::translate($rec->{'seq'},$rh_blast_frames->{$id});
        } elsif ($tr_seq !~ m/^[^\*]+.$/) {
            $tr_seq = get_seq_w_fewest_stops($rec->{'seq'});
        }
        print "$rec->{'def'}\n$tr_seq\n";
    }
}


sub get_blast_frames {
    my $blast = shift;
    my %frames = ();
    open IN, $blast or die "cannot open $blast:$!";
    while (my $line = <IN>) {
        next if ($line =~ m/^#/);
        chomp $line;
        my @data = split /\t/, $line;
        next if ($frames{$data[0]});
        $frames{$data[0]} = $data[1] % 3;
        $frames{$data[0]} = 3 if ($frames{$data[0]} == 0);
    } 
    return \%frames;
}

sub get_seq_w_fewest_stops {
    my $seq = shift;
    my $best_seq   = '';
    my $best_count = 0;
    my $best_frame = 0;
    foreach my $frame (1,2,3,-1,-2,-3) {
        my $tr_seq = JFR::Translate::translate($seq,$frame);
        my $count = () = $tr_seq =~ m/\*/g;
#print "$count -- $best_count -- $frame\n";
        if ($best_count == 0 || $count < $best_count) {
            $best_count = $count;
            $best_seq   = $tr_seq;
            $best_frame = $frame;
        }
    }
    return $best_seq;
}


sub usage {
    die "usage: $0 FASTA_FILE\n";
}

