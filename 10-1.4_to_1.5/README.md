```bash
gzip -dc Bova1.4.*

makeblastdb -dbtype prot -in Bova1.4.aa

makeblastdb -dbtype nucl -in Bova1.4.cds

blastn -num_threads 40 -db Bova1.4.cds -query Bova1.4.cds -outfmt 6 > Bova1.4.cds_v_cds.blastn

blastp -num_threads 200 -db Bova1.4.aa -query Bova1.4.aa -outfmt 6 > Bova1.4.aa_v_aa.blastp

# identify isoforms that were originally given separate gene status
perl find_hidden_isoforms.pl > find_hidden_isoforms.out

# update FASTA and GFF files (creates Bova1_5.aa, Bova1_5.cds, Bova1_5.gff)
perl make_bova1_5.pl
```
