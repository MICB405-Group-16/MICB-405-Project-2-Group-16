#Load packages
library(tidyverse)
library(ggplot2)

#Load data
raw_dat <- read_csv('data/Saanich_Data.csv', col_names=TRUE)

#Keep data for at 150m
proj_dat <- raw_dat %>% 
  mutate(Depth_m = Depth * 1000, "N2O (uM)"=Mean_N2O/1000) %>%
  filter(Depth_m == 150) %>%
  dplyr::rename("O2 (uM)"=WS_O2, "NO3 (uM)"=WS_NO3, "H2S (uM)"=WS_H2S, "PO4 (uM)"=WS_PO4, "NH4 (uM)"=Mean_NH4, "NO2 (uM)"=Mean_NO2) %>%
  dplyr::select(Date, Cruise, SI, "O2 (uM)", "PO4 (uM)", "NO3 (uM)", "H2S (uM)", "NH4 (uM)", "NO2 (uM)", Mean_N2, Mean_O2, Mean_co2, "N2O (uM)", Temperature, Salinity, Density)

chemicals_of_interest <- proj_dat %>%
  dplyr::select(Date, "O2 (uM)", "NO3 (uM)", "H2S (uM)", "NH4 (uM)", "NO2 (uM)", "N2O (uM)")

terminal_electron <- chemicals_of_interest %>%
  dplyr::select(Date, "O2 (uM)", "NO3 (uM)", "H2S (uM)")

nitrogen_related_chemicals <- chemicals_of_interest %>%
  dplyr::select(Date, "NO3 (uM)", "NH4 (uM)", "NO2 (uM)", "N2O (uM)") 

cruise_dates_mags <- proj_dat %>%
  filter(Cruise %in% c(42, 48, 72, 74, 75))

#Graph [molecules] vs date
terminal_electron %>% 
  gather(key="Chemical", value="Concentration (uM)", -Date, na.rm=TRUE) %>%
  ggplot() + 
  geom_point(aes(x=Date, y=`Concentration (uM)`, color=Chemical, shape=Chemical)) +
  geom_vline(xintercept=cruise_dates_mags$Date[1:5])

terminal_electron %>%
  arrange(`H2S (uM)`) %>%  
  filter(!is.na(`H2S (uM)`)) %>%
  ggplot() + 
  geom_point(aes(x=`O2 (uM)`, y=`NO3 (uM)`, color=`H2S (uM)`))

nitrogen_related_chemicals %>%
  gather(key="Chemical", value="Concentration (uM)", -Date, na.rm=TRUE) %>%
  ggplot() + 
  geom_point(aes(x=Date, y=`Concentration (uM)`, color=Chemical, shape=Chemical))+
  geom_vline(xintercept=cruise_dates_mags$Date[1:5])
