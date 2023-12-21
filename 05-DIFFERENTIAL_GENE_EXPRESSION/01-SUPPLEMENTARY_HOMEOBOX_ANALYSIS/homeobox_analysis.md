# COMMAND USED TO PERFORM PHYLOGENETIC ANALYSIS OF HOMEOBOX GENES

### Perform phylogenetic analysis for the candidate homeobox protein ML18891a and homeobox proteins from Ryan et al. (2010)

We added the amino acid sequence from ML18891a to the Ryan et al. (2010) supertree.phy alignement (https://link.springer.com/article/10.1186/2041-9139-1-9).
```
iqtree-omp -nt AUTO -s supertree_pou_candidate.phy -m LG+G4
```
