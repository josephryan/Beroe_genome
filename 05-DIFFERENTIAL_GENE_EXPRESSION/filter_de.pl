#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

MAIN: {
    my $file = $ARGV[0] or die "usage: $0 DE_FILE PREFIX\n";
    my $pre  = $ARGV[1] or die "usage: $0 DE_FILE PREFIX\n";
    open IN, $file or die "cannot open $file:$!";
    my $headers = <IN>;
    open OUT1, ">$pre.logFC_2.txt" or die "cannot open $pre.logFC_2.txt:$!";
    open OUT2, ">$pre.logFC_-2.txt" or die "cannot open $pre.logFC_-2.txt:$!";
    while (my $line = <IN>) {
        chomp $line;
        my @fields = split /\t/, $line;
        next unless ($fields[6] <= 0.001);
        next unless ($fields[3] <= -2 or $fields[3] >= 2);
        next unless ($fields[4] >= 1);
        if ($fields[3] >= 2) {
            print OUT1 "$line\n";
        } elsif ($fields[3] <= -2) {
            print OUT2 "$line\n";
        } else {
            die "unexpected";
        }
    }
}
