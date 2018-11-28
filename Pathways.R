library(tidyverse)
library(ggplot2)

assim_no3 <- read_csv('7_Pathways/Assimilatory_Nitrate_Reduction.csv', col_names=TRUE)
dissim_no3 <- read_csv('7_Pathways/Dissimilatory_Nitrate_Reduction.csv', col_names=TRUE)
denitrification <- read_csv('7_Pathways/Denitrification.csv', col_names=TRUE)
nitrification <- read_csv('7_Pathways/Nitrification.csv', col_names=TRUE)
assim_so4 <- read_csv('7_Pathways/Assimilatory_Sulfate_Reduction.csv', col_names=TRUE)

plot_pathway <- function(csv){
  csv$Class <- factor(csv$Class, levels = csv$Class)
  return(csv %>%
           gather(key = "Step", value = "Expressed", -Class) %>%
           ggplot() +
           geom_point(aes(x=Step, y=Class, size=Expressed, color=Class), show.legend = FALSE) +
           scale_size(range=c(-1, 5)) +
           theme(panel.background = element_blank(),
                 panel.grid.major = element_line(colour = "#bdbdbd", linetype = "solid"),
                 panel.grid.minor = element_blank()) + 
           coord_fixed(ratio = 0.15))
}

plot_pathway(assim_no3)
plot_pathway(dissim_no3)
plot_pathway(denitrification)
plot_pathway(nitrification)
plot_pathway(assim_so4)