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

View(proj_dat)

#Graph [molecules] vs date
proj_dat %>% 
  ggplot() + 
  geom_point(aes(x=Date, y= O2_uM)) +
  scale_y_continuous(limits=c(0, 40)) 

proj_dat %>% 
  ggplot() + 
  geom_point(aes(x=Date, y= NO3_uM)) +
  scale_y_continuous(limits=c(0, 40)) 

proj_dat %>% 
  ggplot() + 
  geom_point(aes(x=Date, y= H2S_uM)) +
  scale_y_continuous(limits=c(0, 40)) 
