# COMMANDS USED FOR TGF-BETA RECEPTOR ANALYSIS

### Build custom hidden Markov model (HMM)
```
hmmbuild pang.rec.hmm pang.rec.fa
hmmbuild -O Pang.TGFBR.adjusted.stockholm Pang.TGFBR.hmm pang.rec.fa > hmmbuild.out
esl-reformat -o Pang.TGFBR.adjusted.fa afa Pang.TGFBR.adjusted.stockholm > esl-reformat.out 2> esl-reformat.err
perl remove_dots_and_lc.pl Pang.TGFBR.adjusted.fa  > Pang.rec.adjusted.nodotsallcaps.fa
```

Fixes tildes at the beginning of sequences
```
perl -pi.orig -e 's/^\~+/----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------/' Pang.rec.adjusted.nodotsallcaps.fa
```

### ALIGN BEROE OVATA PROTEIN SEQUENCES TO HMM
```
hmm2aln.pl --hmm=pang.rec.hmm --name=Bo_receptors --fasta=Bova1.4.aa --threads=40 > Bo_hmm2aln.out 2> Bo_hmm2aln.err
```

### ALIGN HORMIPHORA CALIFORNENSIS PROTEIN SEQUENCES TO HMM
```
hmm2aln.pl --hmm=pang.rec.hmm --name=Hc_receptors --fasta=Hcv1av93_model_proteins.pep --threads=40 > Hc_hmm2aln.out 2> Hc_hmm2aln.err
```

### PRELIMINARY PHYLOGENETIC ANALYSIS
```
cat Pang.rec.adjusted.nodotsallcaps.fa Bo_hmm2aln.out Hc_hmm2aln.out > Bo_Hc_Pang.rec.fa
iqtree-omp -s Bo_Hc_Pang.rec.fa -nt AUTO -bb 1000 -m LG -pre prelim
```

### MAKE SUBALIGNMENT
Pruning of clades that did not include sequences from the starting published alignment (pang.rec.fa)
```
make_subalignment --tree=prelim.treefile --aln=../04-PRELIMTREE/Bo_Hc_Pang.rec.fa --root=Bova1_4.0330.g15.t1.1 --pre=Hsa_ > make_subalignment.out 2> make_subalignment.err
```

### SECOND PRELIMINARY ANALYSIS
```
iqtree-omp -s make_subalignment.out -nt AUTO -bb 1000 -m LG -pre prelim2
```

### PRUNE SUBALSIGNMENT
Count gaps
```
count_gaps.pl make_subalignment.out > count_gaps.out
```

We removed any sequence with >= 281 (61%) gaps, as well as Bova1_4.0164.g10.t1 and Hcv1.av93.c4.g664.i1 since both produced long branches with unstable phylogenetic positions. 

```
perl rename_remove_seqs.pl > Bo_Hc_Pang.rec.renames.fa
```

### MAXIMUM-LIKELIHOOD ANALYSES
```
iqtree-omp -s Bo_Hc_Pang.rec.renames.fa -nt AUTO -bb 1000 -m TEST -pre model_test
raxmlHPC-PTHREADS-SSE3 -T 100 -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc_Pang.rec.renames.fa -n out_mp > rax.stdout 2> rax.err &
raxmlHPC-PTHREADS-SSE3 -d -f a -x 12345 -T 40 -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc_Pang.rec.renames.fa -n out_rand > rax.stdout 2> rax.err &
raxmlHPC -f e -m PROTGAMMALG -t model_test.treefile -s Bo_Hc_Pang.rec.renames.fa -n iq > rax.iq.stdout 2> rax.iq.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_mp -s Bo_Hc_Pang.rec.renames.fa -n mp > rax.mp.stdout 2> rax.mp.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_rand -s Bo_Hc_Pang.rec.renames.fa -n rand > rax.rand.stdout 2> rax.rand.err &
```
