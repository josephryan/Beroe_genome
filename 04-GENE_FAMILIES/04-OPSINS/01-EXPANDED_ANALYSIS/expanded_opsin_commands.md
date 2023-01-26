# COMMANDS USED FOR EXPANDED OPSIN ANALYSIS

### BUILD CUSTOM HIDDEN MARKOV MODEL (HMM)
```
hmm2aln.pl --hmm=opsin.hmm --name=Ct_opsin --fasta=Capitella_teleta.Capitella_teleta_v1.0.pep.all.fa --threads=40 > Ct_hmm2aln.out 2> Ct_hmm2aln.err
hmm2aln.pl --hmm=opsin.hmm --name=Dm_opsin --fasta=Drosophila_melanogaster.BDGP6.28.pep.all.fa --threads=40 > Dm_hmm2aln.out 2> Dm_hmm2aln.err
hmm2aln.pl --hmm=opsin.hmm --name=Hs_opsin --fasta=HumRef_w_names.fasta --threads=40 > Hs_hmm2aln.out 2> Hs_hmm2aln.err
hmm2aln.pl --hmm=opsin.hmm --name=Hv_opsin --fasta=/00-DATA/hydra2.0_genemodels.aa --threads=40 > Hv_hmm2aln.out 2> Hv_hmm2aln.err
hmm2aln.pl --hmm=opsin.hmm --name=Ml_opsin --fasta=ML2.2.aa --threads=40 > Ml_hmm2aln.out 2> Ml_hmm2aln.err
hmm2aln.pl --hmm=opsin.hmm --name=Nv_opsin --fasta=Nematostella_vectensis.ASM20922v1.pep.all.fa --threads=40 > Nv_hmm2aln.out 2> Nv_hmm2aln.err
cat opsin.adjusted.nodotsallcaps.fa Ct_hmm2aln.out Dm_hmm2aln.out Hs_hmm2aln.out Hv_hmm2aln.out Ml_hmm2aln.out Nv_hmm2aln.out > opsins_outgroups.fa
```

### MAXIMUM-LIKELIHOOD ANALYSIS
Renamed long gene names for clarity
```
perl rename_long_names.pl opsins_outgroups.fa > opsins_outgroups_renamed.fa
```

```
iqtree-omp -s opsins_outgroups_renamed.fa -m LG -nt AUTO
```
