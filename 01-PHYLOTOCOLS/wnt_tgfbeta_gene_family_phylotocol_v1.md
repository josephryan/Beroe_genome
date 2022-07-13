# PLANNED ANALYSES FOR GENE FAMILY ANALYSES IN THE CTENOPHORE BEROE OVATA
 Investigators: Joseph Ryan, Melissa DeBiasse, Dani Hayes, Daniel Groso  
 Draft or Version Number: v1.0  
 Date: Mon Jul 27 17:35:33 EDT 2020
 Note: this document will be updated (updates will be tracked through github)
 
## 1 INTRODUCTION: BACKGROUND INFORMATION AND SCIENTIFIC RATIONALE  

### 1.1 _Background Information_  

The genomes of Mnemiopsis leidyi (Ryan et al. 2013) and Pleurobrachia bachei (Moroz et al. 2014) are currently the only published ctenophore genomes. 

### 1.2 _Rationale_  

Though there have been several extensive gene family analyses performed based on these genomes, especially Mnemiopsis (Pang et al. 2010; Pang et al. 2011),  there has not been extensive comparions of gene families between different species of ctenophores. These comparisons are important in order to understand evolution within ctenophores and to understand early animal evolution.

### 1.3 _Objectives_  

We will identify and classify from Beroe, and compare to Mnemiopsis the following gene families: Wnt and TGF-Beta.

## 2 STUDY DESIGN AND ENDPOINTS  

#### 2.1 Identify important ctenophore gene families using hidden Markov models (HHMs) and a tree-based approach 

2.1.1 build HMMs from Pang et al. 2010 and Pang et al. 2011 of Wnt, TGF-beta ligand receptor, SMAD, and Wnt.

```
hmmbuild pang_alignment.hmm
```

2.1.2 search the translated B. ovata transcriptome and amino acid gene models against each HMM

```
./hmm2aln.pl --hmm=<gene_family.hmm> --name=<out_prefix> --fasta=<fasta_file_to_search> --threads=40 > outfile.fa 2> std_err.txt
```
  
2.1.3 Concatenate the alignment produced in 2.1.2 to the Pang alignment used to create the hmm in 2.1.1

2.1.4 removed

2.1.5 remove redundancy created by including both transcriptome and protein models in step 2.1.2. The goal being to have one sequence per genomic loci.

2.1.6 estimate a final gene tree using the alignment generated in step 2.1.4/2.1.5 following the procedure outlined in Babonis et al. 2019 https://doi.org/10.1186/s13227-019-0138-1 (outlined below)

2.1.6.1 Estimate a tree and identify best substitution model in IQTREE
```
iqtree-omp -s [infile.fa] -nt AUTO -m TEST -pre model_test > iq.stdout 2> iq.err
```

2.1.6.2 run RAxML with 25 parsimony starting trees
```
raxmlHPC-PTHREADS-SSE3 -T [number of threads] -p 12345 -# 25 -m [model from step 2.1.6.1] -s [infile.fa] -n out_mp > rax.stdout 2> rax.err &
```

2.1.6.3 run RAxML with 25 random starting trees
```
raxmlHPC-PTHREADS-SSE3 -d -T [number of threads] -# 25 -m [model from step 2.1.6.1] -s [infile.fa] -n out_random > rax.stdout 2> rax.err &
```

2.1.6.4 Compute a likelihood score for the IQTREE tree and compare it to the 2 RAXML runs to identify the best ML tree
```
raxmlHPC -f e -m [model] -t IQTREE-tree-from-2.1.6.1 -s infile.fa -n tree_compare > rax.stdout 2> rax.err &
```

2.1.6.5 generate 1000 bootstraps for best tree
```
raxmlHPC-PTHREADS-SSE3 -d -T [number of threads] -p 12345 -m [model] -s infile.fa -n outfile_boots -# 1000 -x 54321 > rax.stdout 2> rax.err &
```

2.1.6.6 apply bootstraps to best tree
```
raxmlHPC -m [model] -p 12345 -f b -t RAxML_bestTree -z outfile_boots -n RAxML_bestTree_bootstraps_applied > rax.stdout 2> rax.err &
```

## 3 CHANGES AND WORK COMPLETED SO FAR

Thu Jul 30 12:06:11 EDT 2020 - nothing

Thu Aug  6 12:40:48 EDT 2020 - 

    - starting with Pang alignments instead of PFAM hmms, removed make_subalignment

    - so far: created a beroe only tree using pfam hmm. Then realized initial plan had some holes.
    
Wed Jul  13 2021 - 

    - We used this approach for the opsin phylogeny, but realized that we need additional outgroup sequences to identify Mnemiopsis opsin3 
    
    - So we are using hmm2aln.pl to pull out all opsin-related genes from human, fly, Capitella, Nematostella, Hydra, and Mnemiopsis
    
    - We will then run iqtree to see if Mnemiopsis opsin3 is related to any bilaterian or cnidarian sequences


## 4 REFERENCES

Babonis LS, Ryan JF, Enjolras C, Martindale MQ. Genomic analysis of the tryptome reveals molecular mechanisms of gland cell evolution. EvoDevo. 2019 Dec;10(1):1-8.

Moroz LL, Kocot KM, Citarella MR, Dosung S, Norekian TP, Povolotskaya IS, Grigorenko AP, Dailey C, Berezikov E, Buckley KM, Ptitsyn A, Reshetov D, Mukherjee K, Moroz TP, Bobkova Y, Yu F, Kapitonov VV, Jurka J, Bobkov YV, Swore JJ, Girardo DO, Fodor A, Gusev F, Sanford R, Bruders R, Kittler E, Mills CE, Rast JP, Derelle R, Solovyev VV, Kondrashov FA, Swalla BJ, Sweedler JV, Rogaev EI, Halanych KM, Kohn AB. The ctenophore genome and the evolutionary origins of neural systems. Nature. 2014 Jun 5;510(7503):109-14. doi:10.1038/nature13400.

Pang K, Ryan JF, Mullikin JC, Baxevanis AD, Martindale MQ, NISC Comparative Sequencing Program. Genomic insights into Wnt signaling in an early diverging metazoan, the ctenophore Mnemiopsis leidyi. EvoDevo. 2010 Dec 1;1(1):10.

Pang K, Ryan JF, Baxevanis AD, Martindale MQ. Evolution of the TGF-β signaling pathway and its potential role in the ctenophore, Mnemiopsis leidyi. PloS one. 2011 Sep 8;6(9):e24152.

Ryan JF, Pang K, Schnitzler CE, Nguyen AD, Moreland RT, Simmons DK, Koch BJ, Francis WR, Havlak P, Smith SA, Putnam NH, Haddock SH, Dunn CW, Wolfsberg TG, Mullikin JC, Martindale MQ & Baxevanis AD. The genome of the ctenophore Mnemiopsis leidyi and its implications for cell type evolution. Science. 2013 Dec 13;342(6164).


