# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: fun facts about fish ticket data
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")


d0<-read_csv("./data/trip_tix_ca_with_groups.csv")%>%
  select(SpeciesName,species_id=SpeciesID,SpeciesGroup)%>%
  mutate(species_group2=SpeciesGroup)%>%
  mutate(species_group2=
           if_else(species_group2=="Urchin","Invertebrate",
           if_else(species_group2=="Spiny Lobsters","Invertebrate",
           if_else(species_group2=="Squid","Invertebrate",
           if_else(species_group2=="Prawn and Shrimp","Invertebrate",
           if_else(species_group2=="Crab","Invertebrate",
           if_else(species_group2=="Shellfish","Invertebrate",
           if_else(species_group2=="Sea Cucumber","Invertebrate",
           if_else(species_group2=="Mollusk","Invertebrate",
           if_else(species_group2=="All Other","All Other",
           "Fish"))))))))))%>%
  unique()%>%
  glimpse()

# d0%>%filter(SpeciesGroup=="All Other")%>%view()

d1<-read_csv("./data/dsc_val_associations_freshwater.csv")%>%
  glimpse()

d2<-read_csv("./data/fishtix_2010_2020.csv ")%>% #or from dsc_val results folder ./data/trip_tix_ca_with_groups.csv
  mutate(species_id=SpeciesID)%>%
  glimpse()

d3<-read_csv("./doc/species_list_2010_2020.csv")%>%
  mutate(species_id=SpeciesID)%>%
  glimpse()

# create list for All Other species to separate invert and algae from fish
#list does not include freshwater inverts which are filtered out below
species<-tibble(c(821,683,811,712,686,899,682,687,823,688,814,817,681,7098,689,685,699,830,680,850,689,840,818,816,758,759,829))%>%
  mutate(species_group3="Invertebrate")%>%
    glimpse()
names(species)<-c("species_id","species_group3")
species

# join new species groups
d00<-d0%>%
  left_join(species)%>%
  arrange(species_id)%>%
  glimpse()

d00$species_group2[d00$species_group3=="Invertebrate"]<-"Invertebrate"
d00$species_group2[d00$species_id==953]<-"Algae"
d00$species_group2[d00$species_id==951]<-"Algae"
d00$species_group2[d00$species_id==950]<-"Algae"
d00$species_group2[d00$species_group2=="All Other"]<-"Fish"

d00<-d00%>%select(-species_group3)%>%
  glimpse()

# join freshwater and new species list
d4<-d3%>%
  full_join(d1)%>%
  arrange(species_id)%>%
  unique()%>%
  select(species_id,freshwater)%>%
  glimpse()

# number of freshwater species
fresh_n<-d4%>%
  filter(freshwater==1)%>%
  summarize(fresh_n=length(unique(species_id)))%>%
  glimpse()

# join freshwater and fishtix to remove freshwater spp
d5<-d4%>%
  right_join(d2)%>%
  filter(freshwater!=1)%>%
  glimpse()

nrow(d5)

# join to add species groups
d6<-d5%>%
  left_join(d00)%>%
  glimpse()

# species counts
d7<-d6%>%
  group_by(SpeciesName)%>%
  summarize(species_count=n())%>%
  arrange(-species_count)%>%
  glimpse()
d7

range(d7$species_count, na.rm=T)

# counts by species groups
d8<-d6%>%
  group_by(SpeciesGroup)%>%
  summarize(species_group_count=n())%>%
  arrange(-species_group_count)%>%
  glimpse()
d8
# view(d8)

# coarser groups
d9<-d6%>%
  group_by(species_group2)%>%
  summarize(species_group_count=n())%>%
  glimpse()

write_csv(d7, "./doc/species_count_2010-2020.csv")
write_csv(d8, "./doc/species_group_count_2010-2020.csv")
write_csv(d9, "./doc/species_group2_count_2010-2020.csv")
write_csv(d00,"./results/data_species_group2.csv")
