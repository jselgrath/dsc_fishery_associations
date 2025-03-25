# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: calculate depth ranges for groups and unspecifed spp


# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_valuation/")

d1<-read_csv("./data/Updated CDFW_fishtix_DSC_AW3_new_sp - data_20240212.csv")%>%
  glimpse()

# small
unique(d1$group_small)
d2_small<-d1%>%
  filter(group_small==960)%>%
  group_by(group_small)%>%
  summarize(
    depth_min=as.numeric(min(depth_range_shallow_m)),
    depth_max=as.numeric(max(depth_range_deep_m)))%>%
  glimpse()

# blue & black
unique(d1$group_blue_black)

d2_bb<-d1%>%
  filter(group_blue_black==1 | group_blue_black==972)%>%
  group_by(group_blue_black)%>%
  summarize(
    depth_min=as.numeric(min(depth_range_shallow_m)),
    depth_max=549)%>%
  mutate(group_blue_black=972)%>%
  glimpse()

# unique(d2_bb$depth_range_deep_m) # checked and 90(549) is correct



# group_red
unique(d1$group_red)

d2_r<-d1%>%
  filter(group_red==1 )%>% # | group_red== 959
  group_by(group_red)%>%
  summarize(
    depth_min=as.numeric(min(depth_range_shallow_m)),
    depth_max=1200)%>%
  mutate(group_red=959)%>%
  glimpse()

unique(d2_r$depth_range_deep_m) # checked before summarized


# group_red_deep
unique(d1$group_red_deep)

d2_dr<-d1%>%
  filter(group_red_deep==958 | group_red_deep==1)%>%
  group_by(group_red_deep)%>%
  summarize(
    depth_min=as.numeric(min(depth_range_shallow_m)),
    depth_max=1200)%>%
  mutate(group_red_deep=958)%>%
  glimpse()

# unique(d2_dr$depth_range_deep_m) # checked and 1200 is correct



# group_species ----------------------------------------------
unique(d1$group_species)

# 956 ----------
d2_gs1<-d1%>%
  filter(group_species>=1)%>%
  filter(group_species=="956" | group_species=="956; 961" )%>%
  group_by(group_species)%>%
  # summarize(
  #   depth_min="50(0)",
  #   depth_max=838)%>%
  glimpse()

unique(d2_gs1$depth_range_deep_m)
unique(d2_gs1$depth_range_shallow_m)

# 957 ----------
d2_gs2<-d1%>%
  filter(group_species>=1)%>%
  filter(group_species=="957" |group_species=="957; 962" )%>%
  group_by(group_species)%>%
  # summarize(
  #   depth_min="50(0)",
  #   depth_max=838)%>%
  glimpse()

unique(d2_gs2$depth_range_deep_m)
unique(d2_gs2$depth_range_shallow_m)


# 961 ----------
d2_gs2<-d1%>%
  filter(group_species>=1)%>%
  filter(group_species=="961" |group_species=="956; 961" )%>%
  group_by(group_species)%>%
  # summarize(
  #   depth_min="50(0)",
  #   depth_max=838)%>%
  glimpse()

unique(d2_gs2$depth_range_deep_m)
unique(d2_gs2$depth_range_shallow_m)

# 962 ----------
d2_gs2<-d1%>%
  filter(group_species>=1)%>%
  filter(group_species=="962" |group_species=="957; 962" )%>%
  group_by(group_species)%>%
  # summarize(
  #   depth_min="50(0)",
  #   depth_max=838)%>%
  glimpse()

unique(d2_gs2$depth_range_deep_m)
unique(d2_gs2$depth_range_shallow_m)


# 971 --------------
d2_gs1<-d1%>%
  filter(group_species>=1)%>%
  filter(group_species==971)%>%
  group_by(group_species)%>%
  summarize(
    depth_min="50(0)",
    depth_max=838)%>%
  glimpse()

# unique(d2_gs1$depth_range_deep_m)
# unique(d2_gs1$depth_range_shallow_m)


# group_depth
unique(d1$ group_depth)

d2_gd<-d1%>%
  filter( !is.na(group_depth))%>%
  group_by( group_depth)%>%
  summarize(
    depth_min=min(depth_range_shallow_m),
    depth_max=max(depth_range_deep_m))%>%
  glimpse()

# unique(d2_gd$depth_range_deep_m) 
