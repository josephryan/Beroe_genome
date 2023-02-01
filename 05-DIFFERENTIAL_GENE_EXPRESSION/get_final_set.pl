#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;
use Data::Dumper;

our @FILES = qw(I1.5.pairs.txt print_isoforms_blocking_one_to_ones.out print_total-1_to_1s.out);

# The following were added based on detailed phylogenetic analyses
# Detailed analyses confirmed 8 other 1-to-1 orthologs
our %LANA_ADDITIONS = ('Bova1_4.0020.g50.t1' => 'ML08593b',
                       'Bova1_4.0045.g60.t1' => 'ML368915a');

our $ML_NT = '/bwdata2/jfryan/00-DATA/ML2.2.nt';
our $BO_NT = '/bwdata2/jfryan/00-DATA/Bova1.4.cds';

our $OUTFILE = 'get_final_set.out';
our $OUT_BOCDS = 'Bo_5488.cds';
our $OUT_MLCDS = 'Ml_5488.cds';

MAIN: {
    my ($rh_b2m,$rh_conflict) = get_b2m();
    my $rh_ml = get_seqs($ML_NT);
    my $rh_bo = get_seqs($BO_NT);
    write_out_files($rh_b2m,$rh_conflict,$rh_ml,$rh_bo);
}

sub write_out_files {
    my $rh_b2m = shift;
    my $rh_con = shift;
    my $rh_ml  = shift;
    my $rh_bo  = shift;
    open OUTML, ">$OUT_MLCDS" or die "cannot open $OUT_MLCDS:$!";
    open OUTBO, ">$OUT_BOCDS" or die "cannot open $OUT_BOCDS:$!";
    foreach my $bo (keys %{$rh_b2m}) {
        my $ml = $rh_b2m->{$bo};
        next if ($rh_con->{$bo} || $rh_con->{$ml});
        print OUTML ">$ml\n$rh_ml->{$ml}\n";
        $bo .= '.t1' unless ($bo =~ m/\.t\d+$/);
        print OUTBO ">$ml\n$rh_bo->{$bo}\n";
    } 
}

sub get_seqs {
    my $fa = shift;
    my %data = ();
    my $fp = JFR::Fasta->new($fa);
    while (my $rec = $fp->get_record()) {
        my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
        $data{$id} = $rec->{'seq'};
    }
    return \%data;
}

sub get_b2m {
    my %b2m = ();
    my %m2b = ();
    my %conflict = ();
    foreach my $f (@FILES) {
        open IN, $f or die "cannot open $f:$!";
        while (my $line = <IN>) {
            chomp $line;
            my @fields = split /,/, $line;
            if ($b2m{$fields[0]} || $m2b{$fields[1]}) {
                $conflict{$fields[0]}++;
                $conflict{$fields[1]}++;
            } 
            $b2m{$fields[0]} = $fields[1];
            $m2b{$fields[1]} = $fields[0];
        }
    }
    open OUT, ">$OUTFILE" or die "cannot open $OUTFILE:$!";
    foreach my $key (keys %b2m) {
        next if ($conflict{$key} || $conflict{$b2m{$key}});
        print OUT "$key,$b2m{$key}\n";
    }
    foreach my $bid (keys %LANA_ADDITIONS) {
        $b2m{$bid} = $LANA_ADDITIONS{$bid};
        print OUT "$bid,$LANA_ADDITIONS{$bid}\n";
    }
    return \%b2m,\%conflict;
}
