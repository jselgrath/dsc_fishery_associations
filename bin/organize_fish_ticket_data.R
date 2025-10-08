# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: summarize landing records by species group
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# ---------------------------------------
#freshwater assoc
d0<-read_csv("./data/dsc_val_associations_freshwater2.csv")%>%
  glimpse()

# d0%>%
#   filter(species_id==180)


# final assoc table - updated with 2024 data 
d1<-read_csv("./results/fishtix_spp_2010_2024_landing_no.csv")%>% #table_s1_20250325
  mutate(new="new")%>%
  glimpse()

d2<-d1%>%
  group_by(species_id, species_name,new)%>%
  summarize(
    n_landings=n())%>%
  arrange(species_name)%>%
  glimpse()

d2

# d2%>%
#   filter(species_id==180)


#remove freshwater spp
d3<-d0%>%
  inner_join(d2,relationship = "many-to-many")%>%
    filter(freshwater==0)%>%
    select(-freshwater)%>%
  #   # # remove algae
  filter(species_name!="Agar"& species_name!="Algae marine" & species_name!="Kelp giant")%>%
  #   # #remove roe
  filter(species_name!="Herring Pacific - roe"& species_name!="Herring Pacific - roe on kelp"&  species_name!="Salmon Roe (Chinook Coho)" )%>%
  # for figuring out what is joining
  glimpse()


# d3%>%
#   filter(species_id==453)

# -----------------
write_csv(d3,"./results/lc_record_no.csv")
