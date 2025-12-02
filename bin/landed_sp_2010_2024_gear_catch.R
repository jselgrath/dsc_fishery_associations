# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: identify gears and species that were landed  by commercial fisheries in ca 2010-2020

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
d11<-read_csv("./data/MLDS_2025/MLR Data Extract_2021.csv")%>%
  mutate(year=2021)%>%
  glimpse()
d12<-read_csv("./data/MLDS_2025/MLR Data Extract_2022.csv")%>%
  mutate(year=2022)%>%
  glimpse()
d13<-read_csv("./data/MLDS_2025/MLR Data Extract_2023.csv")%>%
  mutate(year=2023)%>%
  glimpse()
d14<-read_csv("./data/MLDS_2025/MLR Data Extract_2024.csv")%>%
  mutate(year=2024)%>%
  glimpse()

d20<-rbind(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14)%>%
  mutate(species_name=str_squish(SpeciesName))%>%
  mutate(species_id=str_squish(SpeciesID))%>%
  select(-SpeciesName,-SpeciesID)%>%
  glimpse()

d21<-d20%>%
  select(year,PortID,PortName,Quantity, Pounds,GearID,GearName,species_name, species_id)%>%
  glimpse()


d22<-d21%>%
  
  # Assigning GearName == "Unspecified" and GearID == 0 to records w/ GearName as NA
  mutate(GearID = ifelse(GearName=="invalid", 0, GearID))%>%
  mutate(GearName= ifelse(GearName=="invalid", "Unspecified", GearName))%>%
  mutate(GearName = ifelse(is.na(GearName) & is.na(GearID), "Unspecified", GearName))%>%
  mutate(GearID = ifelse(GearName == "Unspecified",0, GearID))%>%
  glimpse()

# save
write_csv(d22,"./results/fishtix_spp_2010_2024_gear.csv")

