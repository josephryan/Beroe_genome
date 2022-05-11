# COMMANDS USED TO ASSEMBLE BEROE GENOME

## PLATANUS ASSEMBLIES OF SHORT READS (varied paramater: k (32,45,63))

#### Trim adapters with TrimmomaticPE

```
java -jar trimmomatic-0.36.jar -threads 170 BeDNA-6_S2_L003_R1_001.fastq BeDNA-6_S2_L003_R2_001.fastq BeDNA-6_S2_L003_R1_trimmed.fq BeDNA-6_S2_L003_R1_unp_trimmed.fq BeDNA-6_S2_L003_R2_trimmed.fq BeDNA-6_S2_L003_R2_unp_trimmed.fq ILLUMINACLIP:/usr/local/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```

#### Correct sequence errors with ErrorCorrectReads (from AllPathsLG software)

```
/usr/local/allpathslg-44837/src/ErrorCorrectReads.pl PAIRED_READS_A_IN=BeDNA-6_S2_L003_R1_trimmed.fq PAIRED_READS_B_IN=BeDNA-6_S2_L003_R2_trimmed.fq PAIRED_SEP=350 THREADS=46 PHRED_ENCODING=33 READS_OUT=BeDNA-6_S2_L003_trimmed_ecr
```

#### PLAT31

```
plat.pl --out=plat31 --k=31 --threads=45 --m=700 --left=BeDNA-6_S2_L003_trimmed_ecr.paired.A.fastq --right=BeDNA-6_S2_L003_trimmed_ecr.paired.B.fastq --unp=BeDNA-6_S2_L003_trimmed_ecr.unpaired.fastq > ecr.out 2> ecr.err &
```

#### PLAT45

```
plat.pl --out=plat45 --k=45 --threads=45 --m=700 --left=/bwdata1/mdebiasse/02-BEROE_OVATA/08-LAST_DITCH_EFFORT/03-ECR/BeDNA-6_S2_L003_trimmed_ecr.paired.A.fastq --right=/bwdata1/mdebiasse/02-BEROE_OVATA/08-LAST_DITCH_EFFORT/03-ECR/BeDNA-6_S2_L003_trimmed_ecr.paired.B.fastq --unp=/bwdata1/mdebiasse/02-BEROE_OVATA/08-LAST_DITCH_EFFORT/03-ECR/BeDNA-6_S2_L003_trimmed_ecr.unpaired.fastq > ecr.out 2> ecr.err &
```

#### PLAT63

```
plat.pl --out=plat63 --k=63 --threads=45 --m=700 --left=/bwdata1/mdebiasse/02-BEROE_OVATA/08-LAST_DITCH_EFFORT/03-ECR/BeDNA-6_S2_L003_trimmed_ecr.paired.A.fastq --right=/bwdata1/mdebiasse/02-BEROE_OVATA/08-LAST_DITCH_EFFORT/03-ECR/BeDNA-6_S2_L003_trimmed_ecr.paired.B.fastq --unp=/bwdata1/mdebiasse/02-BEROE_OVATA/08-LAST_DITCH_EFFORT/03-ECR/BeDNA-6_S2_L003_trimmed_ecr.unpaired.fastq > ecr.out 2> ecr.err &
```

## MATEMAKER -- platanus assemblies(insert sizes 2k,5k,10k,15k)
<br>plat31 was best assembly so ran matemaker on plat45 and plat63

```
matemaker --assembly ../02-PLAT45/out_gapClosed.fa --insertsize=2000 --out=plat45.2k
matemaker --assembly ../02-PLAT45/out_gapClosed.fa --insertsize=5000 --out=plat45.5k
matemaker --assembly ../02-PLAT45/out_gapClosed.fa --insertsize=10000 --out=plat45.10k
matemaker --assembly ../02-PLAT45/out_gapClosed.fa --insertsize=15000 --out=plat45.15k

matemaker --assembly ../03-PLAT63/out_gapClosed.fa --insertsize=2000 --out=plat63.2k
matemaker --assembly ../03-PLAT63/out_gapClosed.fa --insertsize=5000 --out=plat63.5k
matemaker --assembly ../03-PLAT63/out_gapClosed.fa --insertsize=10000 --out=plat63.10k
matemaker --assembly ../03-PLAT63/out_gapClosed.fa --insertsize=15000 --out=plat63.15k
```

##CANU (varied the following parameters: estimated genome size, correctedErrorRate, corOutCoverage)
<br> corOutCoverage: Only correct the longest reads up to this coverage; default 40
<br>= correctedErrorRate: The allowed difference in an overlap between two corrected reads, expressed as fraction error.

####canu89m.20k

```
canu -p beroe_canu89m -d 01-beroe_canu89m -pacbio  /bwdata1/mdebiasse/05-ENA/01-BEROE/02-PACBIO_READS/beroe_pacbio_raw_reads_concat.fasta -genomeSize=89m
```

####canu89m.cer0.075.20k

```
canu -p beroe_canu89m.cer0.075 -d 02-beroe_canu89m.cer0.075 -genomeSize=89m -correctedErrorRate=0.075 -pacbio /bwdata1/mdebiasse/05-ENA/01-BEROE/02-PACBIO_READS/beroe_pacbio_raw_reads_concat.fasta
```

####canu89m.cer0.15.coc200.20k

```
canu -p beroe_canu89m.cer0.15.coc200 -d 03-beroe_canu89m.cer0.15.coc200 -genomeSize=89m -correctedErrorRate=0.15 -corOutCoverage=200 -pacbio /bwdata1/mdebiasse/05-ENA/01-BEROE/02-PACBIO_READS/beroe_pacbio_raw_reads_concat.fasta
```

