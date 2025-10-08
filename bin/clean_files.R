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
d00<-read_csv("./data/table_s1_20250327_onlylandedspp.csv")%>% #table_s1_20250325
  filter(genus!="Nezumia")%>%  # removing two species of grenadier because they all share one landing code and it messes up the estimates
  select(-references)%>%
  arrange(species_id)%>%
  glimpse()

# d00%>%
#   filter(species_id==180)

# view(d00)

# check duplicates - 3 sp of greanadier share one code (now removing above)
d00%>%
  group_by(species_id)%>%
  summarize(n=n())%>%
  filter(n>1)%>%
  glimpse()


# data from CDFW from 2025 DSA - no fresh, algae, roe/eggs
d000<-read_csv("./results/lc_record_no.csv")%>% # 
  # select(-species_name)%>%
  glimpse()

d000%>%
  summarize(n=sum(n_landings))


d1<-d00%>%
  left_join(d000)%>% 
  unique()%>%
  # filter(!is.na(n_landings))%>%
  glimpse()
#
# view(d1)
d1


# summarize --------------------------
d4<-d1%>%
  group_by(group)%>%
  summarize(
    group_n=sum(n_landings,na.rm=T)
  )%>%
  glimpse()


write_csv(d1,"./results/fishtix_assoc_clean_no_fresh.csv")
write_csv(d4,"./doc/fishtix_landings_by_group.csv") # for first paragraph of results
