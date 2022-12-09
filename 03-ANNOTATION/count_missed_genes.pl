#!usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

our $VERSION = 0.02;

our $ORTHO = 'Orthogroups.tsv';

MAIN:{
    my %og_dict = ();
    my $count = 0;
    print "Orthogroups: B. ovata transcripts H. californensis gene models M. leidyi gene models\n";
    open IN, $ORTHO or die "cannot open $ORTHO:$!";
    my $header = <IN>;
    while (my $line = <IN>){
        chomp $line;
	my @og_ids = split/\t/, $line;
	$og_ids[1]=~tr/,//ds;
	$og_ids[3]=~tr/,//ds;
	$og_ids[4]=~tr/,//ds;
 	if ($og_ids[1] =~m/TRINITY/ && $og_ids[2] !~m/Bova1_1/ && $og_ids[3] =~m/^Hcv1\.av93/ && $og_ids[4] =~m/ML\d+a/){
            print "$og_ids[0] (complete): $og_ids[1] $og_ids[3] $og_ids[4]\n";
            $count++;
        } elsif ($og_ids[1] =~m/TRINITY/ && $og_ids[2] !~m/Bova1_1/ && $og_ids[3] =~m/^Hcv1\.av93/ && $og_ids[4] !~m/ML\d+a/){
            print "$og_ids[0] (No ML): $og_ids[1] $og_ids[3]\n";
            $count++;
        } elsif ($og_ids[1] =~m/TRINITY/ && $og_ids[2] !~m/Bova1_1/ && $og_ids[3] !~m/^Hcv1\.av93/ && $og_ids[4] =~m/ML\d+a/){
            print "$og_ids[0] (No HC): $og_ids[1] $og_ids[4]\n";
            $count++;
	}	
    }
    print "Total candidate missed gene predictions: $count\n";
}
