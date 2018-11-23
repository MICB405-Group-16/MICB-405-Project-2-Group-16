#Load packages
library(tidyverse)
library(ggplot2)

#Load data
raw_dat <- read_csv('data/Saanich_Data.csv', col_names=TRUE)

#Keep data for at 150m
proj_dat <- raw_dat %>% 
  mutate(Depth_m = Depth * 1000) %>%
  filter(Depth_m == 150) %>%
  rename(O2_uM=WS_O2, NO3_uM=WS_NO3, H2S_uM=WS_H2S, PO4_uM=WS_PO4) %>%
  select(Date, SI, O2_uM, PO4_uM, NO3_uM, H2S_uM, Mean_NH4, Mean_NO2, Mean_N2, Mean_O2, Mean_co2, Mean_N2O, Mean_CH4, Temperature, Salinity, Density)

chemicals_of_interest <- proj_dat %>%
  select(Date, O2_uM, NO3_uM, H2S_uM) %>%
  gather(key="Chemical", value="Concentration_uM", -Date, na.rm=TRUE)

#Graph [molecules] vs date
chemicals_of_interest %>% 
  ggplot() + 
  geom_point(aes(x=Date, y=Concentration_uM, color=Chemical, shape=Chemical))
