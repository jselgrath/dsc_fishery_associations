# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: remove freshwater etc sp landed  by commercial fisheries in ca 2010-2020

# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")


#freshwater assoc
d0<-read_csv("./data/dsc_val_associations_freshwater2.csv")%>%
  glimpse()

# fisheries data
d1<-read_csv("./results/gear_fishtix_spp_2010_2024.csv")%>%
  glimpse()

#remove freshwater spp
d2<-d0%>%
  inner_join(d1,relationship = "many-to-many")%>%
  filter(freshwater==0)%>%
  select(-freshwater)%>%
  #   # # remove algae
  filter(species_name!="Agar"& species_name!="Algae marine" & species_name!="Kelp giant")%>%
  #   # #remove roe
  filter(species_name!="Herring Pacific - roe"& species_name!="Herring Pacific - roe on kelp"&  species_name!="Salmon Roe (Chinook Coho)" )%>%
  # for figuring out what is joining
  glimpse()

write_csv(d2,"./results/gear_fishtix_spp_2010_2024_no_fresh.csv")
