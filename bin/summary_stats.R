# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: fun facts about association data - summary stats
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")


d1<-read_csv("./doc/association_fun_facts2.csv")%>%
  arrange(group)%>%
  mutate(assoc_general_n=assoc_prox_n)%>%
  mutate(assoc_adjacent_n=assoc_body_n)%>%
  select(-assoc_body_n)%>%
  glimpse()
d1

# adjacent (body) and general (prox) -----------------------------
d2_b<-d1%>%
  select(group,association,assoc_adjacent_n,assoc_general_n)%>%
  # filter(association!="Multispecies Group")%>%
  filter(association!="Definite Association" & association!="Probable Association")%>%
  arrange(group)%>%
  glimpse()
d2_b


# total no species 
d3_b<-d2_b%>%
  group_by(group)%>%
  summarize(
    taxa_n=sum(assoc_general_n))%>% # same for body and prox
  glimpse()


# calculate percentages   
d4_b<-full_join(d2_b,d3_b)%>%
  mutate(assoc_adjacent_p=round(assoc_adjacent_n/taxa_n,3))%>%
  mutate(assoc_general_p=round(assoc_general_n/taxa_n,3))%>%
  glimpse()

# totals
d5_b<-d4_b%>%
  group_by(association)%>%
 summarize(
   assoc_adjacent_n=sum(assoc_adjacent_n),
   assoc_general_n=sum(assoc_general_n),
   taxa_n=sum(taxa_n))%>%
  mutate(assoc_adjacent_p=round(assoc_adjacent_n/taxa_n,3))%>%
  mutate(assoc_general_p=round(assoc_general_n/taxa_n,3))%>%
  mutate(group="all")%>%
  glimpse()

# combine
d6_b<-d5_b%>%
  select(group,association:assoc_general_p)%>%
  rbind(d4_b)%>%
  glimpse()



# habtiat -----------------------------
d2_h<-d1%>%
  select(group,association,assoc_hab_n)%>%
  # filter(association!="Multispecies Group")%>%
  filter(association!="Associated"& association!="No Data")%>%
  arrange(group)%>%
  glimpse()
d2_h


# total no species 
d3_h<-d2_h%>%
  group_by(group)%>%
  summarize(
    taxa_n=sum(assoc_hab_n))%>% # same for adjacent and prox
  glimpse()


# calculate percentages   
d4_h<-full_join(d2_h,d3_h)%>%
  mutate(assoc_hab_p=round(assoc_hab_n/taxa_n,3))%>%
  glimpse()

# totals
d5_h<-d4_h%>%
  group_by(association)%>%
  summarize(
    assoc_hab_n=sum(assoc_hab_n),
    taxa_n=sum(taxa_n))%>%
  mutate(assoc_hab_p=round(assoc_hab_n/taxa_n,3))%>%
  mutate(group="all")%>%
  glimpse()

# combine
d6_h<-d5_h%>%
  select(group,association:assoc_hab_p)%>%
  rbind(d4_h)%>%
  glimpse()


# save
write_csv(d4_b,"./doc/assoc_bl_prox.csv")
write_csv(d6_b,"./doc/assoc_bl_prox_all.csv")
write_csv(d4_h,"./doc/assoc_hab.csv")
write_csv(d6_h,"./doc/assoc_hab_all.csv")


