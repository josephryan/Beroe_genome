#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JFR::Fasta;

our $GFF       = 'out.gff';
our $NEW_GFF   = 'out2.gff';

MAIN: {
    my $ra_gff = get_gff($GFF);
    replace_gff($ra_gff,$GFF);
}

sub replace_gff {
    my $ra_gff = shift;
    my $out    = shift;
    my $rh_ids = shift;
    my %gnums  = ();
    open OUT, ">$NEW_GFF" or die "cannot open $NEW_GFF:$!";
    foreach my $line (@{$ra_gff}) {
        if ($line =~ m/^#/) {
            print OUT $line;
            next;
        }
        my @fields = split /\t/, $line;
        $gnums{$fields[0]}++ if ($fields[2] eq 'gene' && $fields[8] !~ m/transcript_id=Bova1_3\.\d+\.g\d+t[^1]\s*$/);
        if ($line =~ m/transcript_id=((Bova1_3\.\d+\.g\d+)\.t(\d+))\s*$/) {
            my $orig_tid = $1;
            my $orig_gid = $2;
            my $tid  = $3;
            my $gnum = $gnums{$fields[0]};
            my $new_gid = "$fields[0].g${gnum}";
            my $new_tid = "$new_gid.t${tid}";
            if ($fields[2] eq 'gene') {
                $line =~ s/ID=.*/ID=$new_gid;gene_id=$new_gid;transcript_id=$new_tid/; 
            } elsif ($fields[2] eq 'mRNA') {
                $line =~ m/ID=[^;]+\.t(\d+)/ or die "unexpected";
                $new_tid = "$new_gid.t${1}";
                $line =~ s/ID=.*/ID=$new_tid;Parent=$new_gid;gene_id=$new_gid;transcript_id=$new_tid/;
            } elsif ($fields[2] eq 'exon' || $fields[2] eq 'CDS' || $fields[2] eq 'start_codon' || $fields[2] eq 'stop_codon') {
                $line =~ s/Parent=.*/Parent=$new_tid;gene_id=$new_gid;transcript_id=$new_tid/;
            } else {
                die "unexpected: $line";
            } 
            print OUT $line;
        } elsif ($line =~ m/transcript_id=(Bova1_3\.\d+\.\d+)_t\s*$/) {
            my $orig = $1;
            my $tid  = 1;
            my $gnum = $gnums{$fields[0]};
            my $new_gid = "$fields[0].g${gnum}";
            my $new_tid = "$new_gid.t${tid}";
            if ($fields[2] eq 'gene') {
                $line =~ s/ID=.*/ID=$new_gid;gene_id=$new_gid;transcript_id=$new_tid/; 
            } elsif ($fields[2] eq 'mRNA') {
                $line =~ s/ID=.*/ID=$new_tid;Parent=$new_gid;gene_id=$new_gid;transcript_id=$new_tid/;
            } elsif ($fields[2] eq 'exon' || $fields[2] eq 'CDS' || $fields[2] eq 'start_codon' || $fields[2] eq 'stop_codon') {
                $line =~ s/Parent=.*/Parent=$new_tid;gene_id=$new_gid;transcript_id=$new_tid/;
            } else {
                die "unexpected: $line";
            } 
            print OUT $line;
        } else {
            die "unexpected line: $line";
        } 
    }
}

sub get_gff {
    my $gff = shift;
    my @lines = ();
    open IN, $gff or die "cannot open $gff:$!";
    while (my $line = <IN>) {
        chomp $line;
        my @fields = split /\t/, $line;
        $line =~ s/file_\d+_file_\d+_/$fields[0]./g;
        $line =~ s/Bova1_1/Bova1_3/g;
        push @lines, "$line\n";
    }
    close IN;
    return \@lines;
}
