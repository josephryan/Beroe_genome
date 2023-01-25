# COMMANDS USED FOR OPSIN ANALYSIS

### Build custom hidden Markov model (HMM)
```
hmmbuild opsin.hmm opsin.fa
hmmbuild -O opsin.adjusted.stockholm opsin.hmm opsin.fa  > hmmbuild.out
esl-reformat -o opsin.adjusted.fa afa opsin.adjusted.stockholm > esl-reformat.out 2> esl-reformat.err
perl remove_dots_tildes_and_lc.pl opsin.adjusted.fa > opsin.adjusted.nodotsallcaps.fa
```

### ALIGN BEROE OVATA PROTEIN SEQUENCES TO HMM
```
hmm2aln.pl --hmm=opsin.hmm --name=Bo_opsin --fasta=Bova1.4.aa --threads=40 > Bo_hmm2aln.out 2> Bo_hmm2aln.err
```

### ALIGN HORMIPHORA CALIFORNENSIS PROTEIN SEQUENCES TO HMM
```
hmm2aln.pl --hmm=opsin.hmm --name=Hc_opsin --fasta=Hcv1av93_model_proteins.pep --threads=40 > Hc_hmm2aln.out 2> Hc_hmm2aln.err
```

### PRELIMINARY PHYLOGENETIC ANALYSIS
```
cat opsin.adjusted.nodotsallcaps.fa ../02-BO/Bo_hmm2aln.out ../03-HC/Hc_hmm2aln.out > Bo_Hc.opsin.fa
iqtree-omp -s Bo_Hc.opsin.fa -nt AUTO -bb 1000 -m LG -pre prelim
```

### MAKE SUBALIGNMENT
Pruning of clades that did not include sequences from the starting published alignment (opsins.fa)
```
make_subalignment --tree=prelim.treefile --aln=Bo_Hc.opsin.fa --root=Bova1_4.0015.g57.t1 --pre=Nematostella_ > make_subalignment.out 2> make_subalignment.err
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

We removed any seqs with >=184 gaps. We also removed Bova1_4.0001.g9.t1.2 since it had ~50% overlap with Bova1_4.0001.g9.t1.1 and aligned to the 5 prime end of the full sequence, which was the same as Mnemiopsis opsin2 sequence. We also removed Hcv1.av93.c10.g623.i1.2 since there was >50% overlap with Hcv1.av93.c10.g623.i1.1 and the sequence aligned to the position of Mnemiopsis opsin 2. 

We removed Mnemiopsis opsin3 as well because it grouped with non-opsin ctenophore sequences.

```
perl rename_remove_seqs.pl > Bo_Hc.opsin.renames.fa
``` 

### MAXIMUM-LIKELIHOOD ANALYSES
```
iqtree-omp -s Bo_Hc.opsin.renames.fa -nt AUTO -bb 1000 -m TEST -pre model_test
raxmlHPC-PTHREADS-SSE3 -T 100 -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc.opsin.renames.fa -n out_mp > rax.stdout 2> rax.err &
raxmlHPC-PTHREADS-SSE3 -d -f a -x 12345 -T 40  -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc.opsin.renames.fa -n out_rand > rax.stdout 2> rax.err &
raxmlHPC -f e -m PROTGAMMALG -t model_test.treefile -s Bo_Hc.opsin.renames.fa -n iq > rax.iq.stdout 2> rax.iq.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_mp -s Bo_Hc.opsin.renames.fa -n mp > rax.mp.stdout 2> rax.mp.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_rand -s Bo_Hc.opsin.renames.fa -n rand > rax.rand.stdout 2> rax.rand.err &
```
