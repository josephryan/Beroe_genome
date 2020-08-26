# PLANNED ANALYSES FOR PHOTOPROTEINS OF THE CTENOPHORE, BEROE OVATA
 Investigators: Joseph Ryan, Melissa DeBiasse, Dani Hayes, Daniel Groso  
 Draft or Version Number: v1.0  
 Date: Wed Aug 26 10:55 EDT 2020
 Note: this document may be updated (updates will be tracked through github)
 
## 1 INTRODUCTION: BACKGROUND INFORMATION AND SCIENTIFIC RATIONALE  

### 1.1 _Background Information_ 

The genome of Mnemiopsis leidyi (Ryan et al. 2013) is currently the only published bioluminescent ctenophore genome. 

### 1.2 _Rationale_  

One bioluminescent genome has been published, this is the first photoprotein comparison within ctenophores. This comparison is important in order to understand evolution within ctenophores and to understand early animal evolution.

### 1.3 _Objectives_  

We will identify and classify photoproteins from Beroe, and compare them to Mnemiopsis.

## 2 STUDY DESIGN AND ENDPOINTS  

#### 2.1 Identify photoprotein transcripts using a BLAST based approach

2.1.1 BLAST the M. leidyi photoproteins against the B. ovata transcriptome assembly.

2.1.2 create a database of the B. ovata transcripts from 2.1.1

```
makeblastdb -dbtype nucl -in B.ovata_pp_transcriptomes.fa
```

2.1.3 BLAST the B. ovata genome against our transcriptome database from 2.1.2 using the specified output format and restricted e-value

```
blastn -db B.ovata_pp_transcriptomes.fa -query B.ovata_genome.fa -outfmt "6 qseqid sseqid sstart send sframe" -evalue .000000000001 > blastn_query.out
```

2.1.4 BLAST the M. leidyi photoproteins against the B. ovata genome

``` 
blastx -db M.leidyi_photoproteins.fa -query B.ovata_genome.fa -outfmt "6 qseqid sseqid qstart qend qframe" > blastx_query.out
```

2.1.5 use blast_/gff.pl script to re-write blastn_/query.out and blastx_/query.out as a gff files

```
perl blast_gff.pl blastn_query.out > blastn_query.gff
perl blast_gff.pl blastx_query.out > blastx_query.gff
```

2.1.6 import the gff file from 2.1.5 into UGENE

2.1.7 manually identify the stop and start codons and any potential intron/exon structure for each photoprotein based on transcript alignments.

2.1.8 align Beroe photoproteins to the alignment of photoproteins in Schnitzler et al. 2012.

```
mafft --add Bova_pp.fa schnitzler_aligned_pp.fa > all_pp.fa
```

2.1.9 run IQTREE using the B. ovata and M. leidyi photoprotein genes

```
iqtree-omp -s [infile.fa] -nt AUTO -m TEST -pre  photoprotein_tree > iq.stdout 2> iq.err
```

## 3 CHANGES AND WORK COMPLETED SO FAR

Wed Aug 26 14:20 EDT 2020 - 

    - so far: completed up to step 2.1.7 (genes have been predicted manually, but alignment and tree have not been generated)

## 4 REFERENCES

Ryan JF, Pang K, Schnitzler CE, Nguyen AD, Moreland RT, Simmons DK, Koch BJ, Francis WR, Havlak P, Smith SA, Putnam NH, Haddock SH, Dunn CW, Wolfsberg TG, Mullikin JC, Martindale MQ & Baxevanis AD. The genome of the ctenophore Mnemiopsis leidyi and its implications for cell type evolution. Science. 2013 Dec 13;342(6164).

Schnitzler CE, Pang K, Powers ML, Reitzel AM, Ryan JF, Simmons D, Tada T, Park M, Gupta J, Brooks SY, Blakesley RW. Genomic organization, evolution, and expression of photoprotein and opsin genes in Mnemiopsis leidyi: a new view of ctenophore photocytes. BMC biology. 2012 Dec 1;10(1):107.

