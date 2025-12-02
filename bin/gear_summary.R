# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: identify species that were landed  by commercial fisheries in ca 2010-2024

# ---------------------------------------------------
library(tidyverse)
library(purrr)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# ---------------------------------------
# final assoc table - updated with 2024 data 
# d000<-read_csv("./data/table_s1_20250327_onlylandedspp.csv")%>% #table_s1_20250325
#   filter(genus!="Nezumia")%>%  # removing two species of grenadier because they all share one landing code and it messes up the estimates
#   select(-references)%>%
#   arrange(species_id)%>%
#   glimpse()

# d00%>%
#   filter(species_id==180)

# view(d00)

# check duplicates - 3 sp of greanadier share one code (now removing above)
# d00%>%
#   group_by(species_id)%>%
#   summarize(n=n())%>%
#   filter(n>1)%>%
#   glimpse()

# processed data with just landing categories for no freshwater
d00<-read_csv("./results/fishtix_assoc_clean_no_fresh.csv")%>%
  glimpse()

# fisheries data, no freshwater
d0<-read_csv("./results/gear_fishtix_spp_2010_2024_no_fresh.csv")%>%
  select(-species_name)%>%
  glimpse()


# join
d1<-d00%>%
  left_join(d0)%>% 
  glimpse()
#
# view(d1)
d1

# -------------------------------------------------------------
# check for missing species groups  (update if needed) -----------------
# -------------------------------------------------------------

# ID missing for species that are not currently fished like abalone and basking shark
# can be used iteratively after run  code below to check
# ideally this returns nothing

ID<-filter(d1,is.na(group))%>%
  select(common_name,species_id,group)%>%
  arrange(species_id)%>%
  glimpse()






#========================================================================================
## Grouping records by "Gear Type" based on methods used in NMFS PNWFSC 2013 report
## See Table 1.5 in 2013 Technical Appendix
# updated from Jack's list with VMS info (summer 2024 list, updated 2025)

# ## Original from Table 1.5
d2 <- d1 %>%
  mutate(GearGroup = ifelse(GearID %in% c(1,2,6,85), "Hook/Line", # added 85
                            ifelse(GearID %in% c(3,4,5,30,31,21,24,81,82), "Longlines", # added 81,82
                                   ifelse(GearID %in% c(7,8,9,32,86), "Troll", # added 86
                                          ifelse(GearID %in% c(11,12), "Harpoon/Spear",
                                                 ifelse(GearID %in% c(13,14,15,18), "Hooka/Diving",
                                                        ifelse(GearID %in% c(20,21,22,25,26,27,38), "Pots/Traps", # added 20, 26
                                                               ifelse(GearID %in% c(33,34,47:59), "Trawl",
                                                                      ifelse(GearID %in% c(35,40,41,70,72, 73,74,78), "OtherSeine/DipNets", # added 41 70, and 72
                                                                             ifelse(GearID %in% c(63,64,65), "DriftNet", # drift gillnet - added 64
                                                                                    ifelse(GearID %in% c(60,61,66,67,68,69), "SetGillNet", #added 60 (engangling net), 69 - herring set gn and 61 trammel net
                                                                                           ifelse(GearID %in% c(71), "PurseSeine",
                                                                                                  ifelse(GearID %in% c(83,84), "BuoyGear",
                                                                                                         ifelse(GearID %in% c(0), "Unspecified",
                                                                                                                ifelse(GearID %in% c(16,23,24,28,72,80), "NetOther",  # not econ category
                                                                                                                       ifelse(GearID %in% c(19), "Dredge",  # not econ category
                                                                                                                              ifelse(GearID %in% c(10,17,36,37,41,42,61,66,69,90,91,95,99), "AllOther", "")))))))))))))))))%>% #17 is kelp barge
  glimpse()
d2

# check
d2%>%filter(GearGroup=="AllOther")%>%arrange(GearID)
d2%>%filter(GearGroup=="")%>%arrange(GearID)



# -------------------------------------------------------------------
# Function to summarize associations by gear and gear group
# -------------------------------------------------------------------
summarize_associations <- function(df, assoc_type = c("adjacent", "general_prox", "habitat_depth")) {
  assoc_type <- match.arg(assoc_type)
  
  # Apply the correct filter
  d3 <- df %>%
    {
      if (assoc_type == "adjacent") {
        filter(., adjacent == "Associated")
      } else if (assoc_type == "general_prox") {
        filter(., general_prox == "Associated")
      } else if (assoc_type == "habitat_depth") {
        filter(., habitat_depth %in% c(1, 2))
      }
    }
  
  # Summarize by gear
  by_gear <- d3 %>%
    group_by(GearID, GearName, GearGroup) %>%
    summarize(LandingCategory_n = n_distinct(species_id), .groups = "drop") %>%
    mutate(assoc_type = assoc_type)
  
  # Summarize by gear group
  by_gear_group <- d3 %>%
    group_by(GearGroup) %>%
    summarize(LandingCategory_n = n_distinct(species_id), .groups = "drop") %>%
    mutate(assoc_type = assoc_type)
  
  # Return both WITH assoc_type embedded in each tibble
  list(by_gear = by_gear, by_gear_group = by_gear_group)
}

# -------------------------------------------------------------------
# Run for all association types
# -------------------------------------------------------------------
assoc_types <- c("adjacent", "general_prox", "habitat_depth")

# Map over all three types and combine properly
all_results <- map(assoc_types, ~ summarize_associations(d2, .x))

# Stack all long tables (assoc_type now exists inside)
by_gear_long <- bind_rows(map(all_results, "by_gear"))
by_gear_group_long <- bind_rows(map(all_results, "by_gear_group"))

# -------------------------------------------------------------------
# Convert to wide format
# -------------------------------------------------------------------
by_gear_wide <- by_gear_long %>%
  pivot_wider(
    id_cols = c(GearID, GearName, GearGroup),
    names_from = assoc_type,
    values_from = LandingCategory_n,
    values_fill = 0
  ) %>%
  arrange(-adjacent,GearGroup, GearName)


by_gear_group_wide <- by_gear_group_long %>%
  pivot_wider(
    id_cols = GearGroup,
    names_from = assoc_type,
    values_from = LandingCategory_n,
    values_fill = 0
  ) %>%
  arrange(-adjacent,GearGroup)

# -------------------------------------------------------------------
# View and save
# -------------------------------------------------------------------
by_gear_wide
by_gear_group_wide


# save
write_csv(by_gear_wide, "./doc/gear_landing_category_wide_20251008.csv")
write_csv(by_gear_group_wide, "./doc/gear_group_landing_category_wide_20251008.csv")


