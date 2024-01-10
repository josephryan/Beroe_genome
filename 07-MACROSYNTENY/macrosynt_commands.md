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

Edit _H. californensis_ gene names to match those in Bova_Hcal.tab (which was produced from rbhXpress) 
```
vi Hcv1av93.gene.gff
:%s/ID=//g
:%s/;Parent=.*//g
:w Hcv1av93.gene.gff2
:q
```

Modify _H. californensis_ GFF to BED format
```
cat Hcv1av93.gene.gff2 | cut -f1,4,5,9 > Hcv1av93.gene.bed
```

Keep only gene coordinates from _B. ovata_ GFF file (transcript coordinates were used to retain isoform data)
```
cat Bova1.5.gff | grep 'mRNA' > Bova1.5.gene.gff
```

Edit _H. californensis_ gene names to match those in Bova_Hcal.tab (which was produced from rbhXpress)
```
vi Bova1.5.gene.gff
:%s/ID=//g
:%s/;Parent=.*//g
:w Bova1.5.gene.gff2
:q
```

Modify _B. ovata_ GFF to BED format
```
cat Bova1.5.gene.gff2 | cut -f1,4,5,9 > Bova1.5.gene.bed
```

### MACROSYNTENY ANALSYIS IN R
Run macrosyntR.R in RStudio
