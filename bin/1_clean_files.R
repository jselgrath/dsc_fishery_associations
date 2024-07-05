# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: driver for association data
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# ---------------------------------------
#all data
d1<-read_csv("./data/fishtix_assoc_20240520.csv")%>% 
   select(species_name:assoc_proximity,assoc_habitat=assoc_hab,habitat=habitat...13, association_references, habitat_reference,freshwater)%>%
  glimpse()

# no freshwater
d2<-d1%>% 
  filter(freshwater==0)%>%
  select(-freshwater)%>%
  glimpse()


write_csv(d1,"./results/fishtix_assoc_clean.csv")
write_csv(d2,"./results/fishtix_assoc_clean_no_fresh.csv")

