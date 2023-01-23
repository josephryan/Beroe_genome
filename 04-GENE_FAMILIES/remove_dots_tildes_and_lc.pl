use warnings;
use JFR::Fasta;
use Data::Dumper;

MAIN: {
    my $file = $ARGV[0] or die "usage: $0 FASTA_FILE\n";
    my $fp = JFR::Fasta->new($file);
    my $first_seq = 1;
    my $ra_pos = [];
    while (my $rec = $fp->get_record()) {
        my $seq = $rec->{'seq'};
        $ra_pos = get_dot_positions($seq) if ($first_seq);
        $first_seq = 0;
        if ($seq =~ m/\~/) {
            $seq = remove_tildes($seq,$ra_pos);
        }
        $seq =~ s/\.//g;
        $seq =~ s/[a-z]//g;
        print "$rec->{'def'}\n$seq\n";
    }
}

sub remove_tildes {
     my $seq = shift;
     my $ra_dots = shift;
     my $new_seq = '';

     my @letters = split //, $seq;
     for (my $i = 0; $i < @letters; $i++) {
         if ($letters[$i] eq '~' && $ra_dots->[$i]) {
             $new_seq .= '.';
         } elsif ($letters[$i] eq '~' && !$ra_dots->[$i]) {
             $new_seq .= '-';
         } else {
             $new_seq .= $letters[$i];
         }
     }
     return $new_seq;
}

sub get_dot_positions {
    my $seq = shift;
    my @dots = ();
    my @letters = split //, $seq;
    for (my $i = 0; $i < @letters; $i++) {
        if ($letters[$i] eq '~') {
            die "first sequence cannot have a tilde. please reorder\n";
        } elsif ($letters[$i] eq '.') {
            $dots[$i] = 1;
        } else {
            $dots[$i] = 0;
        }
    }
    return \@dots;
}
