# Command and file to run miniprot analysis for chitinase

### Chitinase file
* chitinase.faa - contains chitinase amino acid sequences from _Mnemiopsis leidyi_ and _Hormiphora californensis_

### Custom script
* get_seq_from_fasta.pl - custom script that extracts FASTA sequences with a pattern in defline (available in [JFR-PerlModules](https://github.com/josephryan/JFR-PerlModules))  

### Commands to perform analysis
```
miniprot Bova1.5.fa chitinase.faa -t 24 --aln -I > chitinase_bova.paf
get_seq_from_fasta.pl Bova1.5.fa Bova1_5.1697 > Bova1_5.1697.fa
```
