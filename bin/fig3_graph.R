# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: fun facts about association data
# ---------------------------------------------------
library(tidyverse); library(ggplot2); library(colorspace)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# read data and update association categories for graphs
# note there are two types of association metrics, here lumped together
d1<-read_csv("./results/association_long.csv")%>%glimpse()

# check existing levels
unique(d1$adjacent)
unique(d1$general_prox)
unique(d1$assoc_habitat2)

d2<-d1%>% 
  # graphing level for multisp. groups
  mutate(adjacent3=if_else(adjacent=="Multispecies group","Multispecies\nGroup",adjacent))%>% 
  mutate(assoc_proximity3=if_else(general_prox=="Multispecies group","Multispecies\nGroup",general_prox))%>% 
  mutate(assoc_habitat3=if_else(assoc_habitat2=="Multispecies group","Multispecies\nGroup",assoc_habitat2))%>% 
  
  # shortened names -----
  
  # body
  mutate(adjacent3=if_else(adjacent3=="Not associated","Not\nAssociated",adjacent3))%>%
  mutate(adjacent3=if_else(adjacent3=="No data","No\nData",adjacent3))%>%
  mutate(adjacent3=factor(adjacent3,levels=c("Not\nAssociated","Associated","No\nData","Multispecies\nGroup")))%>%
  
  # prox 
  mutate(assoc_proximity3=if_else(assoc_proximity3=="Not associated","Not\nAssociated",assoc_proximity3))%>%
  mutate(assoc_proximity3=if_else(assoc_proximity3=="No data","No\nData",assoc_proximity3))%>%
  mutate(assoc_proximity3=factor(assoc_proximity3,levels=c("Not\nAssociated","Associated","No\nData","Multispecies\nGroup")))%>%
  
  # habitat 
  mutate(assoc_habitat3=if_else(assoc_habitat3=="Not associated","No\nAssociation",assoc_habitat3))%>%
  mutate(assoc_habitat3=if_else(assoc_habitat3=="Probable association","Probable\nAssociation",assoc_habitat3))%>%
  mutate(assoc_habitat3=if_else(assoc_habitat3=="Definite association","Definite\nAssociation",assoc_habitat3))%>%
  mutate(assoc_habitat3=factor(assoc_habitat3,levels=c("No\nAssociation","Probable\nAssociation", "Definite\nAssociation", "Multispecies\nGroup")))%>%

# 
#   # order factors
#   mutate(adjacent3=factor(adjacent3,levels=c("Not associated","associated","No Data")),
#          general_prox=factor(general_prox,levels=c("Not associated","associated","No Data")),
#          assoc_habitat3=factor(assoc_habitat3,levels=c("Not associated","Probable association", "Definite association", "Multispecies\nGroup")))%>%
    glimpse()

d2

# view(filter(d2,is.na(adjacent3)))
# view(filter(d2,is.na(assoc_proximity3)))
# view(filter(d2,is.na(assoc_habitat3)))

# --------------------------------------------------------------------------
# pull out graph specific info

#body length
d1_b<-d2%>%
  select(common_name,Group,adjacent3)%>%
  glimpse()
d1_b
unique(d1_b$adjacent3)

#proximity
d1_p<-d2%>%
  select(common_name,Group,assoc_proximity3)%>%
  glimpse()
d1_p

#habitat
d1_h<-d2%>%
  select(common_name,Group,assoc_habitat3)%>%
  glimpse()
d1_h




# ----------------------------------------------------------
# graph ----------------------------------------------------------
source("./bin/deets.R")

#body length
g1_b<-ggplot(d1_b,aes(x=adjacent3, fill=Group))+geom_bar(position = position_dodge2(preserve = "single"))+
  xlab("Adjacent")+
  scale_fill_discrete_sequential(palette = "Batlow",order=c(2,1))+
  ylab("Number of Taxa")+
  deets6
g1_b
ggsave("./doc/fig3_adjacent.tiff",width=5.5, height=3.5) 

# proximity
g1_p<-ggplot(d1_p,aes(x=assoc_proximity3, fill=Group))+geom_bar(position = position_dodge2(preserve = "single"))+
  xlab("General Proximity")+
  scale_fill_discrete_sequential(palette = "Batlow",order=c(2,1,3))+
  ylab("Number of Taxa")+
  deets6
g1_p
ggsave("./doc/fig3_prox.tiff",width=5.5, height=3.5) 

# habitat
g1_h<-ggplot(d1_h,aes(x=assoc_habitat3, fill=Group))+geom_bar(position = position_dodge2(preserve = "single"))+
  xlab("Habitat")+
  scale_fill_discrete_sequential(palette = "Batlow",order=c(2,1,3))+
  ylab("Number of Taxa")+
  deets6
g1_h
ggsave("./doc/fig3_hab.tiff",width=5.5, height=3.5) 
