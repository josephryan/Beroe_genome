#!/usr/bin/perl

$|++;
use strict;
use warnings;
use JFR::GFF3;
use Storable qw(store retrieve);
use Data::Dumper;

our $VERSION = 0.05;

our $GFF = 'Bova1.4.gff';
our $BLASTN = 'Bova1.4.cds_v_cds.blastn';
our $BLASTP = 'Bova1.4.aa_v_aa.blastp';
our $BN_EVAL_CUT = 1e-50;
our $BP_EVAL_CUT = 1e-20;
our $IDENT_CUT = 90;
our $STORE_ISO     = 'storable.rh_iso';
our $STORE_UNITS   = 'storable.units';
our $VERBOSE       = 0;
our $STORE = 1; # set $STORE = 0, to run repeatedly after running once
                # running with $STORE=1 creates and stores variables 

MAIN: {
    generate_and_store_variables() if ($STORE);
    my ($rh_iso,$rh_units) = retrieve_vars();
    my $rh_new_names = get_new_names($rh_iso,$rh_units);
    foreach my $oldid (sort { by_scf() || by_gid() } keys %{$rh_new_names}) {
        print "$oldid,$rh_new_names->{$oldid}\n";
    }
}

sub remove_unit_redundancy {
    my $rh_u = shift;
    foreach my $key (keys %{$rh_u}) {
        my %seen = ();
        my @nr = ();
        foreach my $id (@{$rh_u->{$key}}) {
            next if ($seen{$id});
            next if ($id eq $key);
            push @nr, $id;
            $seen{$id}++;
        }

        if ($nr[0]) {
            $rh_u->{$key} = \@nr;
        } else {
            # delete units if they only pointed to themselves
            delete $rh_u->{$key};
        }
    }
}

# This is a complicated routine. 
# It builds hash of arrays which serves as an undirected graph
# Keys are the gene with the lowest gid. 
# Values are an array of all gids that are linked
# The arrays can contain redundancy. Rather than make more complex
#     redundancy is removed in a separate routine
sub get_units {
    my $rh_o   = shift;
    my $rh_bln = shift;
    my $rh_blp = shift;
    my %units  = ();
    my %seen   = ();

    foreach my $key (sort by_gid keys %{$rh_o}) {
        foreach my $val (sort by_gid keys %{$rh_o->{$key}}) {
            next unless ($rh_bln->{$key}->{$val});
            next unless ($rh_blp->{$key}->{$val});
            next if ($units{$val});
            if ($seen{$key}) {
                push @{$units{$seen{$key}}}, $val;
                $seen{$val} = $seen{$key} unless ($seen{$val});
            } elsif ($seen{$val}) {
                push @{$units{$seen{$val}}}, $key;
                $seen{$key} = $seen{$val} unless ($seen{$key});
            } else {
                push @{$units{$key}}, $val;
                $seen{$val} = $key;
            }
        }
    }
    return \%units;
}

sub retrieve_vars {
    my $rh_iso     = Storable::retrieve($STORE_ISO);
    my $rh_units   = Storable::retrieve($STORE_UNITS);
    return($rh_iso,$rh_units);
}

sub generate_and_store_variables {
    my $rh_bln       = get_blast($BLASTN,$BN_EVAL_CUT);
    my $rh_blp       = get_blast($BLASTP,$BP_EVAL_CUT);
    my $rh_iso      = get_isoforms($GFF);
    my $rh_over_pre = get_overlaps($GFF);
    my $rh_units    = get_units($rh_over_pre,$rh_bln,$rh_blp);
    remove_unit_redundancy($rh_units);
    Storable::store($rh_iso,$STORE_ISO);
    Storable::store($rh_units,$STORE_UNITS);
}

sub get_new_names {
    my $rh_iso   = shift;
    my $rh_units = shift;
    my %new      = ();

    foreach my $gid (sort by_gid keys %{$rh_iso}) {
        next unless ($rh_units->{$gid});
        foreach my $gid2change (sort by_gid @{$rh_units->{$gid}}) {
            foreach my $tid2change (sort by_tid @{$rh_iso->{$gid2change}}) {
                my $next_tid = get_next_tid($rh_iso->{$gid});
                $new{$tid2change} = $next_tid;
                push @{$rh_iso->{$gid}}, $next_tid;
            }
        }
    }
    return \%new;
}

