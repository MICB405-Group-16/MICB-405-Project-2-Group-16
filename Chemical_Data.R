#Load packages
library(tidyverse)
library(ggplot2)

#Load data
raw_dat <- read_csv('data/Saanich_Data.csv', col_names=TRUE)

#Keep data for at 150m
proj_dat <- raw_dat %>% 
  mutate(Depth_m = Depth * 1000) %>%
  filter(Depth_m == 150) %>%
  dplyr::rename(O2_uM=WS_O2, NO3_uM=WS_NO3, H2S_uM=WS_H2S, PO4_uM=WS_PO4, NH4_uM=Mean_NH4, NO2_uM=Mean_NO2, N2O_uM=Mean_N2O) %>%
  dplyr::select(Date, Cruise, SI, O2_uM, PO4_uM, NO3_uM, H2S_uM, NH4_uM, NO2_uM, Mean_N2, Mean_O2, Mean_co2, N2O_uM, Mean_CH4, Temperature, Salinity, Density)

chemicals_of_interest <- proj_dat %>%
  dplyr::select(Date, O2_uM, NO3_uM, H2S_uM, NH4_uM, NO2_uM, N2O_uM)

cruise_dates_mags <- proj_dat %>%
  filter(Cruise %in% c(42, 48, 72, 74, 75))

#Graph [molecules] vs date
chemicals_of_interest %>% 
  gather(key="Chemical", value="Concentration_uM", -Date, na.rm=TRUE) %>%
  ggplot() + 
  geom_point(aes(x=Date, y=Concentration_uM, color=Chemical, shape=Chemical)) +
  geom_vline(xintercept=cruise_dates_mags$Date[1:5])

chemicals_of_interest %>%
  arrange(H2S_uM) %>%  
  filter(!is.na(H2S_uM)) %>%
  ggplot() + 
  geom_point(aes(x=O2_uM, y=NO3_uM, color=H2S_uM))

nitrogen_related_chemicals <- chemicals_of_interest %>%
  dplyr::select(Date, NO3_uM, NH4_uM, NO2_uM, N2O_uM) 

nitrogen_related_chemicals %>%
  gather(key="Chemical", value="Concentration_uM", -Date, na.rm=TRUE) %>%
  ggplot() + 
  geom_point(aes(x=Date, y=Concentration_uM, color=Chemical, shape=Chemical))+
  geom_vline(xintercept=cruise_dates_mags$Date[1:5])
