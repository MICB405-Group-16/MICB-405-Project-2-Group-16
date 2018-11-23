library(tidyverse)
library(ggplot2)

si042_rpkm <- read_csv('4_RPKM_Output/SI042_150m_RPKM.csv', col_names=FALSE)
si048_rpkm <- read_csv('4_RPKM_Output/SI048_150m_RPKM.csv', col_names=FALSE)
si072_rpkm <- read_csv('4_RPKM_Output/SI072_150m_RPKM.csv', col_names=FALSE)
si074_rpkm <- read_csv('4_RPKM_Output/SI074_150m_RPKM.csv', col_names=FALSE)
si075_rpkm <- read_csv('4_RPKM_Output/SI075_150m_RPKM.csv', col_names=FALSE)
prokka_tsv <- read_tsv('2_Concatenated_Prokka_Output/all_tsvs.tsv', col_names=TRUE)
prokka_mag_ref <- read_csv('2_Concatenated_Prokka_Output/mag_prokka_ref.csv', col_names=TRUE)

clean_rpkm_data <- function(dataframe, cruise_name){
  clean_data <- dataframe %>%
    mutate(Cruise = cruise_name) %>%
    rename(ID=X1, RPKM=X2) %>%
    inner_join(prokka_tsv, c("ID" = "locus_tag")) %>%
    separate("ID", c("MAG_ID", "ORF_ID"), sep="_") %>%
    inner_join(prokka_mag_ref, c("MAG_ID"))
  return(clean_data)
}

full_table <- bind_rows(clean_rpkm_data(si042_rpkm, "SI042"),
          clean_rpkm_data(si048_rpkm, "SI048"),
          clean_rpkm_data(si072_rpkm, "SI072"),
          clean_rpkm_data(si074_rpkm, "SI074"),
          clean_rpkm_data(si075_rpkm, "SI075"))

full_table %>%
  select(MAG_ID, ORF_ID, RPKM, Cruise, ftype, length_bp, gene, product, MAG_NUM) %>%
  filter(RPKM > 0) %>%
  View()
