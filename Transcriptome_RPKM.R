si042_rpkm <- read_csv('4_RPKM_Output/SI042_150m_RPKM.csv', col_names=FALSE)
si048_rpkm <- read_csv('4_RPKM_Output/SI048_150m_RPKM.csv', col_names=FALSE)
si072_rpkm <- read_csv('4_RPKM_Output/SI072_150m_RPKM.csv', col_names=FALSE)
si074_rpkm <- read_csv('4_RPKM_Output/SI074_150m_RPKM.csv', col_names=FALSE)
si075_rpkm <- read_csv('4_RPKM_Output/SI075_150m_RPKM.csv', col_names=FALSE)

clean_rpkm_data <- function(dataframe, cruise_name){
  clean_data <- dataframe %>%
    mutate(Cruise = cruise_name) %>%
    rename(ID=X1, RPKM=X2)
  return(clean_data)
}

clean_rpkm_data(si042_rpkm, "SI042") %>%
  View()

clean_rpkm_data(si048_rpkm, "SI048") %>%
  View()

clean_rpkm_data(si072_rpkm, "SI072") %>%
  View()

clean_rpkm_data(si074_rpkm, "SI074") %>%
  View()

clean_rpkm_data(si075_rpkm, "SI075") %>%
  View()