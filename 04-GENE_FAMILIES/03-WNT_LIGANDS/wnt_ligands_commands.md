# COMMANDS USED FOR WNT LIGAND ANALYSIS

### BUILD CUSTOM HIDDEN MARKOV MODEL (HMM)
```
hmmbuild pang.wnt.hmm pang.wnt.msa
hmmbuild -O pang.wnt.adjusted.stockholm pang.wnt.hmm pang.wnt.msa  > hmmbuild.out
esl-reformat -o pang.wnt.adjusted.fa afa pang.wnt.adjusted.stockholm > esl-reformat.out 2> esl-reformat.err
```

### ALIGN BEROE OVATA PROTEIN SEQUENCES TO HMM
```
hmm2aln.pl --hmm=pang.wnt.hmm --name=Bo_wnt --fasta=Bova1.4.aa --threads=40 > Bo_hmm2aln.out 2> Bo_hmm2aln.err
```

### ALIGN HORMIPHORA CALIFORNENSIS PROTEIN SEQUENCES TO HMM
```
hmm2aln.pl --hmm=pang.wnt.hmm --name=Hc_wnt --fasta=Hcv1av93_model_proteins.pep --threads=40 > Hc_hmm2aln.out 2> Hc_hmm2aln.err
```

### PRELIMINARY PHYLOGENETIC ANALYSIS
```
cat pang.wnt.adjusted.nodotsallcaps.fa Bo_hmm2aln.out Hc_hmm2aln.out > Bo_Hc_Pang.wnt.fa
```
We removed Pdu_Wnt9 because it contained 91% gaps

```
iqtree-omp -s Bo_Hc_Pang.wnt.fa -nt AUTO -bb 1000 -m LG -pre prelim
```

We renamed Wnt sequences for clarity
```
perl rename_wnt_seqs.pl > Bo_Hc_Pang.wnt.renames.fa
```

### MAXIMUM-LIKELIHOOD ANALYSES
```
iqtree-omp -s Bo_Hc_Pang.wnt.renames.fa -nt AUTO -bb 1000 -m TEST -pre model_test
raxmlHPC-PTHREADS-SSE3 -d -f a -x 12345 -T 40 -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc_Pang.wnt.renames.fa -n out_random > rax.stdout 2> rax.err &
raxmlHPC-PTHREADS-SSE3 -T 100 -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc_Pang.wnt.renames.fa -n out_mp > rax.stdout 2> rax.err &
raxmlHPC -f e -m PROTGAMMALG -t model_test.treefile -s Bo_Hc_Pang.wnt.renames.fa -n iq > rax.iq.stdout 2> rax.iq.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_random -s Bo_Hc_Pang.wnt.renames.fa -n rand > rax.rand.stdout 2> rax.rand.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_mp -s Bo_Hc_Pang.wnt.renames.fa -n mp > rax.mp.stdout 2> rax.mp.err &
```
