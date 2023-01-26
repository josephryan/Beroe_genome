#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

our $ALN = $ARGV[0] or die "usage:$0 ALIGNMENT\n";

MAIN:{
    open IN, $ALN or die "cannot open $ALN:$!";
    while (my $line =<IN>){
	if ($line =~m/^>.*\s(NP.*)/){
            my $humid = $1;
	    $humid=~s/_/./;
	    print ">$humid\n";
        }elsif ($line =~m/^>.*\.(\d+)$/){
	    my $iso = $1;
	    my @id = split/\s/, $line;
	    print "$id[0].$iso\n";
        } elsif ($line =~m/^>.*/){
	    my @id = split/\s/, $line;
	    print "$id[0]\n";
	}else{
	    print "$line";
        }
    }    
}