####canu120m.cer0.25.coc200.20k

```
canu -p beroe_canu120m.cer0.25.coc200 -d 04-beroe_canu120m.cer0.25.coc200 -genomeSize=120m -correctedErrorRate=0.25 -corOutCoverage=200 -pacbio /bwdata1/mdebiasse/05-ENA/01-BEROE/02-PACBIO_READS/beroe_pacbio_raw_reads_concat.fasta
```

####canu120m.cer0.30.coc200.20k

```
canu -p beroe_canu120m.cer0.30.coc200 -d 05-beroe_canu120m.cer0.30.coc200 -genomeSize=120m -correctedErrorRate=0.30 -corOutCoverage=200 -pacbio /bwdata1/mdebiasse/05-ENA/01-BEROE/02-PACBIO_READS/beroe_pacbio_raw_reads_concat.fasta
```

## MATEMAKER CANU ASSEMBLIES (insert sizes 2k,5k,10k,15k,20k,50k,75k,100k)

#### make mates from canu89m assembly

```
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=2000 --out=canu89m.2k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=5000 --out=canu89m.5k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=10000 --out=canu89m.10k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=15000 --out=canu89m.15k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=20000 --out=canu89m.20k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=50000 --out=canu89m.50k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=75000 --out=canu89m.75k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/01-beroe_canu89m/beroe_canu89m.contigs.fasta --insertsize=100000 --out=canu89m.100k
```

#### make mates from canu89m.cer0.075 assembly

```
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=2000 --out=canu89m.cer0.075.2k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=5000 --out=canu89m.cer0.075.5k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=10000 --out=canu89m.cer0.075.10k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=15000 --out=canu89m.cer0.075.15k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=20000 --out=canu89m.cer0.075.20k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=50000 --out=canu89m.cer0.075.50k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=75000 --out=canu89m.cer0.075.75k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/02-beroe_canu89m.cer0.075/beroe_canu89m.cer0.075.contigs.fasta --insertsize=100000 --out=canu89m.cer0.075.100k
```

#### make mates from canu89m.cer0.15.coc200 assembly

```
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=2000 --out=canu89m.cer0.15.coc200.2k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=5000 --out=canu89m.cer0.15.coc200.5k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=10000 --out=canu89m.cer0.15.coc200.10k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=15000 --out=canu89m.cer0.15.coc200.15k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=20000 --out=canu89m.cer0.15.coc200.20k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=50000 --out=canu89m.cer0.15.coc200.50k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=75000 --out=canu89m.cer0.15.coc200.75k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/03-beroe_canu89m.cer0.15.coc200/beroe_canu89m.cer0.15.coc200.contigs.fasta --insertsize=100000 --out=canu89m.cer0.15.coc200.100k
```

#### make mates from canu120m.cer0.25.coc200 assembly

```
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=2000 --out=canu120m.cer0.25.coc200.2k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=5000 --out=canu120m.cer0.25.coc200.5k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=10000 --out=canu120m.cer0.25.coc200.10k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=15000 --out=canu120m.cer0.25.coc200.15k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=20000 --out=canu120m.cer0.25.coc200.20k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=50000 --out=canu120m.cer0.25.coc200.50k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=75000 --out=canu120m.cer0.25.coc200.75k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/04-beroe_canu120m.cer0.25.coc200/beroe_canu120m.cer0.25.coc200.contigs.fasta --insertsize=100000 --out=canu120m.cer0.25.coc200.100k
```

#### make mates from canu120m.cer0.30.coc20 assembly

```
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=2000 --out=canu120m.cer0.30.coc200.2k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=5000 --out=canu120m.cer0.30.coc200.5k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=10000 --out=canu120m.cer0.30.coc200.10k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=15000 --out=canu120m.cer0.30.coc200.15k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=20000 --out=canu120m.cer0.30.coc200.20k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=50000 --out=canu120m.cer0.30.coc200.50k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=75000 --out=canu120m.cer0.30.coc200.75k
matemaker --assembly /bwdata1/jfryan/07-BEROE/35-RESTART/01-CANU2.1/05-beroe_canu120m.cer0.30.coc200/beroe_canu120m.cer0.30.coc200.contigs.fasta --insertsize=100000 --out=canu120m.cer0.30.coc200.100k
```

## REMOVE SHORT CONTIGS FROM PLAT31 (Plat31 was best short read assembly. Remove contigs shorter than 200 nts)

```
remove_lt200.pl ../01-PLAT31/out_gapClosed.fa > plat31.gte200.fa
```

## SSPACE (see libraries.txt)
<br> order of scaffolding (shortest inserts (2k) to longest (100k).
<br> platanus mates always before canu mates

```
/usr/local/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl -l libraries.txt -s plat31.gte200.fa -T 45 -k 5 -a 0.7 -x 0 -b Bova_scf
```

## BREAK GAPS (break gaps greater than 5k)

```
break_big_gaps.pl ../08-SSPACE/Bova_scf/Bova_scf.final.scaffolds.fasta 5000 > Bova_scf_5k_gaps_removed.fa
```

## REDUNDANS

```
redundans.py -v -i /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L001_R1_001.fastq /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L001_R2_001.fastq /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L002_R1_001.fastq /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L002_R2_001.fastq /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L003_R1_001.fastq /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L003_R2_001.fastq /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L004_R1_001.fastq /bwdata1/mdebiasse/02-BEROE_OVATA/99-BOVA1.0_3.0/00-DATA/03-ILLUMINA_DNA/01-LIBRARIES/BeDNA-6_S2_L004_R2_001.fastq -f Bova_scf_5k_gaps_removed.fa -o Bova_scf_5k_gaps_removed_redundans --threads 45
```


