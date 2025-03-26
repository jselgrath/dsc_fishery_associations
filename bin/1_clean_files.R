# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: driver for association data
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# ---------------------------------------
# final assoc table - updated with 2024 data 
d00<-read_csv("./data/selgrath - table_s1_20250325b.csv")%>% #table_s1_20250325
  select(-references)%>%
  glimpse()

#older data
# d1<-read_csv("./data/fishtix_assoc_20240520.csv")%>% 
#   select(species_name:assoc_proximity,assoc_hab,habitat=habitat...12,freshwater)%>%
#   # # remove algae
#   filter(species_name!="Agar"& species_name!="Algae marine" & species_name!="Kelp giant")%>%
#   # #remove roe
#   filter(species_name!="Herring Pacific - roe"& species_name!="Herring Pacific - roe on kelp")%>%
#   # no freshwater
#   filter(freshwater==0)%>%
#   select(-freshwater)%>%
#   glimpse()



# length(unique(d1$common_name))
# length(unique(d1$species_id))
# 
# write_csv(d1,"./results/fishtix_assoc_20240520_no_algae_roe.csv")

# join
# d1b<-d00%>%
#   full_join(d1)%>%
#   arrange(common_name)%>%
#   glimpse()
# view(d1b)


# data from CDFW from 2025 DSA - no fresh, algae, roe/eggs
d000<-read_csv("./results/lc_record_no.csv")%>% # 
  select(-species_name)%>%
  glimpse()


d1<-d00%>%
  left_join(d000)%>% # ones that do not match are (1) freshwater and salmon roe which are excluded OR (2) older species which made it into the list but are not currently caught.
  unique()%>%
  # select(-new)%>%
  glimpse()
#
view(d1)
d1


write_csv(d1,"./results/fishtix_assoc_clean_no_fresh.csv")

