#!/usr/bin/perl
use strict;
use warnings;
use JFR::Fasta;

our $FILE = 'make_subalignment.out';
our %REMOVE = ('Hcv1.av93.c1.g197.i1' => 1, 
               'Bova1_4.0314.g16.t1.1' => 1,
               'Bova1_4.0314.g16.t1.2' => 1,
               'Hcv1.av93.c10.g623.i1.2' => 1, 
               'Bova1_4.0001.g9.t1.2' => 1,
);
our %RENAME = ('Bova1_4.0001.g9.t1.1' => 'Bo_opsin2' ,
               'Hcv1.av93.c10.g623.i1.1' => 'Hc_opsin2' , 
               'Bova1_4.0020.g53.t1' => 'Bo_opsin1a' ,
               'Bova1_4.0020.g54.t1' => 'Bo_opsin1b' ,
               'Hcv1.av93.c8.g33.i1' => 'Hc_opsin1' ,
          );

MAIN: {
    my $fp = JFR::Fasta->new($FILE);
    while (my $rec = $fp->get_record()) {
        my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
        next if ($REMOVE{$id});
        if ($RENAME{$id}) {
            print ">$RENAME{$id}\n";
        } else {
            print "$rec->{'def'}\n";
        }
        print "$rec->{'seq'}\n";
    }
}
