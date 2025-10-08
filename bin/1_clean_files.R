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
  select(-references)%>%
  glimpse()


# data from CDFW from 2025 DSA - no fresh, algae, roe/eggs
d000<-read_csv("./results/lc_record_no.csv")%>% # 
  select(-species_name)%>%
  glimpse()


d1<-d00%>%
  left_join(d000)%>% # ones that do not match are (1) freshwater and salmon roe which are excluded OR (2) older species which made it into the list but are not currently caught.
  # unique()%>%
  # select(-new)%>%
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
