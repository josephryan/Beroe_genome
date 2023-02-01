# Commands, sample files, and custom script for differential gene expression analysis

* dge_commands.md - commands to perform differential gene expression analysis

#### Most scripts require [JFR-PerlModules](https://github.com/josephryan/JFR-PerlModules)

* Bo_samples_file.txt - sample file for input for transcript quantification of _Beroe ovata_ tissue-specific data

* Bo_samples_file2.txt - sample file for input for quality check and differential gene expression analysis of _Beroe ovata_ tissue-specific data

* Ml_samples_file.txt - sample file for input for transcript quantification of _Menmiopsis leidyi_ tissue-specific data

* Ml_samples_file2.txt - sample file for input for quality check and differential gene expression analysis of _Mnemiopsis leidyi_ tissue-specific data

* print_total-1_to_1s.pl - custom script that combines single-copy orthologs identified in OrthoFinder

* ogs_w_4plus_taxa_mafft_iqtree.pl - custom script that performs maximum-likelihood analyses on orthogroups with 4 or more genes

* print_isoforms_blocking_one_to_ones.pl - custom script that discards conflicting single-copy orthologs from different analyses

* get_final_set.pl - custom script that combines single-orthologs identified from several analyses

* filter_de.pl - custom script that identifies genes expressed significantly higher in one tissue compared to another 
