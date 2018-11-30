library(tidyverse)
library(ggplot2)

checkm <- read_tsv('0_Initial_Data/Completeness_Contamination/MetaBAT2_SaanichInlet_150m_min1500_checkM_stdout.tsv', col_names=TRUE)
mag_rpkm <- read_csv('0_Initial_Data/Abundance_Data/SaanichInlet_150m_binned.rpkm.csv', col_names=TRUE)
bac_gtdbtk <- read_tsv('0_Initial_Data/Bin_Taxonomy_Classification/gtdbtk.bac120.classification_pplacer.tsv', col_names=FALSE)
ar_gtdbtk <- read_tsv('0_Initial_Data/Bin_Taxonomy_Classification/gtdbtk.ar122.classification_pplacer.tsv', col_names=FALSE)
ar_genes <- read_tsv('2_Concatenated_Prokka_Output/all_tsvs.tsv') # has: LOCUS_Tag(MAG_ID) and Product
mag_ref_table <- read_csv('2_Concatenated_Prokka_Output/mag_prokka_ref.csv') #has: MAG_Id  and MAG_NUM

all_complete_rRNA<- ar_genes%>%
  select(locus_tag, product)%>%
  filter(product== "16S ribosomal RNA" | product == "16S ribosomal RNA (partial)")%>%
  separate(locus_tag, c("MAG_ID", "Number"), "_") %>%
  select(MAG_ID, product) %>%
  inner_join(mag_ref_table, by=c("MAG_ID")) %>%
  group_by(MAG_NUM) %>%
  summarize("RRNA_Marker_Count"=n())

all_complete_ORF_count <- ar_genes %>%
  select(locus_tag, product)%>%
  separate(locus_tag, c("MAG_ID", "Number"), "_") %>%
  inner_join(mag_ref_table, by=c("MAG_ID")) %>%
  group_by(MAG_NUM) %>%
  summarize("ORF_Count"=n())

total_stats <- all_complete_ORF_count %>%
  left_join(all_complete_rRNA, by=c("MAG_NUM")) %>%
  mutate("RRNA_Marker_Count" = ifelse(is.na(RRNA_Marker_Count) == TRUE, 0, RRNA_Marker_Count))

with_16s_marker <- total_stats %>%
  filter(RRNA_Marker_Count > 0) %>%
  nrow()
