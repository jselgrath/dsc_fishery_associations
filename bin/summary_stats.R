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
  glimpse()
d1

# body  length and prox -----------------------------
d2_b<-d1%>%
  select(group,association,assoc_body_n,assoc_prox_n)%>%
  # filter(association!="Multispecies Group")%>%
  filter(association!="Definite Association" & association!="Probable Association")%>%
  arrange(group)%>%
  glimpse()
d2_b


# total no species 
d3_b<-d2_b%>%
  group_by(group)%>%
  summarize(
    taxa_n=sum(assoc_prox_n))%>% # same for body and prox
  glimpse()


# calculate percentages   
d4_b<-full_join(d2_b,d3_b)%>%
  mutate(assoc_body_p=round(assoc_body_n/taxa_n,3))%>%
  mutate(assoc_prox_p=round(assoc_prox_n/taxa_n,3))%>%
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
    taxa_n=sum(assoc_hab_n))%>% # same for body and prox
  glimpse()


# calculate percentages   
d4_h<-full_join(d2_h,d3_h)%>%
  mutate(assoc_hab_p=round(assoc_hab_n/taxa_n,3))%>%
  glimpse()


write_csv(d4_b,"./doc/assoc_bl_prox.csv")
write_csv(d4_h,"./doc/assoc_hab.csv")
