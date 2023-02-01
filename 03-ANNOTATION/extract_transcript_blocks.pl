#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(max);

our $VERSION = 0.06;
our $COUNTER = 9800;
our $EXON_COUNT = '150540';
our $CDS_COUNT  = '150540';
our $ZZZ = 'ZZZ';  # this is used for a later replacement 

our $MISSED = 'confirm_missed.out';
our $GFF_1_3 = 'Bova1.3.gff';

MAIN:{
    my $ra_dir = get_dirs();
    my $rh_dat = get_data($ra_dir);
    my $rh_gff = get_gff($GFF_1_3);
    print_gff($rh_gff,$rh_dat);
}

sub print_gff {
    my $rh_gff = shift;
    my $rh_dat = shift;
    print "#gff-version 3\n";
    foreach my $scf (sort { substr($a,8,4) <=> substr($b,8,4) } keys %{$rh_gff}) {
        if ($rh_dat->{$scf}) {
            my $ra_start_coords = get_start_coords($rh_dat->{$scf});
            my @s = sort(@{$ra_start_coords}); # just in case
            my $j = 0;
	    my $last = 0;
            for (my $i = 0; $i < @{$rh_gff->{$scf}}; $i++) {
                my $gff_start = $rh_gff->{$scf}->[$i]->[0]->[3];
                if ($s[0] && $s[0] < $gff_start) {
                    print_gene_in_gff($rh_dat->{$scf}->[$j],$last);
                    shift @s;
                    $j++;
		    $last += 0.1;
                } else {
		    $rh_gff->{$scf}->[$i]->[0]->[8] =~ m/ID=[^\.]+\.\d+.g(\d+);/;
		    $last = $1;
                    $last = $last + 0.1;
                }
                print_gene_in_gff($rh_gff->{$scf}->[$i]);
            }                    
            if (@s) {  # if new gene is at end of scaffold
                for (my $k = 0; $k < @s; $k++) {
                    my $index = $j + $k;
                    print_gene_in_gff($rh_dat->{$scf}->[$index],$last);
                }
            }
        } else {
            for (my $i = 0; $i < @{$rh_gff->{$scf}}; $i++) {
                print_gene_in_gff($rh_gff->{$scf}->[$i]);
            }
        }
    }
}

sub print_gene_in_gff {
    my $ra_gene = shift;
    my $last    = shift;
    my $num = scalar(@{$ra_gene->[0]});
    if ($num == 2) {  # from $rh_dat
        my $ra_coords = shift @{$ra_gene};
        foreach my $line (@{$ra_gene}) { 
            $line =~ s/$ZZZ/$last/g;
            print "$line\n";
        }
    } else {  # from $rh_gff
        foreach my $ra_entry (@{$ra_gene}) {
            my $line = join "\t", @{$ra_entry};
            print "$line\n";
        }
    }
}

sub get_start_coords {
    my $ra_rec = shift;
    my @coords = ();
    foreach my $ra_r (@{$ra_rec}) {
        push @coords, $ra_r->[0]->[0];
    }
    return \@coords;
}

