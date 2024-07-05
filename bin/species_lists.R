# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: pull cdfw data 2010-2020
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/cdfw_fishtix/")

d1<-read_csv("./data/2010.csv")%>%
  mutate(year=2010)%>%
  glimpse()
d2<-read_csv("./data/2011.csv")%>%
  mutate(year=2011)%>%
  glimpse()
d3<-read_csv("./data/2012.csv")%>%
  mutate(year=2012)%>%
  glimpse()
d4<-read_csv("./data/2013.csv")%>%
  mutate(year=2013)%>%
  glimpse()
d5<-read_csv("./data/2014.csv")%>%
  mutate(year=2014)%>%
  glimpse()
d6<-read_csv("./data/2015.csv")%>%
  mutate(year=2015)%>%
  glimpse()
d7<-read_csv("./data/2016.csv")%>%
  mutate(year=2016)%>%
  glimpse()
d8<-read_csv("./data/2017.csv")%>%
  mutate(year=2017)%>%
  glimpse()
d9<-read_csv("./data/2018.csv")%>%
  mutate(year=2018)%>%
  glimpse()
d10<-read_csv("./data/2019.csv")%>%
  mutate(year=2019)%>%
  glimpse()
d11<-read_csv("./data/2020.csv")%>%
  mutate(year=2020)%>%
  glimpse()

# join all years, remove pii
d20<-rbind(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11)%>%
  select(PortID:BlockName,SpeciesID:year)%>%
  glimpse

# extract species list
d21<-d20%>%
  select(SpeciesID,SpeciesName)%>%
  unique()

# save
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_valuation_association/")
write_csv(d20,"./results/fishtix_2010_2020.csv")
write_csv(d21,"./doc/species_list_2010_2020.csv")
