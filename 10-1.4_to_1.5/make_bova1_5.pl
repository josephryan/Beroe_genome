#!/usr/bin/perl

# need to edit gene search to automatically redirect old to new
# add links at top of all Bova1_4 genes to their new gene page
# change names in the web pages
# incorporate abram's changes???

$|++;

use strict;
use warnings; 
use JFR::Fasta;
use JFR::GFF3;
use Data::Dumper;

our $DATA = 'find_hidden_isoforms.out';
our %FASTA = ('Bova1.4.aa'  => 'Bova1.5.aa',
              'Bova1.4.cds' => 'Bova1.5.cds');
#our $GFF1_4 = 'Bova1.4.gff';
our $GFF1_4 = 'Bova1.4.gff';
our $GFF1_5 = 'Bova1.5.gff';

MAIN: {
    my $rh_iso = get_isoforms($DATA);
    foreach my $key (keys %FASTA) {
        update_fasta($rh_iso,$key,$FASTA{$key});
    }
    update_gff($rh_iso,$GFF1_4,$GFF1_5);
}

sub get_genes_to_remove {
    my $rh_iso = shift;
    my %g2r = ();
#print Dumper $rh_iso;
#exit;
    foreach my $key (keys %{$rh_iso}) {
        $key =~ m/(.*)\.t\d+$/ or die "unexpected: $key";
        $g2r{$1}++;
    }
    return \%g2r;
}

sub update_gff {
    my $rh_iso = shift;
    my $old    = shift;
    my $new    = shift;
    my $rh_g2r = get_genes_to_remove($rh_iso);
    open IN, $old or die "cannot open $old:$!";
    open OUT, ">$new" or die "cannot open >$new:$!";
    print OUT #gff-version 3
    my $gp = JFR::GFF3->new($old);
    while (my $rec = $gp->get_record()) {
        my $id     = $rec->{'attributes'}->{'ID'} || die "unexpected";
        my $gid    = $rec->{'attributes'}->{'gene_id'} || die "unexpected";
        my $type   = $rec->{'type'} || die "unexpected";
        next if ($rec->{'type'} eq 'gene' && $rh_g2r->{$gid});
        print OUT "$rec->{'seqid'}\tWhitneyLab\t$type\t";
        print OUT "$rec->{'start'}\t$rec->{'end'}\t$rec->{'score'}\t";
        print OUT "$rec->{'strand'}\t$rec->{'phase'}\t";
        if ($type eq 'gene') {
            $id = bova1_4_to_1_5($id);
            $gid = bova1_4_to_1_5($gid);
            print OUT "ID=$id;gene_id=$gid\n";
        } elsif ($type eq 'mRNA') {
            $id = $rh_iso->{$id} || $id;
            $id =~ m/(.*)\.t\d+/ or die "unexpected";
            $gid = $1;
            $id = bova1_4_to_1_5($id);
            $gid = bova1_4_to_1_5($gid);
            print OUT "ID=$id;Parent=$gid;gene_id=$gid;transcript_id=$id\n";
        } else {
            my $tid = $rec->{'attributes'}->{'transcript_id'} or die "unexpect";
            $tid = $rh_iso->{$tid} if ($rh_iso->{$tid}); 
            $tid =~ m/(.*)\.t\d+/ or die "unexpected";
            $gid = $1;
            $gid = bova1_4_to_1_5($gid);
            $tid = bova1_4_to_1_5($tid);
            print OUT "ID=$id;Parent=$gid;gene_id=$gid;transcript_id=$tid\n";
        }
    }
    close OUT;
}

sub bova1_4_to_1_5 {
    my $arg = shift;
    $arg =~ s/Bova1_4/Bova1_5/;
    return $arg;
}

sub update_fasta {
    my $rh_iso = shift;
    my $old    = shift;
    my $new    = shift;
    open OUT, ">$new" or die "cannot open >$new:$!";
    my $fp = JFR::Fasta->new($old);
    while (my $rec = $fp->get_record()) {
        my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
        my $new_def = "";
        if ($rh_iso->{$id}) {
            $new_def = ">$rh_iso->{$id}";
        } else {
            $new_def = "$rec->{'def'}";
        }
        $new_def =~ s/Bova1_4/Bova1_5/;
        print OUT "$new_def\n$rec->{'seq'}\n";
    }
}

sub get_isoforms {
    my $file = shift;
    my %iso  = ();
    open IN, $file or die "cannot open $file:$!";
    while (my $line = <IN>) {
        chomp $line;
        my @ff = split /,/, $line;
        $iso{$ff[0]} = $ff[1];
    }
    return \%iso;
}
