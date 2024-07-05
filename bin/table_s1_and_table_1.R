# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: table S1
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")


d1<-read_csv("./results/association_long.csv")%>%
  glimpse()

# Table S1
d2<-d1%>%
  select(group=Group                 ,common_name,genus,species,depth_range,habitat,assoc_body_length2,assoc_proximity2,assoc_habitat2)%>%
  arrange(common_name)%>%
  glimpse()

# Table 1
d3<-d2%>%
  filter(common_name=="Armed Box Crab"| common_name=="Bronzespotted Rockfish"| common_name=="California King Crab" | common_name=="California Grenadier"| common_name=="California Scorpionfish"|  common_name=="Curlfin Sole"| common_name=="Pink Rockfish"| common_name=="Red Rock Shrimp"| common_name== "Slender Sole")%>%
  glimpse()
d3


# examples of species with unknown associations (no Data) ----------------------------
d2%>%
  filter(group=="Invertebrate" & assoc_proximity2=="No Data")

d2%>%
  filter(group=="Fish" & assoc_proximity2=="No Data")

d2%>%
  filter(group=="Fish" & assoc_body_length2=="No Data"& assoc_proximity2=="Associated")


# save
write_csv(d2,"./doc/table_s1.csv")
write_csv(d3,"./doc/table_1.csv")
