# COMMANDS USED TO PERFORM MACROSYNTENY ANALYSIS

### Identify orthologous pairs from  _Beroe ovata_ and _Hormiphora californensis_ proteomes using reciprocal best BLAST
```
rbhXpress/rbhXpress.sh -a Bova1.5.aa -b Hcv1av93_model_proteins.pep -o Bova_Hcal.tab -t 200
```

### Format GFF files to create BED files for each species
Keep only transcript coordinates from _H. californensis_ GFF file (transcript coordinates were used to retain isoform data)
```
cat Hcv1av93.gff | grep 'transcript' > Hcv1av93.gene.gff
```

Edit _H. californensis_ gene names to match Bova_Hcal.tab (which was produced from rbhXpress) using VIM
```
vi Hcv1av93.gene.gff
:%s/ID=//g
:%s/;Parent=.*//g
:w Hcv1av93.gene.gff2
```

Keep only BED format columns from _H. californensis_ GFF
```
cat Hcv1av93.gene.gff2 | cut -f1,4,5,9 > Hcv1av93.gene.bed
```

Copy _B. ovata_ GFF file and edit copy to retain gene coordinates using VIM
```
cp Bova1.5.gff Bova1.5.gff.gene_id_edited
vi Bova1.5.gff.gene_id_edited
:%s/gene_id=/g_id=//g
```

Keep only gene coordinates from _B. ovata_ GFF file (isoform data is included)
```
cat Bova1.5.gff.gene_id_edited | grep gene > Bova1.5.gene.gff
```

Keep only BED format columns from _B. ovata_ GFF
```
cat Bova1.5.gene.gff | cut -f1,4,5,9 > Bova1.5.gene.bed
```

### MACROSYNTENY ANALSYIS IN R
Run macrosyntR.R in RStudio
