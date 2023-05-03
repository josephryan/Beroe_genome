# COMMANDS USED TO ASSEMBLE BEROE TRANSCRIPTOME AT 20 HOURS POST-FERTILIZATION

Raw reads for 20 hours post-fertilization can be found in the European Nucleotide Archive under accession numbers [ERR2205104](https://www.ebi.ac.uk/ena/browser/view/ERR2205104) and [ERR2205105](https://www.ebi.ac.uk/ena/browser/view/ERR2205105)

### Trim adapters with [biolite](https://bitbucket.org/caseywdunn/biolite/src/master/) (no longer supported)

```
bl-filter-illumina -a -i B20H_R1.fq -i B20H_R2.fq -o B20H_R1_trimmed.fq -o B20H_R2_trimmed.fq -u B20H_unpaired_trimmed.fq > bfi_B20.out 2> bfi_B20H.err
```

### Concatenate unpaired to paired reads
```
cat B20H_R1_trimmed.fq B20H_unpaired_trimmed.fq > B20H_R1up.fq
```

### Run Trinity 
```
/usr/local/trinityrnaseq-Trinity-v2.4.0/Trinity --seqType fq --max_memory 750G --CPU 12 --left B20H_R1up.fq --right B20H_R2_trimmed.fq --full_cleanup --normalize_reads --normalize_max_read_cov 30 > trin_20.out 2> trin_20.err
``` 

### Identify isoforms with the most reads aligned reads
```
/usr/local/trinityrnaseq-Trinity-v2.4.0/util/align_and_estimate_abundance.pl --transcripts trinity_out_dir.Trinity.fasta --seqType fq --left B20H_R1_trimmed.fq --right B20H_R2_trimmed.fq --output_dir aea --est_method RSEM --aln_method bowtie2 --thread_count 78 --prep_reference > aea.out 2> aea.err
rsemgetbestseqs.py ./aea/RSEM.isoforms.results trinity_out_dir.Trinity.fasta > rgbs.out 2> rgbs.err
```

### Update assembly definition lines
```
replace_deflines.pl --trinity2 --pad=6 --fasta=RSEM.isoforms.results.best.fa --prefix=Bero_ovat_20H > Bero_ovat_20H_trans_v1.fa
```
