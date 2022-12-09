# COMMANDS USED TO ANNOTATE BEROE GENOME

### Update assembly definition lines
```
replace_deflines.pl --fasta=scaffolds.reduced.fa --prefix=Bova1.0 --pad=4 > Bova_scf_5k_gaps_removed_redundans.fa
```
scaffolds.reduced.fa is the final genome assembly file

### Sort sequences by size
```
sort_fasta_by_size.pl Bova_scf_5k_gaps_removed_redundans.fa > Bova_scf_5k_gaps_removed_redundans_sorted.fa
```

### Update definition lines after sorting
```
replace_deflines.pl --fasta=Bova_scf_5k_gaps_removed_redundans_sorted.fa --prefix=Bova1_1 --pad=4 > Bova1.1.fa
```

### Align unassembled transcripts to genome assembly
```
STAR --runThreadN 45 --runMode genomeGenerate --genomeFastaFiles Bova1.1.fa
STAR --runThreadN 45 --genomeDir GenomeDir/ --readFilesIn B10H-3_S4_L001_R1_001.fastq,B10H-3_S4_L002_R1_001.fastq,B10H-3_S4_L003_R1_001.fastq,B10H-3_S4_L004_R1_001.fastq,Be0H-1_S1_L001_R1_001.fastq,Be0H-1_S1_L002_R1_001.fastq,Be0H-1_S1_L003_R1_001.fastq,Be0H-1_S1_L004_R1_001.fastq,Be20H-4_S5_L001_R1_001.fastq,Be20H-4_S5_L002_R1_001.fastq,Be20H-4_S5_L003_R1_001.fastq,Be20H-4_S5_L004_R1_001.fastq,Be6H-2_S3_L001_R1_001.fastq,Be6H-2_S3_L002_R1_001.fastq,Be6H-2_S3_L003_R1_001.fastq,Be6H-2_S3_L004_R1_001.fastq,BeJ-5_S6_L001_R1_001.fastq,BeJ-5_S6_L002_R1_001.fastq,BeJ-5_S6_L003_R1_001.fastq,BeJ-5_S6_L004_R1_001.fastq B10H-3_S4_L001_R2_001.fastq,B10H-3_S4_L002_R2_001.fastq,B10H-3_S4_L003_R2_001.fastq,B10H-3_S4_L004_R2_001.fastq,Be0H-1_S1_L001_R2_001.fastq,Be0H-1_S1_L002_R2_001.fastq,Be0H-1_S1_L003_R2_001.fastq,Be0H-1_S1_L004_R2_001.fastq,Be20H-4_S5_L001_R2_001.fastq,Be20H-4_S5_L002_R2_001.fastq,Be20H-4_S5_L003_R2_001.fastq,Be20H-4_S5_L004_R2_001.fastq,Be6H-2_S3_L001_R2_001.fastq,Be6H-2_S3_L002_R2_001.fastq,Be6H-2_S3_L003_R2_001.fastq,Be6H-2_S3_L004_R2_001.fastq,BeJ-5_S6_L001_R2_001.fastq,BeJ-5_S6_L002_R2_001.fastq,BeJ-5_S6_L003_R2_001.fastq,BeJ-5_S6_L004_R2_001.fastq > STAR.out 2> STAR.err &
```

### Sort and convert alignments to BAM
```
samtools view --threads 250 -S -b Aligned.out.sam > raw_rnaseq_v_Bova1.1.bam
samtools sort --threads 250 -n -o raw_rnaseq_v_Bova1.1.sorted.bam raw_rnaseq_v_Bova1.1.bam > st.sort.out 2> st.sort.err &
```

### Run braker for gene predictions
```
braker.pl --genome=Bova1.1.fa --useexisting --species=human --bam=raw_rnaseq_v_Bova1.1.sorted.bam --AUGUSTUS_CONFIG_PATH=$PWD/aug_config --AUGUSTUS_BIN_PATH=/usr/local/augustus-3.4.0/bin/ --AUGUSTUS_SCRIPTS_PATH=/usr/local/augustus-3.4.0/scripts > braker.out 2> braker.err
```

