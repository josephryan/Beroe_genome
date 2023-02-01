#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;
use Data::Dumper;

our @DIRS = qw(I1.5.multi I5.multi I8.multi I10.multi);

MAIN: {
    my %bo = ();
    my %conflicted = ();
    foreach my $dir (@DIRS) {
        my $ra_files = get_files($dir);
        my $ra_f = identify_isoform_blockers($ra_files,\%bo,\%conflicted);
#        print "$dir\n";
    }
    my $ones = scalar(keys(%bo));
    my $conflicts = scalar(keys(%conflicted));
    if ($conflicts) {
        print "one-to-ones: $ones ($conflicts conflicted)\n";
    } else {
        foreach my $id (keys %bo) {
            print "$id,$bo{$id}\n";
        }
    }
}

sub identify_isoform_blockers {
    my $ra_f = shift;
    my $rh_b = shift;
    my $rh_c = shift;

    foreach my $file (@{$ra_f}) {
        my $fp = JFR::Fasta->new($file);
        my %ml = ();
        my %bo = ();
        my $count = 0;
        while (my $rec = $fp->get_record()) {
            $count++;
            my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
            if ($id =~ m/(Bova1_4\.\d+\.g\d+)\.t\d+$/) {
                $bo{$1}++;
            } elsif ($id =~ m/^(ML\d+[a-z])$/) {
                $ml{$1}++;
            } else {
                die "unexpected ID: $id\n";
            }
        }
        next if ($count == 2);
        my $ml_num = scalar(keys(%ml)) || 0;
        my $bo_num = scalar(keys(%bo)) || 0;
        next unless ($ml_num == 1 && $bo_num == 1);
        my @bova_ids = keys %bo;
        my @mlei_ids = keys %ml;
        my $bova_id = $bova_ids[0];
        my $mlei_id = $mlei_ids[0];
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
