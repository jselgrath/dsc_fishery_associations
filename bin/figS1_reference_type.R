# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral association

# goal: reference type
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# ---------------------------------------
#datafrom: https://docs.google.com/spreadsheets/d/1ydQ5N2b294E1dQAp_M_Jj8mqKsB-awVxs0iBDx3Zy7g/edit#gid=444082964  sheet = Table S2

d1<-read_csv("./data/table_s2_20250327.csv")%>%
  glimpse()

d2<-d1
d2$Type[d2$Type=="Thesis"]<-"Other"
  

source("./bin/deets.R")

ggplot(d2,aes(x=Type))+geom_bar()+
  xlab("Type of Reference")+
  ylab("Number")+
  deets6

ggsave("./doc/fig_s1_reference_type.tiff",width=5.5, height=3.5) 
