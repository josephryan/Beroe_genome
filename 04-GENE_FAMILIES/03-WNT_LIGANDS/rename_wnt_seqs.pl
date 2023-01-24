use strict;
use warnings;
use JFR::Fasta;

our $FILE = 'Bo_Hc_Pang.wnt.fa';
our %REMOVE = ();
our %RENAME = ('Bova1_4.0030.g66.t1' => 'Bo_WntA',
               'Bova1_4.0064.g51.t1' => 'Bo_WntX2' ,
               'Bova1_4.0064.g52.t1' => 'Bo_WntX1' ,
               'Hcv1.av93.c5.g1084.i1' => 'Hc_WntX' , 
               'Hcv1.av93.c5.g47.i1' => 'Hc_Wnt6', 
               'Bova1_4.0140.g20.t1' => 'Bo_Wnt6' , 
               'Bova1_4.0066.g65.t1' => 'Bo_Wnt9' , 
               'Hcv1.av93.c3.g1180.i1' => 'Hc_Wnt9', 
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
