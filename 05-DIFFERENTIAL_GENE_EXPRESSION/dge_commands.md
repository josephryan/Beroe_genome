# COMMANDS USED TO PERFORM DIFFERENTIAL GENE EXPRESSION ANALYSES

## IDENTIFYING SINGLE COPY ORTHOLOGS
_Beroe ovata_ protein models and _Mnemiopsis leidyi_ protein models were used as input for OrthoFinder

### OrthoFinder analysis
```
orthofinder -t 18 -f 01-ORTHOFINDER_I1.5 > of.out 2> of.err &
orthofinder -t 256 -f 02-ORTHOFINDER_RERUN_I5 -I 5 > of2.out 2> of2.err &
orthofinder -t 256 -f 03-ORTHOFINDER_RERUN_I8 -I 8 > of_i8.out 2> of_i8.err &
orthofinder -t 256 -f 04-ORTHOFINDER_RERUN_I10 -I 10 > of_i10.out 2> of_i10.err &
```

### Combine single-copy orthologs from all OrthoFinder analysis
Create symbolic links to the Single_Copy_Orthologue_Sequences for each run
```
ln -s /I1.5/OrthoFinder/Results/Single_Copy_Orthologue_Sequences I1.5
ln -s /I5/OrthoFinder/Results/Single_Copy_Orthologue_Sequences I5
ln -s /I8/OrthoFinder/Results/Single_Copy_Orthologue_Sequences I8
ln -s /I10/OrthoFinder/Results/Single_Copy_Orthologue_Sequences I10
```
Run print_total-1_to_1s.pl to combine single-copy orthologs
```
perl print_total-1_to_1s.pl > print_total-1_to_1s.out
```

### Perform maximum-likelihood analyses to identify additional single-copy orthologs
Create symbolic link to the Orthogroup_Sequences for each run
```
ln -s /I1.5/OrthoFinder/Results/Orthogroup_Sequences I1.5.multi
ln -s /I5/OrthoFinder/Results/Orthogroup_Sequences I5.multi
ln -s /I8/OrthoFinder/Results/Orthogroup_Sequences I1.8.multi
ln -s /I10/OrthoFinder/Results/Orthogroup_Sequences I10.multi
```
```
perl ogs_w_4plus_taxa_mafft_iqtree.pl
```

### Discard conflicting OrthoFinder results
```
perl print_isoforms_blocking_one_to_ones.pl > print_isoforms_blocking_one_to_ones.out
```

### Combine single-copy orthologs from gene trees with those idenfitied in the OrthoFinder runs
```
perl get_final_set.pl
```

## DIFFERENTIAL GENE EXPRESSION ANALYSIS
Tissue-specific transcriptomic data found in the European Nucleotide Archive under project number [PRJEB55009](https://www.ebi.ac.uk/ena/browser/view/PRJEB55009)

### ANALYSIS ON _B. OVATA_ TISSUE-SPECIFIC DATA

### Transcript quantification
```
grep '^>' Bova1.4.cds | perl -ne 'chomp; m/^>(.*).(t\d+)/; print "$1\t$1.$2\n";' > Bo_gene_map.out
/usr/local/trinityrnaseq-v2.12.0/util/align_and_estimate_abundance.pl --transcripts Bova1.4.cds --gene_trans_map Bo_gene_map.out --prep_reference --samples_file Bo_samples_file.txt --est_method RSEM --seqType fq --output_dir aea_Bo2 --aln_method bowtie2 --thread_count 40 > aea_Bo2.out 2> aea_Bo2.err
```

### Quality check samples and replicates
```
/usr/local/trinityrnaseq-Trinity-v2.8.5/util/abundance_estimates_to_matrix.pl --est_method RSEM --gene_trans_map Bo_gene_map.out --out_prefix Bova1.4 --name_sample_by_basedir BoCR_rep1/RSEM.genes.results BoCR_rep2/RSEM.genes.results BoCR_rep3/RSEM.genes.results BoST_rep1/RSEM.genes.results BoST_rep2/RSEM.genes.results BoST_rep3/RSEM.genes.results
/usr/local/trinityrnaseq-Trinity-v2.8.5/Analysis/DifferentialExpression/PtR --matrix Bova1.4.isoform.counts.matrix --samples Bo_samples_file2.txt --log2 --CPM --min_rowSums 10 --compare_replicates --center_rows --prin_comp 3
```

### Differential gene expression analysis
```
/usr/local/trinityrnaseq-Trinity-v2.8.5/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix Bova1.4.gene.counts.matrix --method voom --samples_file Bo_samples_file2.txt
perl filter_de.pl Bova1.4.gene.counts.matrix.BoCR_vs_BoST.voom.DE_results BOCR_vs_BOST.voom
cut -f1 BOCR_vs_BOST.voom.logFC_2.txt > combrows_boids_de.txt
cut -f1 BOCR_vs_BOST.voom.logFC_-2.txt > statocyst_boids_de.txt
```

### ANALYSIS ON _M. LEIDYI_ TISSUE-SPECIFIC DATA
Tissue-specific transcriptomic data found in the European Nucleotide Archive under project number [PRJEB28334](https://www.ebi.ac.uk/ena/browser/view/PRJEB28334) and [PRJNA787267](https://www.ebi.ac.uk/ena/browser/view/PRJNA787267)

### Transcript quantification
```
/usr/local/trinityrnaseq-v2.12.0/util/align_and_estimate_abundance.pl --transcripts ML2.2.nt --prep_reference --samples_file Ml_samples_file.txt --est_method RSEM --seqType fq --output_dir aea_Ml2 --aln_method bowtie2 --thread_count 40 > aea_Ml2.out 2> aea_Ml2.err
```

### Quality check samples and replicates
```
/usr/local/trinityrnaseq-v2.12.0/util/align_and_estimate_abundance.pl --transcripts ML2.2.nt --prep_reference --samples_file Ml_samples_file.txt --est_method RSEM --seqType fq --output_dir aea_Ml2 --aln_method bowtie2 --thread_count 40 > aea_Ml2.out 2> aea_Ml2.err
/usr/local/trinityrnaseq-Trinity-v2.8.5/Analysis/DifferentialExpression/PtR --matrix ML2.2.isoform.counts.matrix --samples Ml_samples_file2.txt --log2 --CPM --min_rowSums 10 --compare_replicates
```

### Differential gene expression analysis
```
/usr/local/trinityrnaseq-Trinity-v2.8.5/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix ML2.2.isoform.counts.matrix --method voom --samples_file Ml_samples_file2.txt
perl filter_de.pl ML2.2.isoform.counts.matrix.MlCR_vs_MlST.voom.DE_results MlCR_vs_MlST.voom
cut -f1 MlCR_vs_MlST.voom.logFC_-2.txt > statocyst_mlids_de.txt
cut -f1 MlCR_vs_MlST.voom.logFC_2.txt > combrows_mlids_de.txt
```
