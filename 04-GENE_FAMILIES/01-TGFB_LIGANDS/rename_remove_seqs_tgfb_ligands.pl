#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;

our $FILE = 'Bo_Hc_Pang.ligands.fa';
our %REMOVE = ('Bova1_5.0129.g9.t2' => 1,
               'Bova1_5.0137.g23.t2' => 1,
               'Bova1_5.0040.g35.t3' => 1,
               'Bova1_5.0002.g73.t2' => 1,
               'Bova1_5.0050.g20.t2' => 1,
               'Hcv1.av93.c12.g329.i2' => 1,
               'Hcv1.av93.c1.g1584.i2' => 1);
our %RENAME = ('Bova1_5.0040.g35.t2' => 'Bo_Bmp58',
               'Hcv1.av93.c12.g329.i1' => 'Hc_Bmp58',
               'Bova1_5.0137.g23.t1' => 'Bo_Tgf2',
               'Bova1_5.0129.g9.t1' => 'Bo_Tfg5',
               'Hcv1.av93.c12.g419.i1' => 'Hc_Tgf5',
               'Bova1_5.0186.g10.t1' => 'Bo_Tgf1',
               'Bova1_5.0045.g60.t1' => 'Bo_Bmp3',
               'Bova1_5.0118.g26.t1' => 'Bo_TGFbB',
               'Hcv1.av93.c1.g304.i1' => 'Hc_TGFbB',
               'Bova1_5.0002.g73.t1' => 'Bo_TGFbA',
               'Hcv1.av93.c1.g1584.i1' => 'Hc_TGFbA',
               'Bova1_5.0050.g20.t1' => 'Bo_Tgf4',
               'Hcv1.av93.c2.g1466.i1' => 'Hc_Tgf4',
               'Bova1_5.0104.g11.t1' => 'Bo_Tgf3',
               'Hcv1.av93.c9.g645.i1' => 'Hc_Tgf3',
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

