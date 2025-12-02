# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: gears related to associated species
# ---------------------------------------------------
library(tidyverse); library(ggplot2); library(colorspace)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# read data and update association categories for graphs
# note there are two types of association metrics, here lumped together
d1<-read_csv("./results/association_long.csv")%>%
  select(-SpeciesGroup)%>%
  glimpse()

#all data - with gear
# setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_valuation_jack")
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_valuation/")

# gears that catch different species
d2<-read_csv("./results/trip_tix_ca_with_groups.csv")%>%
  select(species_id=SpeciesID,species_group=SpeciesGroup,gear_id=GearID,gear_name=GearName,gear_group=GearGroup)%>%
  unique()%>%
  glimpse()
d2

# join associations and gears
d3<-d1%>%
  left_join(d2, relationship = "many-to-many")%>%
  glimpse()

# proximity associations ==1 and assoc hab == 2
d4<-d3%>%
  filter(assoc_proximity==1 & assoc_habitat==2)%>%
  unique()%>%
  glimpse()


# summarize - number of associated species catught by gears
d5<-d4%>%
  group_by(gear_id,gear_name,gear_group)%>%
  summarize(
    species_n=length(unique(species_id)))%>%
  ungroup()%>%
  arrange(species_n)%>%
  glimpse()
range(d5$species_n)
plot(d5$species_n)

# top gears - remove unknown gears
d6<-d5%>%
  filter(species_n>20)%>%
  glimpse()

# link top gears back to species IDs
d7<-d6%>%
  left_join(d2)%>%
  unique()%>%
  glimpse()

# link back to species data
d8<-d7%>%
  left_join(d4)%>%
  filter(assoc_proximity==1 & assoc_habitat==2)%>%
  unique()%>%
  glimpse()

# summarize
d9<-d8%>%
  group_by(species_id,species_group,species_name,Group)%>%
  summarize(
    gear_n=length(unique(gear_id)),
    gear_group_n=length(unique(gear_group)))%>%
      glimpse()
  
  

# save --------------------------------------------
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

write_csv(d5,"./results/gear_species_number.csv")
write_csv(d5,"./results/gear_top_species_number.csv")
write_csv(d9,"./results/species_gear_number.csv")
