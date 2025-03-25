# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: table S1
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

#data
d1<-read_csv("./results/association_long.csv")%>%
  glimpse()

# reference info
d4<-read_csv("./data/table_S1_fishtix_assoc_20240724.csv")%>%
  select(species_name:association_references)%>%
  select(-depth_range)%>%
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


glimpse(d4)

d5<-d1%>%
  left_join(d4)%>%
  arrange(Group,species_name,common_name)%>%
  select(Group,"Common Name" ="common_name",Genus=genus,Species=species,"Min Depth (m)"= "depth_range_shallow_m", "Max Depth (m)"=depth_range_deep_m, "Body Length"="assoc_body_length2", "Proximity"="assoc_proximity2","Habitat and Depth"=assoc_hab,Habitat=habitat, References="association_references")%>%
  glimpse()
d5

# save
write_csv(d5,"./doc/table_s1.csv") # note: will need to manually fix some depths due to excel errors
write_csv(d3,"./doc/table_1.csv")
