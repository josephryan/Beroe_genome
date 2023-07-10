# COMMANDS USED FOR TGF-BETA LIGAND ANALYSIS

### BUILD CUSTOM HIDDEN MARKOV MODEL (HMM) AND ALIGNMENT FILE THAT CORRESPONDS W HMM
```
hmmbuild pang.ligands.hmm pang.ligands.fa
hmmbuild -O pang.TGFBL.adjusted.stockholm pang.TGFBL.hmm pang.ligands.fa  > hmmbuild.out
esl-reformat -o pang.TGFBL.adjusted.fa afa pang.TGFBL.adjusted.stockholm > esl-reformat.out 2> esl-reformat.err
perl ../remove_dots_tildes_and_lc.pl pang.TGFBL.adjusted.fa > pang.ligands.adjusted.nodotsallcaps.fa
```
### ALIGN BEROE OVATA PROTEIN SEQUENCES TO HMM
#### download Bova1.5.aa from http://ryanlab.whitney.ufl.edu/bovadb/
```
hmm2aln.pl --hmm=pang.ligands.hmm --name=Bo_ligands --fasta=Bova1.5.aa --threads=40 > Bo_hmm2aln.out 2> Bo_hmm2aln.err
```

### ALIGN HORMIPHORA CALIFORNENSIS PROTEIN SEQUENCES TO HMM
#### download Hcv1av93_model_proteins.pep from https://zenodo.org/record/4074309
```
hmm2aln.pl --hmm=pang.ligands.hmm --name=Hc_ligands --fasta=Hcv1av93_model_proteins.pep --threads=40 > Hc_hmm2aln.out 2> Hc_hmm2aln.er
```

### PRELIMINARY PHYLOGENETIC ANALYSIS
```
cat pang.ligands.adjusted.nodotsallcaps.fa Bo_hmm2aln.out Hc_hmm2aln.out > Bo_Hc_Pang.ligands.fa
iqtree-omp -s Bo_Hc_Pang.ligands.fa -nt AUTO -bb 1000 -m LG -pre prelim
```

We removed isoforms and renamed TGF-beta ligand sequences for clarity
```
perl rename_remove_seqs_tgfb_ligands.pl > Bo_Hc_Pang.ligands.renames.fa
```

### MAXIMUM-LIKELIHOOD ANALYSES
```
iqtree-omp -s Bo_Hc_Pang.ligands.renames.fa -nt AUTO -bb 1000 -m TEST -pre model_test
raxmlHPC-PTHREADS-SSE3 -d -f a -x 12345 -T 40 -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc_Pang.ligands.renames.fa -n out_rand > rax.stdout 2> rax.err &
raxmlHPC-PTHREADS-SSE3 -T 100 -p 12345 -# 25 -m PROTGAMMAAUTO -s Bo_Hc_Pang.ligands.renames.fa -n out_mp > rax.stdout 2> rax.err &
raxmlHPC -f e -m PROTGAMMALG -t model_test.treefile -s Bo_Hc_Pang.ligands.renames.fa -n iq > rax.iq.stdout 2> rax.iq.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_rand -s Bo_Hc_Pang.ligands.renames.fa -n rand > rax.rand.stdout 2> rax.rand.err &
raxmlHPC -f e -m PROTGAMMALG -t RAxML_bestTree.out_mp -s Bo_Hc_Pang.ligands.renames.fa -n mp > rax.mp.stdout 2> rax.mp.err &
```
