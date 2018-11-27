library(tidyverse)
library(ggplot2)
library(pathview)

si042_rpkm <- read_csv('4_RPKM_Output/SI042_150m_RPKM.csv', col_names=c("ID", "RPKM"))
si048_rpkm <- read_csv('4_RPKM_Output/SI048_150m_RPKM.csv', col_names=c("ID", "RPKM"))
si072_rpkm <- read_csv('4_RPKM_Output/SI072_150m_RPKM.csv', col_names=c("ID", "RPKM"))
si074_rpkm <- read_csv('4_RPKM_Output/SI074_150m_RPKM.csv', col_names=c("ID", "RPKM"))
si075_rpkm <- read_csv('4_RPKM_Output/SI075_150m_RPKM.csv', col_names=c("ID", "RPKM"))
prokka_tsv <- read_tsv('2_Concatenated_Prokka_Output/all_tsvs.tsv', col_names=TRUE)
prokka_mag_ref <- read_csv('2_Concatenated_Prokka_Output/mag_prokka_ref.csv', col_names=TRUE)
kegg <- read_tsv('5_KEGG_Output/query.ko', col_names=c("ID", "KO"))
bac_gtdbtk <- read_tsv('0_Initial_Data/Bin_Taxonomy_Classification/gtdbtk.bac120.classification_pplacer.tsv', col_names=FALSE)
ar_gtdbtk <- read_tsv('0_Initial_Data/Bin_Taxonomy_Classification/gtdbtk.ar122.classification_pplacer.tsv', col_names=FALSE)

clean_rpkm_data <- function(dataframe, cruise_name){
  clean_data <- dataframe %>%
    mutate(Cruise=cruise_name) %>%
    inner_join(prokka_tsv, c("ID"="locus_tag")) %>%
    separate("ID", c("MAG_ID", "ORF_ID"), sep="_") %>%
    inner_join(prokka_mag_ref, c("MAG_ID"))
  return(clean_data)
}

process_gtdbtk_file <- function(dataframe){
  processed_data <- dataframe %>%
    separate('X1', c("Location", "Depth.MAG"), sep="_") %>%
    separate('Depth.MAG', c("Depth", "MAG"), sep="\\.") %>%
    separate('X2', into=c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"), sep=";") %>%
    mutate(MAG = as.numeric(MAG))
  return(processed_data)
}

clean_bac_gtdbtk <- process_gtdbtk_file(bac_gtdbtk)

clean_ar_gtdbtk <- process_gtdbtk_file(ar_gtdbtk)

#Final Files
clean_kegg <- kegg %>%
  separate("ID", c("MAG_ID", "ORF_ID"), sep="_") %>%
  filter(!is.na(KO))


all_gtdbtk <- rbind(clean_bac_gtdbtk, clean_ar_gtdbtk) %>%
  arrange(MAG)

full_table <- bind_rows(clean_rpkm_data(si042_rpkm, "SI042"),
          clean_rpkm_data(si048_rpkm, "SI048"),
          clean_rpkm_data(si072_rpkm, "SI072"),
          clean_rpkm_data(si074_rpkm, "SI074"),
          clean_rpkm_data(si075_rpkm, "SI075")) %>%
  dplyr::select(MAG_ID, ORF_ID, RPKM, Cruise, ftype, length_bp, gene, product, MAG_NUM) %>%
  filter(RPKM > 0)

ultimate_table <- full_table %>%
  inner_join(all_gtdbtk, c("MAG_NUM" = "MAG")) %>%
  inner_join(clean_kegg, c("MAG_ID" = "MAG_ID", "ORF_ID" = "ORF_ID"))

ultimate_table %>% View()

rpkm_by_cruise_and_ko <- ultimate_table %>%
  filter(Phylum == "p__Micrarchaeota") %>%
  group_by(MAG_NUM, KO) %>%
  summarize(total_RPKM = sum(RPKM)) %>%
  spread(key = MAG_NUM, value = total_RPKM)

pv_mat <- dplyr::select(rpkm_by_cruise_and_ko, -KO)
pv_mat <- pv_mat %>% 
  rowwise() %>% 
  do( (.) %>% 
        as.data.frame %>% 
        mutate(sum = sum(., na.rm = TRUE)) ) %>% 
  dplyr::select(sum)
rownames(pv_mat) <- rpkm_by_cruise_and_ko$KO

#sulfur = 00920
#nitrogen = 00910
#carbon = 01200
pv.out <- pathview(gene.data = pv_mat,
                   species = "ko",
                   pathway.id="00920",
                   kegg.dir = "6_Pathview/")
  