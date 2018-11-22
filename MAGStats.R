library(tidyverse)
library(ggplot2)

checkm <- read_tsv('0_Initial_Data/Completeness_Contamination/MetaBAT2_SaanichInlet_150m_min1500_checkM_stdout.tsv', col_names=TRUE)
mag_rpkm <- read_csv('0_Initial_Data/Abundance_Data/SaanichInlet_150m_binned.rpkm.csv', col_names=TRUE)
bac_gtdbtk <- read_tsv('0_Initial_Data/Bin_Taxonomy_Classification/gtdbtk.bac120.classification_pplacer.tsv', col_names=FALSE)
ar_gtdbtk <- read_tsv('0_Initial_Data/Bin_Taxonomy_Classification/gtdbtk.ar122.classification_pplacer.tsv', col_names=FALSE)

clean_checkm <- checkm %>%
  separate('Bin Id', c("Location", "Depth.MAG"), sep="_") %>%
  separate('Depth.MAG', c("Depth", "MAG"), sep="\\.") %>%
  mutate(MAG = as.numeric(MAG)) %>%
  select('MAG', 'Marker lineage', 'Completeness', 'Contamination') %>%
  filter(Completeness > 50, Contamination < 10) %>%
  arrange(MAG)

#RPKM file processing

clean_mag_rpkm <- mag_rpkm %>%
  separate('Sequence', c("Location", "Depth", "MAG", "Contig"), sep="_") %>%
  mutate(MAG = as.numeric(MAG)) %>%
  group_by(MAG) %>%
  summarize(Total_RPKM = sum(RPKM)) %>%
  arrange(MAG)

#GTDBTK file processing

clean_bac_gtdbtk <- bac_gtdbtk %>%
  separate('X1', c("Location", "Depth.MAG"), sep="_") %>%
  separate('Depth.MAG', c("Depth", "MAG"), sep="\\.") %>%
  separate('X2', c("Kingdom", "Phylum", "Clade"), sep=";") %>%
  mutate(MAG = as.numeric(MAG)) %>%
  select(MAG, Kingdom, Phylum, Clade)

clean_ar_gtdbtk <- ar_gtdbtk %>%
  separate('X1', c("Location", "Depth.MAG"), sep="_") %>%
  separate('Depth.MAG', c("Depth", "MAG"), sep="\\.") %>%
  separate('X2', c("Kingdom", "Phylum", "Clade"), sep=";") %>%
  mutate(MAG = as.numeric(MAG)) %>%
  select(MAG, Kingdom, Phylum, Clade)

all_gtdbtk <- rbind(clean_bac_gtdbtk, clean_ar_gtdbtk) %>%
  arrange(MAG)

#Join everything together
rpkm_gtdbtk <- inner_join(all_gtdbtk, clean_mag_rpkm, c("MAG"))
full_table <- inner_join(clean_checkm, rpkm_gtdbtk, c("MAG"))

full_table %>%
  ggplot() +
  geom_point(aes(x=Completeness, y=Contamination, color=Kingdom, size=Total_RPKM)) +
  scale_x_continuous(limits=c(0, 100)) 

View(full_table)
