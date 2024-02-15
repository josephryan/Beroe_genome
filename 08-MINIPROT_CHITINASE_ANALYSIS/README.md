# Command and file to run miniprot analysis for chitinase

### Chitinase file
* chitinase.faa - contains chitinase amino acid sequences from _Mnemiopsis leidyi_ and _Hormiphora californensis_

### Custom scripts
* get_seq_from_fasta.pl - custom script that extracts FASTA sequences with a pattern in defline (available in [JFR-PerlModules](https://github.com/josephryan/JFR-PerlModules))  

* fdgxdxdxe_in_genome.pl - custom script that translates FASTA sequences in 6 frames and searches for chitinase catalytic site (FDG(X)DXDXE)

### Commands to perform analysis

* miniprot analysis

```bash
miniprot Bova1.5.fa chitinase.faa -t 24 --aln -I > chitinase_bova.paf
get_seq_from_fasta.pl Bova1.5.fa Bova1_5.1697 > Bova1_5.1697.fa
```

* perl regular expression search for chitinase catalytic site in translated genome

```bash
fdgxdxdxe_in_genome.pl Bova1.5.fa
```  
