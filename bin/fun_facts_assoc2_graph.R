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
unique(d1$assoc_body_length2)
unique(d1$assoc_proximity2)
unique(d1$assoc_habitat2)

d2<-d1%>% 
  # graphing level for multisp. groups
  mutate(assoc_body_length3=if_else(assoc_body_length2=="Multispecies Group","Multispecies\nGroup",assoc_body_length2))%>% 
  mutate(assoc_proximity3=if_else(assoc_proximity2=="Multispecies Group","Multispecies\nGroup",assoc_proximity2))%>% 
  mutate(assoc_habitat3=if_else(assoc_habitat2=="Multispecies Group","Multispecies\nGroup",assoc_habitat2))%>% 
  
  # shortened names -----
  
  # body
  mutate(assoc_body_length3=if_else(assoc_body_length3=="Not Associated","Not\nAssociated",assoc_body_length3))%>%
  mutate(assoc_body_length3=if_else(assoc_body_length3=="No Data","No\nData",assoc_body_length3))%>%
  mutate(assoc_body_length3=factor(assoc_body_length3,levels=c("Not\nAssociated","Associated","No\nData","Multispecies\nGroup")))%>%
  
  # prox 
  mutate(assoc_proximity3=if_else(assoc_proximity3=="Not Associated","Not\nAssociated",assoc_proximity3))%>%
  mutate(assoc_proximity3=if_else(assoc_proximity3=="No Data","No\nData",assoc_proximity3))%>%
  mutate(assoc_proximity3=factor(assoc_proximity3,levels=c("Not\nAssociated","Associated","No\nData","Multispecies\nGroup")))%>%
  
  # habitat 
  mutate(assoc_habitat3=if_else(assoc_habitat3=="Not Associated","No\nAssociation",assoc_habitat3))%>%
  mutate(assoc_habitat3=if_else(assoc_habitat3=="Probable Association","Probable\nAssociation",assoc_habitat3))%>%
  mutate(assoc_habitat3=if_else(assoc_habitat3=="Definite Association","Definite\nAssociation",assoc_habitat3))%>%
  mutate(assoc_habitat3=factor(assoc_habitat3,levels=c("No\nAssociation","Probable\nAssociation", "Definite\nAssociation", "Multispecies\nGroup")))%>%

# 
#   # order factors
#   mutate(assoc_body_length3=factor(assoc_body_length3,levels=c("Not Associated","Associated","No Data")),
#          assoc_proximity2=factor(assoc_proximity2,levels=c("Not Associated","Associated","No Data")),
#          assoc_habitat3=factor(assoc_habitat3,levels=c("Not Associated","Probable Association", "Definite Association", "Multispecies\nGroup")))%>%
    glimpse()

d2

# view(filter(d2,is.na(assoc_body_length3)))
# view(filter(d2,is.na(assoc_proximity3)))
# view(filter(d2,is.na(assoc_habitat3)))

# --------------------------------------------------------------------------
# pull out graph specific info

#body length
d1_b<-d2%>%
  select(common_name,Group,assoc_body_length3)%>%
  glimpse()
d1_b
unique(d1_b$assoc_body_length3)

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
g1_b<-ggplot(d1_b,aes(x=assoc_body_length3, fill=Group))+geom_bar(position = position_dodge2(preserve = "single"))+
  xlab("Body Length Scale")+
  scale_fill_discrete_sequential(palette = "Batlow",order=c(2,1,3))+
  ylab("Number of Taxa")+
  deets6
g1_b
ggsave("./doc/g_assoc_bl.tiff",width=5.5, height=3.5) 

# proximity
g1_p<-ggplot(d1_p,aes(x=assoc_proximity3, fill=Group))+geom_bar(position = position_dodge2(preserve = "single"))+
  xlab("Proximity Scale")+
  scale_fill_discrete_sequential(palette = "Batlow",order=c(2,1,3))+
  ylab("Number of Taxa")+
  deets6
g1_p
ggsave("./doc/g_assoc_prox.tiff",width=5.5, height=3.5) 

# habitat
g1_h<-ggplot(d1_h,aes(x=assoc_habitat3, fill=Group))+geom_bar(position = position_dodge2(preserve = "single"))+
  xlab("Habitat Scale")+
  scale_fill_discrete_sequential(palette = "Batlow",order=c(2,1,3))+
  ylab("Number of Taxa")+
  deets6
g1_h
ggsave("./doc/g_assoc_hab.tiff",width=5.5, height=3.5) 