# takes a an array of transcript ids and returns a transcript id with
#    an id that is the largest tid + 1
sub get_next_tid {
    my $ra_tids = shift;
    my @sorted_tids = sort by_tid @{$ra_tids};
    $sorted_tids[-1] =~ m/^(.*\.t)(\d+)$/ or die "unexpected: $sorted_tids[-1]";
    my $tid = $2 + 1; 
    my $full_tid = $1 . $tid;
    return $full_tid;
}

# sort routine that orders numerically by scaffold numbers
sub by_scf {
    my ($a_num) = $a =~ /\.(\d{4})\.g\d+/;
    my ($b_num) = $b =~ /\.(\d{4})\.g\d+/;
unless ($a && $b && $a_num && $b_num) { print "$a = $a_num\n"; print "$b = $b_num\n"; exit; }
    return $a_num <=> $b_num;
}

# sort routine that orders numerically by gene numbers (immediately after 'g')
sub by_gid {
    my ($a_num) = $a =~ /g(\d+)/;
    my ($b_num) = $b =~ /g(\d+)/;
unless ($a && $b && $a_num && $b_num) { print "$a = $a_num\n"; print "$b = $b_num\n"; exit; }
    return $a_num <=> $b_num;
}

# sort routine that orders numerically by transcript #s (immediately after 't')
sub by_tid {
    my ($a_num) = $a =~ /t(\d+)$/;
    my ($b_num) = $b =~ /t(\d+)$/;
unless ($a && $b && $a_num && $b_num) { print "$a = $a_num\n"; print "$b = $b_num\n"; exit;
}
    return $a_num <=> $b_num;
}

# build %iso with gene_ids as keys and transcript_id array_refs as values
sub get_isoforms {
    my $gff = shift;
    my %tmp = ();
    my %iso = ();
    open IN, $gff or die "cannot open $gff:$!";
    # first grab all the transcript ids and store in %tmp
    while (my $line = <IN>) {
        if ($line =~ m/transcript_id=([^=]+\.t\d+)/) {
            $tmp{$1}++;
        }
    }
    # build %iso from %tmp
    foreach my $ss (sort { by_gid() || by_tid() } keys %tmp) {
        $ss =~ m/(([^=]+\.g\d+)\.t\d+)/ or die "unexpected: $ss";
        push @{$iso{$2}}, $1;
    }
    return \%iso;
}

sub get_overlap_blast {
    my $rh_bln    = shift;
    my $rh_blp    = shift;
    my $rh_units = shift;
    my %obl = ();
    foreach my $key (keys %{$rh_units}) {
        foreach my $val (@{$rh_bln->{$key}}) {
            foreach my $val2 (@{$rh_units->{$key}}) {
                $obl{$key}->{$val}->{'bn'}++ if ($val eq $val2);
            }
        }
        foreach my $val (@{$rh_blp->{$key}}) {
            foreach my $val2 (@{$rh_units->{$key}}) {
                $obl{$key}->{$val}->{'bp'}++ if ($val eq $val2);
            }
        }
    }
    return \%obl;
}

sub get_blast {
    my $bl = shift;
    my $eval_cut = shift;
    my %hits = ();
    open IN, $bl or die "cannot open $bl:$!";
    my %seen = ();
    while (my $line = <IN>) {
        chomp $line;
        my @ff = split /\t/, $line;
        my $eval = $ff[10];
        my $ident = $ff[2];
        my $query = strip_isoform($ff[0]);
        my $subject = strip_isoform($ff[1]);
        next if ($query eq $subject);
        next unless ($eval <= $eval_cut);
        next unless ($ident >= $IDENT_CUT);
        next if ($seen{$query}->{$subject});
        $hits{$query}->{$subject}++;
#        push @{$hits{$query}}, $subject;
        $seen{$query}->{$subject}++;
    }
    return \%hits;
}


sub strip_isoform {
    my $id = shift;
    $id =~ m/(.*g\d+)\.t\d+$/ or die "unexpected: $id";
    return $1;
} 

sub get_overlaps {
    my $gff = shift;
    my $gp = JFR::GFF3->new($gff);
    my %seen = ();
    my %overlap = ();
    my %unexpected = ();
    while (my $rec = $gp->get_record()) {
        next unless ($rec->{'type'} eq 'exon');
        my $sid = $rec->{'seqid'};
        my $gid = $rec->{'attributes'}->{'gene_id'};
        for my $i ($rec->{'start'} .. $rec->{'end'}) {
            if ($seen{$sid}->[$i]) {
                $overlap{$seen{$sid}->[$i]}->{$gid}++;
                $overlap{$gid}->{$seen{$sid}->[$i]}++;
            } else {
                $seen{$sid}->[$i] = $gid;
            }
        }
    }
    return \%overlap;
}