### Annotate genes
```
/usr/local/augustus-3.4.0/scripts/gtf2gff.pl <braker.gtf --out=braker.gff
/usr/local/augustus-3.4.0/scripts/gffGetmRNA.pl --genome=../Bova1.1.fa --mrna=braker.cds
/usr/local/augustus-3.4.0/scripts/getAnnoFasta.pl braker.gff --seqfile=../Bova1.1.fa
```

### Standardize and sort braker GFF file
```
agat_convert_sp_gxf2gxf.pl --gff braker.gff -o out.gff
```

# COMMANDS TO REANNOTATE ASSEMBLY AND INCORPORATE MISSED GENE PREDICTIONS
The mitochondrial genome was removed for the Bova1.2 version of the assembly. We are renaming the assembly and annotations Bova1.3 for reannotation below.

### Produce a new GFF with appropriate gene names
```
perl finalize_gff_names.pl
```
Output is out2.gff

### Check gene models for internal stops 
```
/usr/local/augustus-3.3.4/scripts/getAnnoFasta.pl out2.gff --seqfile=Bova1.3.fa
blastx -num_threads 40 -db uniprot_sprot.fasta -query out2.mrna -evalue 0.001 -outfmt "7 qacc qstart" > tmp3.blastx
perl translate_cds.pl out2.mrna > tmp.aa
perl identify_seqs_w_stops.pl tmp.aa > tmp2.aa
blastp -num_threads 40 -db uniprot_sprot.fasta -query tmp2.aa -evalue 0.001 > tmp2.aa_v_uniprot.blastp
```
### Identify missed gene predictions

OrthoFinder analysis was performed using Bova1.3 protein models (Bova1.3.aa), *B. ovata* transcripts collected at 20 hours post fertilization (ENA accession ERR2205121), *Hormiphora californensis* protein models (Hcv1av93_model_proteins.pep), and *Mnemiopsis leidyi* protein models (ML2.2.aa)
```
orthofinder -t 18 -f 05-MISSED_PREDICTIONS > of.missed.out 2> of.missed.err &
perl count_missed_genes.pl > missed_gene_predictions.out
```
This script produces an output file that lists OrthoFinder orthogroups containing *B. ovata* transcripts but lacking *B. ovata* gene predictions. Orthogroups are broken into the following categories:
* complete - orthogroup contains protein models from *H. californensis* and *M. leidyi* and *B. ovata* transcripts
* No ML - orthogroup only contains protein models from *H. californensis* and *B. ovata* transcripts
* No HC - orthogroup only contains protein models from *M. leidyi* and *B. ovata* transcripts

### Confirm missed gene predictions
```
diamond makedb --in B20H.trinity.Trinity.fasta --db B20H.trinity.Trinity.fasta
diamond makedb --in Hcv1av93_ML2.2.fa --db Hcv1av93_ML2.2.fa
diamond makedb --in Bova1.3.aa --db Bova1.3.aa
perl confirm_missed_predictions.pl > confirm_missed.out 
```
### Produce GFF with missing predictions
```
perl extract_transcript_blocks.pl > extract_transcript_blocks.out
```

### Reannotate genes using new GFF
```
/usr/local/augustus-3.3.4/scripts/getAnnoFasta.pl extract_transcript_blocks.out --seqfile=Bova1.3.fa
perl finalize_gff_names.pl extract_transcript_blocks.out > Bova1.4.gff
perl -pi -e 's/Bova1_3/Bova1_4/g' Bova1.4.gff
gffread -V -H -x Bova1.4.cds -y Bova1.4.aa -g Bova1.4.fa -E Bova1.4.gff 2> Bova1.4.gff.warnings > Bova1.4.gff.gffread
```
