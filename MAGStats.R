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
  dplyr::select('MAG', 'Marker lineage', 'Completeness', 'Contamination') %>%
  mutate(Quality = case_when(Completeness>90 & Contamination < 5 ~ "High",
                              Completeness>50 & Contamination < 10 ~ "Medium",
                             TRUE ~ "Low")) %>%
  arrange(MAG)

#RPKM file processing

clean_mag_rpkm <- mag_rpkm %>%
  separate('Sequence', c("Location", "Depth", "MAG", "Contig"), sep="_") %>%
  separate('Sample', c("Cruise", "Depth_Sample"), sep="_") %>%
  mutate(MAG = as.numeric(MAG)) %>%
  group_by(Cruise, MAG) %>%
  summarize(Total_RPKM_By_Cruise = sum(RPKM)) %>%
  group_by(MAG) %>%
  summarize(Mean_RPKM_By_Cruise = mean(Total_RPKM_By_Cruise)) %>%
  arrange(MAG)

#GTDBTK file processing

process_gtdbtk_file <- function(dataframe){
  processed_data <- dataframe %>%
    separate('X1', c("Location", "Depth.MAG"), sep="_") %>%
    separate('Depth.MAG', c("Depth", "MAG"), sep="\\.") %>%
    separate('X2', c("Kingdom", "Phylum", "Class"), sep=";") %>%
    separate('Phylum', c("prefix_p", "Phylum"), sep="__") %>%
    separate('Kingdom', c("prefix_k", "Kingdom"), sep="__") %>%
    separate('Class', c("prefix_c", "Class"), sep="__") %>%
    mutate(MAG = as.numeric(MAG)) %>%
    dplyr::select(MAG, Kingdom, Phylum, Class)
  return(processed_data)
}

clean_bac_gtdbtk <- process_gtdbtk_file(bac_gtdbtk)

clean_ar_gtdbtk <- process_gtdbtk_file(ar_gtdbtk)

all_gtdbtk <- rbind(clean_bac_gtdbtk, clean_ar_gtdbtk) %>%
  arrange(MAG)

#Join everything together
rpkm_gtdbtk <- left_join(clean_mag_rpkm, all_gtdbtk, c("MAG"))
full_table <- left_join(clean_checkm, rpkm_gtdbtk, c("MAG")) %>%
  arrange(Kingdom, Phylum, Class)

full_table %>%
  ggplot() +
  geom_point(aes(x=Completeness, y=Contamination, color=Phylum, size=Mean_RPKM_By_Cruise, shape=Quality)) +
  scale_x_continuous(limits=c(0, 100)) +
  scale_y_continuous(limits=c(0, 30)) + 
  scale_size(range=c(1, 6))+
  theme(legend.key.size = unit(0, 'lines'))

View(full_table)

quality_filtered <- full_table %>% 
  filter(Quality == "Medium" | Quality == "High")

#Phylum wide MAG count and RPKM total
aggregate_by_class <- quality_filtered %>%
  group_by(Class) %>%
  summarize(MAG_Count = n(), Total_Mean_RPKM = sum(Mean_RPKM_By_Cruise))

aggregate_by_class %>%
  ggplot() + 
  geom_point(aes(x=Class, y=MAG_Count, size=Total_Mean_RPKM)) +
  theme(panel.background = element_blank(),
        panel.grid.major = element_line(colour = "#bdbdbd", linetype = "dotted"),
        panel.grid.minor = element_blank(),
        axis.title.y = element_text(angle = 0),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1))

#Average Completeness/Contamination by Class
avg_mag_stats_by_class <- quality_filtered %>%
  group_by(Class) %>%
  summarize(Completeness=mean(Completeness), Contamination=mean(Contamination)) %>%
  gather(key="Metric", value="Percentage", -Class) 

avg_mag_stats_by_class %>%
  ggplot(aes(Class, Percentage)) +
  geom_bar(aes(fill=Metric), position = position_dodge(width=0.5), stat="identity") +
  theme(panel.background = element_blank(),
        panel.grid.major = element_line(colour = "#bdbdbd", linetype = "dotted"),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 60,
                                   hjust = 1))
