# Commands and custom scripts used for Beroe genome annotation

* annotate_commands.md - commands used to annotate Beroe genome

* replace_deflines.pl - script to update definition lines. Available through [JFR-PerlModules GitHub repo](https://github.com/josephryan/JFR-PerlModules)

* sort_fasta_by_size.pl - script to sort sequences by length (requires [JFR-PerlModules](https://github.com/josephryan/JFR-PerlModules))

* finalize_gff_names.pl - script to create new standardized GFF file with appropriate gene names

* translate_cds.pl - script to translate and identify sequences with fewest stop codons (requires [JFR-PerlModules](https://github.com/josephryan/JFR-PerlModules))

* identify_seqs_w_stops.pl - script that identifies sequences with stop codons

* count_missed_genes.pl - script that identifies candidate missed gene predictions (dependencies include TransDecoder v.3.0.1, diamond v0.9.22.123, BLAT v.35x1, and [blat2gff.pl](http://arthropods.eugenes.org/EvidentialGene/evigene/scripts/))

* extract_transcript_blocks.pl - script that was used to produce a new GFF file that included missing gene predictions
