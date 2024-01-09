library(macrosyntR)
setwd("~/Dropbox/Ryan_Postdoc/Paper/Revisions/macrosynteny")
my_orthologs_table<-load_orthologs(orthologs_table = "Bova_Hcal.tab", sp1_bed = "Bova1.5.gene.bed", sp2_bed = "Hcv1av93.gene.bed")
macrosynteny_df <- compute_macrosynteny(my_orthologs_table)
plot_oxford_grid(my_orthologs_table,
                 sp1_label = "B.ovata",
                 sp2_label = "H.californensis")
