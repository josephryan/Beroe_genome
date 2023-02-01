#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;

our @DIRS = qw(I1.5 I5 I8 I10);

MAIN: {
    my %bova_ids = ();
    my %conflicted = ();
    foreach my $dir (@DIRS) {
        my $ra_files = get_files($dir);
        get_one_to_ones($ra_files,\%bova_ids,\%conflicted);
    }
    my $ones = scalar(keys(%bova_ids));
    my $conflicts = scalar(keys(%conflicted));
    if ($conflicts) {
        print "one-to-ones: $ones ($conflicts conflicted)\n";
    } else {
        foreach my $id (keys %bova_ids) {
            print "$id,$bova_ids{$id}\n";
        }
    }
}

sub get_one_to_ones {
    my $ra_f = shift;
    my $rh_b = shift;
    my $rh_c = shift;
    foreach my $file (@{$ra_f}) {
        my $fp = JFR::Fasta->new($file);
        my $bova = $fp->get_record();
        my $mlei = $fp->get_record();
        my $bova_id = JFR::Fasta->get_def_w_o_gt($bova->{'def'});
        my $mlei_id = JFR::Fasta->get_def_w_o_gt($mlei->{'def'});
        die "unexpected: more than 2 seqs" if ($fp->get_record());
        die "unexpected: bova not first" unless ($bova_id =~ m/^Bova/);
        die "unexpected: mlei not second" unless ($mlei_id =~ m/^ML/);
        if ($rh_b->{$bova_id}) {
            next if ($rh_b->{$bova_id} eq $mlei_id);
            next if ($rh_c->{$bova_id});
            $rh_c->{$bova_id}++;
            delete $rh_b->{$bova_id};
        } else {
            $rh_b->{$bova_id} = $mlei_id;
        }
    }
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
