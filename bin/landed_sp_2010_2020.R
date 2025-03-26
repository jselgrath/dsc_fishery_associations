# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: identify species that were landed  by commercial fisheries in ca 2010-2020

# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

d0<-read_csv("./data/MLDS_2025/MLR Data Extract_2010.csv")%>%
  mutate(year=2010)%>%
  glimpse()
d1<-read_csv("./data/MLDS_2025/MLR Data Extract_2011.csv")%>%
  mutate(year=2011)%>%
  glimpse()
d2<-read_csv("./data/MLDS_2025/MLR Data Extract_2012.csv")%>%
  mutate(year=2012)%>%
  glimpse()
d3<-read_csv("./data/MLDS_2025/MLR Data Extract_2013.csv")%>%
  mutate(year=2013)%>%
  glimpse()
d4<-read_csv("./data/MLDS_2025/MLR Data Extract_2014.csv")%>%
  mutate(year=2014)%>%
  glimpse()
d5<-read_csv("./data/MLDS_2025/MLR Data Extract_2015.csv")%>%
  mutate(year=2015)%>%
  glimpse()
d6<-read_csv("./data/MLDS_2025/MLR Data Extract_2016.csv")%>%
  mutate(year=2016)%>%
  glimpse()
d7<-read_csv("./data/MLDS_2025/MLR Data Extract_2017.csv")%>%
  mutate(year=2017)%>%
  glimpse()
d8<-read_csv("./data/MLDS_2025/MLR Data Extract_2018.csv")%>%
  mutate(year=2018)%>%
  glimpse()
d9<-read_csv("./data/MLDS_2025/MLR Data Extract_2019.csv")%>%
  mutate(year=2019)%>%
  glimpse()
d10<-read_csv("./data/MLDS_2025/MLR Data Extract_2020.csv")%>%
  mutate(year=2020)%>%
  glimpse()

d20<-rbind(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10)%>%
  mutate(species_name=str_squish(SpeciesName))%>%
  mutate(species_id=str_squish(SpeciesID))%>%
  select(-SpeciesName,-SpeciesID)%>%
  glimpse()

# estimate of unique spp from all years (2010-2020)
length(unique(d20$species_id))%>% 
  glimpse() # 329 (was 327 with original version of  data)

# unique names and IDs for all species
# remove pii etc
d21<-d20%>%
  select(species_id,species_name)%>%
  unique()%>%
  arrange(species_id)%>%
  glimpse()

# save ----------------------------
# write_csv(d20,"./results/fishtix_2010_2020.csv")
write_csv(d21,"./results/fishtix_spp_2010_2020.csv")

glimpse(d20)
