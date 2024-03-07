#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

our $BO_ML_6348 = './get_final_set.out';
our $ML_DGE = './ML2.2.isoform.counts.matrix.MlCR_vs_MlST.voom.DE_results';
our $BO_DGE = './voom.18758.dir/Bova1.5.isoform.counts.matrix.BoCR_vs_BoST.voom.DE_results';


MAIN: {
    my $rh_6348 = get_6348($BO_ML_6348);
    my $rh_ml_dge = get_dge($ML_DGE);
    my $rh_bo_dge = get_dge($BO_DGE);
    print_table($rh_6348,$rh_ml_dge,$rh_bo_dge);
}

sub print_table {
    my $rh_6348 = shift;
    my $rh_ml_dge = shift;
    my $rh_bo_dge = shift;
    my %seen = ();
  
my @skipped = ();
    foreach my $id (keys %{$rh_6348}) {
        next unless ($id =~ m/^ML/);
        my $bid = $rh_6348->{$id};
        $bid =~ s/\.t\d+$//;
        next unless ($rh_ml_dge->{$id} && $rh_bo_dge->{$bid});
        my $hit = 0;
        $hit = 1 if ($rh_ml_dge->{$id}->[6] <= 0.001 &&
             ($rh_ml_dge->{$id}->[4] > 1) &&
             ($rh_ml_dge->{$id}->[3] <= -2 or $rh_ml_dge->{$id}->[3] >= 2));
        $hit = 1 if ($rh_bo_dge->{$bid}->[6] <= 0.001 &&
             ($rh_bo_dge->{$bid}->[4] > 1) &&
             ($rh_bo_dge->{$bid}->[3] <= -2 or $rh_bo_dge->{$bid}->[3] >= 2));
        next unless ($hit);
        print "$id,$rh_ml_dge->{$id}->[6],$rh_ml_dge->{$id}->[4],";
        print "$rh_ml_dge->{$id}->[3],$bid,$rh_bo_dge->{$bid}->[6],";
        print "$rh_bo_dge->{$bid}->[4],$rh_bo_dge->{$bid}->[3]\n";
    }
}

sub get_dge {
    my $file = shift;
    my %dge  = ();
    open IN, $file or die "cannot open $file:$!";
    my $headers = <IN>;
    while (my $line = <IN>) {
        chomp $line;
        my @fields = split /\t/, $line;
#        next unless ($fields[6] <= 0.001);
#        next unless ($fields[3] <= -2 or $fields[3] >= 2);
#        next unless ($fields[4] >= 1);
#        if ($fields[3] >= 2) {
#        } elsif ($fields[3] <= -2) {
        $dge{$fields[0]} = \@fields;
    }
    return \%dge;
}

sub get_6348 {
    my $file = shift;
    my %five488 = ();
    open IN, $file or die "cannot open $file:$!";
    while (my $line = <IN>) {
        chomp $line;
        my @fields = split /,/, $line;
        $five488{$fields[0]} = $fields[1];
        $five488{$fields[1]} = $fields[0];
    }
    return \%five488;
}

