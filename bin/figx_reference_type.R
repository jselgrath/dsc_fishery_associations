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
#from: https://docs.google.com/spreadsheets/d/1ydQ5N2b294E1dQAp_M_Jj8mqKsB-awVxs0iBDx3Zy7g/edit#gid=444082964

d1<-read_csv("./data/reference_type_20240605.csv")%>%glimpse()

source("./bin/deets.R")

ggplot(d1,aes(x=type))+geom_bar()+
  xlab("Type of Reference")+
  ylab("Number")+
  deets6

ggsave("./doc/reference_type.tiff",width=5.5, height=3.5) 
