#!/usr/bin/perl
use strict;
use warnings;
use JFR::Fasta;

our $FILE = 'make_subalignment.out';
our %REMOVE = ('Hcv1.av93.c2.g1312.i1' => 1,
               'Hcv1.av93.c2.g1312.i2' => 1,
               'Hcv1.av93.c2.g1312.i3' => 1,
               'Hcv1.av93.c2.g1312.i5' => 1,
               'Hcv1.av93.c2.g1312.i6' => 1,
               'Bova1_5.0012.g54.t2' => 1,
               'Hcv1.av93.c1.g1342.i3.1' => 1,
               'Bova1_5.0015.g107.t1.2' => 1,
               'Bova1_5.2186.g1.t1' => 1,
               'Bova1_5.1086.g1.t1' => 1,
               'Hcv1.av93.c5.g287.i1' => 1,
               'Hcv1.av93.c5.g362.i1' => 1,
               'Hcv1.av93.c5.g617.i1' => 1, 
               'Bova1_5.0008.g58.t1' => 1,
               'Bova1_5.1771.g1.t1' => 1,
               'Hcv1.av93.c6.g724.i1' => 1, 
               'Hcv1.av93.c11.g521.i1' => 1, 
               'Bova1_5.0015.g107.t1.1' => 1, 
               'Hcv1.av93.c1.g1310.i1' => 1, 
               'Hcv1.av93.c7.g270.i1' => 1,
               'Bova1_5.0164.g10.t1' => 1 ,
               'Hcv1.av93.c4.g664.i1' => 1 ,
	       'Hcv1.av93.c2.g266.i2' => 1,
	       'Hcv1.av93.c2.g204.i1' => 1,
	       'Bova1_5.0186.g11.t1' => 1,
               'Bova1_5.0033.g71.t2' => 1,
	       'Hcv1.av93.c2.g1492.i2' => 1,
	       'Hcv1.av93.c2.g1492.i3.1' => 1,
	       'Hcv1.av93.c2.g1494.i3.3' => 1,
	       'Hcv1.av93.c2.g266.i1' => 1,
	       'Bova1_5.0026.g77.t1.2' => 1,
	       'Hcv1.av93.c7.g66.i1.1' => 1,
	       'Bova1_5.0203.g7.t1.1' => 1,
	       'Hcv1.av93.c1.g313.i1.1' => 1,
	       'Hcv1.av93.c3.g1093.i1.1' => 1,
	       'Hcv1.av93.c2.g1492.i1.1' => 1,
	       'Hcv1.av93.c2.g1494.i1.2' => 1,
 );
our %RENAME = ('Hcv1.av93.c2.g1312.i4' => 'Hc_TgfRIa',
               'Bova1_5.0012.g54.t1' => 'Bo_TgfRIa',
               'Bova1_5.0033.g71.t1' => 'Bo_TgfRIb',
               'Hcv1.av93.c3.g1093.i1.2' => 'Hc_TgfRIb',
               'Hcv1.av93.c1.g126.i1' => 'Hc_TgfRIc',
               'Bova1_5.0264.g10.t1' => 'Bo_TgfRIc',
               'Bova1_5.0255.g1.t1' => 'Bo_TgfRII2',
               'Bova1_5.0020.g49.t2' => 'Bo_TgfRII1',
               'Hcv1.av93.c8.g267.i1' => 'Hc_TgfRII1',
               'Hcv1.av93.c2.g938.i1' => 'Hc_TgfRII2', 
               'Hsa_BMPr1B' => 'Hsa_BMPR1B', 
               'Hsa_TGFbr1' => 'Hsa_TGFBR1', 
               'Hsa_Actr1' =>  'Hsa_ACTR1' ,
               'Hsa_Actr2' =>  'Hsa_ACTR2' , 
               'Hsa_BMPr2' =>  'Hsa_BMPR2' , 
               'Hsa_TGFbr2' => 'Hsa_TGFBR2' , 
               'Ml_TypeIa' =>  'Ml_TgfRIa' , 
               'Ml_TypeIb' =>  'Ml_TgfRIb' , 
               'Ml_TypeIc' =>  'Ml_TgfRIc' , 
               'Ml_TypeIIR' => 'Ml_TgfRII' ,
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