sub get_gff {
    my $gff = shift;
    my %dat = ();
    open IN, $gff or die "cannot open $gff:$!";
    my %gid = ();
    while (my $line = <IN>) {
        next if ($line =~ m/^#/); 
        chomp $line;
        my @f = split /\t/, $line;
        if ($f[2] eq 'gene') {
            $gid{$f[0]}++;
            $dat{$f[0]}->[$gid{$f[0]} - 1] = [\@f];
        } else {
            push @{$dat{$f[0]}->[$gid{$f[0]} - 1]}, \@f;
        }
    }
    return \%dat;
}

sub get_data {
    my $ra_dir = shift;
    my %data   = ();
    foreach my $path (@{$ra_dir}){
        $path =~ m/\d+-(OG\d+)/ or die "unexpected";
        my $ogid = $1;
        opendir DIR, $path or die "cannot opendir $path:$!";
        my @files = grep { /.*.min.txt/ } readdir(DIR);
        die "unexpected" unless (scalar(@files) == 1);
        die "unexpected" unless ($files[0] =~ m/(.*).min.txt$/);
        my $bova = $1;
        my $offset = get_offset("$path/$files[0]");
        find_gene_blocks($bova,$offset,\%data,$path);
    }
    return \%data;
}

sub get_offset {
    my $file = shift;
    open IN, $file or die "cannot open $file:$!";
    my $offset = <IN>;
    chomp $offset;
    return $offset;
}

sub find_gene_blocks{
    my $bova = shift;
    my $offset = shift;
    my $rh_data = shift;
    my $dir     = shift;

    return '' unless ($bova);
    open IN, "$dir/$bova.augustus.out" or die "cannot open $dir/$bova.augustus.out:$!";
    my @gene = ();
    my $gene_count = 0;
    $COUNTER++;
    while (my $line = <IN>){
        chomp $line;
        next if ($line =~m/^#/);
        my @f = split/\t/, $line;
        next if ($f[1] eq 'b2h');
        $f[3] += $offset;
        $f[4] += $offset;
        fix_last_column(\@f,$COUNTER);
        my $line = join "\t", @f;
        push @gene, $line unless ($f[2] eq 'intron' || $f[2] eq 'transcript');
        $gene_count++ if ($f[2] eq 'gene');
        unshift @gene, [$f[3],$f[4]] if ($f[2] eq 'gene');
    }
    push @{$rh_data->{$bova}}, \@gene if ($gene_count == 1);
}

sub fix_last_column {
    my $ra_f = shift;
    my $count = shift;
    my $scf   = $ra_f->[0];
    if ($ra_f->[2] eq 'gene') {
        $ra_f->[8] = "ID=${scf}.g$ZZZ;gene_id=${scf}.g$ZZZ;transcript_id=${scf}.g$ZZZ.t1"; 
    } elsif ($ra_f->[2] eq 'mRNA') {
        $ra_f->[8] = "ID=${scf}.g$ZZZ.t1;Parent=${scf}.g$ZZZ;gene_id=${scf}.g$ZZZ;transcript_id=${scf}.g$ZZZ.t1"; 
    } elsif ($ra_f->[2] eq 'exon') {
        $ra_f->[8] = "ID=exon-${EXON_COUNT};Parent=${scf}.g$ZZZ.t1;gene_id=${scf}.g$ZZZ;transcript_id=${scf}.g$ZZZ.t1";
        $EXON_COUNT++;
    } elsif ($ra_f->[2] eq 'CDS') {
        $ra_f->[8] = "ID=cds-${CDS_COUNT};Parent=${scf}.g$ZZZ.t1;gene_id=${scf}.g$ZZZ;transcript_id=${scf}.g$ZZZ.t1";
        $CDS_COUNT++;
    } elsif ($ra_f->[2] eq 'start_codon') {
        $ra_f->[8] = "ID=start_codon-$count;Parent=${scf}.g$ZZZ.t1;gene_id=${scf}.g$ZZZ;transcript_id=${scf}.g$ZZZ.t1";
    } elsif ($ra_f->[2] eq 'stop_codon') {
        $ra_f->[8] = "ID=stop_codon-$ZZZ;Parent=${scf}.g$ZZZ.t1;gene_id=${scf}.g$ZZZ;transcript_id=${scf}.g$ZZZ.t1";
    }
}

sub get_dirs{
    my @dirs = ();
    open IN, $MISSED or die "cannot open file: $MISSED:$!";
    my $header = <IN>;
    my $header2 = <IN>;
    while (my $line = <IN>){
	chomp $line;
        if ($line =~m/\d+-OG\d+$/){
            push @dirs, $line;
	}
    }
    return \@dirs;
}
