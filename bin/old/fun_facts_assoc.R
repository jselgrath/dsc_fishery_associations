# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: fun facts about association data
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_valuation_association/")


d1<-read_csv("./data/dsc_val_associations_clean_20240214.csv")%>%
  filter(freshwater==0)%>%
  select(-freshwater,-association_references)%>%
  glimpse()

length(unique(d1$species_id)) # 3 duplicates because 3 grenadier spp have 1 species_id (198)

# species group info
d2<-read_csv("./results/data_species_group2.csv")%>%
  select(-SpeciesName)%>%
  glimpse()

# join species group info to association info
d3<-d1%>%
  left_join(d2)%>%
  unique()%>%
  glimpse()

d3$assoc_habitat[d3$assoc_habitat=="?"]<-999
d3$assoc_habitat<-as.numeric(d3$assoc_habitat)

# summarize -----------------------
d4<-d3%>%
  group_by(assoc_body_length,species_group2)%>%
  summarize(
    assoc_body_n=n())%>%
  mutate(association=assoc_body_length)%>%
  ungroup()%>%
  select(-assoc_body_length)%>%
  glimpse()

d5<-d3%>%
  group_by(assoc_proximity,species_group2)%>%
  summarize(
    assoc_prox_n=n())%>%
  mutate(association=assoc_proximity)%>%
  ungroup()%>%
  select(-assoc_proximity)%>%
  glimpse()

d6<-d3%>%
  group_by(assoc_habitat,species_group2)%>%
  summarize(
    assoc_hab_n=n())%>%
  mutate(association=assoc_habitat)%>%
  ungroup()%>%
  select(-assoc_habitat)%>%
  glimpse()

# merge
d7<-d4%>%
  full_join(d5)%>%
  full_join(d6)%>%
  select(species_group2,association,assoc_body_n,assoc_prox_n,assoc_hab_n)%>%
  glimpse()

d7

write_csv(d7,"./doc/association_fun_facts.csv")
