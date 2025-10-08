# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: fun facts about association data
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

d1<-read_csv("./results/fishtix_assoc_clean_no_fresh.csv")%>%
  mutate(assoc_habitat=habitat_depth)%>%
  glimpse()

length(unique(d1$species_id)) # 3 duplicates because 3 grenadier spp have 1 species_id (198)

# species group info
d2<-read_csv("./data/data_species_group3.csv")%>%
  select(-SpeciesName)%>%
  glimpse()

unique(d2$SpeciesGroup)
# 
# # join species group info to association info
d3<-d1%>%
  left_join(d2,relationship = "many-to-many")%>%
  unique()%>%
  glimpse()

# figure out NAs --------------
unique(d3$assoc_habitat)

# -------------------------------------------------------------
# check for missing species groups  (update if needed) -----------------
# -------------------------------------------------------------

# ID missing for species that are not currently fished like abalone and basking shark
# can be used iteratively after run  code below to check
# ideally this returns nothing

ID<-filter(d3,is.na(SpeciesGroup))%>%
  select(common_name,species_id,SpeciesGroup,species_group2)%>%
  arrange(species_id)%>%
  glimpse()


# 
# # -------------------------------------------------------------
#   # habtiat updates make categories text vs numbers ------------------------------------
d3a<-d3%>%
  mutate(assoc_habitat2=if_else(habitat_depth ==0,"Not associated",
                                if_else(habitat_depth ==1,"Probable association", 
                                        if_else(habitat_depth ==2,"Definite association",habitat_depth))))%>%
  mutate(Group=species_group2)%>%
  glimpse()

d3a


# ---------------------------- 
# examples of species with unknown associations (no Data) ----------------------------
# used for examples in text and tables
d3%>%
  filter(group=="Invertebrate" & general_prox=="No data")%>%
  select(species_id,common_name, depth_min_m:SpeciesGroup)


d3%>%
  filter(group=="Fish" & general_prox=="No data")%>%
  select(common_name, depth_min_m:SpeciesGroup)



# ------------------------------------------------
# summarize by species group2-----------------------

#  -- adjacent ----------------------------------
d4<-d3%>%
  group_by(adjacent,group)%>%
  summarize(
    adjacent_n=n())%>%
  mutate(association=adjacent)%>%
  ungroup()%>%
  select(-adjacent)%>%
  glimpse()

d4

# adjacent - pivot for X2 to wide contingency table
d4_c <- d4 %>%
  pivot_wider(
    names_from = group,
    values_from = adjacent_n,
    values_fill = 0
  ) %>%
  column_to_rownames("association")

d4_c

# adjacent - X2
chisq.test(d4_c)


# -- general proximity ----------------------------------
d5<-d3%>%
  group_by(general_prox,group)%>%
  summarize(
    general_prox_n=n())%>%
  mutate(association=general_prox)%>%
  ungroup()%>%
  select(-general_prox)%>%
  glimpse()
d5

# gp - pivot for X2 to wide contingency table
d5_c <- d5 %>%
  pivot_wider(
    names_from = group,
    values_from = general_prox_n,
    values_fill = 0
  ) %>%
  column_to_rownames("association")

d5_c

# gp - X2
chisq.test(d5_c)



# -- habitat ----------------------------
d6<-d3a%>%
  group_by(assoc_habitat2,group)%>%
  summarize(
    assoc_hab_n=n())%>%
  mutate(association=assoc_habitat2)%>%
  ungroup()%>%
  select(-assoc_habitat2)%>%
  glimpse()
d6


# adjacent - pivot for X2 to wide contingency table
d6_c <- d6 %>%
  pivot_wider(
    names_from = group,
    values_from = assoc_hab_n,
    values_fill = 0
  ) %>%
  column_to_rownames("association")

d6_c

# habitat - X2
chisq.test(d6_c)



# -- merge ---------------------
# note there are two types of association metrics, here lumped together
d7<-d4%>%
  full_join(d5)%>%
  full_join(d6)%>%
  select(group,association,adjacent_n,general_prox_n,assoc_hab_n)%>%
  mutate(group=group)%>%
  select(-group,group,association:assoc_hab_n)%>%
  glimpse()

d7

#total sp
d7%>%
  summarize(
    assoc_tot=sum(adjacent_n,na.rm=T)
  )%>%
  glimpse()

# groups()
d7%>%
  group_by(group)%>%
  summarize(
    assoc_tot=sum(adjacent_n,na.rm=T)
  )%>%
  glimpse()


# -- compare associated counts among metrics - combine def and prob assoc
d8<-d7%>%
  # Replace NA with 0 for numeric columns
  mutate(across(c(adjacent_n, general_prox_n, assoc_hab_n), ~replace_na(., 0))) %>%
  
  # Collapse categories
  mutate(association_collapsed = case_when(
    association %in% c("Definite association","Probable association") ~ "Associated", # change def and/or prob assoc here
    TRUE ~ association
  )) %>%
  
  # Sum values within each group × collapsed association (new syntax)
  group_by(group, association_collapsed) %>%
  summarize(
    across(c(adjacent_n, general_prox_n, assoc_hab_n), \(x) sum(x, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  
  # Rename for clarity
  rename(association = association_collapsed) %>%
  arrange(group, association)



# -- filter for only assoc or non-assoc --------
d8a<-d8%>%
  filter(association=="Associated" | association=="Not associated")

# not separated by taxon
d8b <- d8a %>%
  filter(association %in% c("Associated", "Not associated")) %>%
  group_by(association) %>%
  summarize(
    across(c(adjacent_n, general_prox_n, assoc_hab_n), sum, na.rm = TRUE),
    .groups = "drop"
  )

d8b



# -- make contingency tables -----------------
# all
all_tab <- d8b %>%
  column_to_rownames("association")



# Fish table
fish_tab <- d8a %>%
  filter(group == "Fish") %>%
  select(association, adjacent_n, general_prox_n, assoc_hab_n) %>%
  column_to_rownames("association")%>%
  glimpse()


# Invertebrate table
invert_tab <- d8a %>%
  filter(group == "Invertebrate") %>%
  select(association, adjacent_n, general_prox_n, assoc_hab_n) %>%
  column_to_rownames("association")

all_tab
fish_tab
invert_tab

# Chi-square test: do the three measures differ in distribution (within fish)?
chisq_all<- chisq.test(all_tab)
chisq_fish <- chisq.test(fish_tab)
chisq_invert <- chisq.test(invert_tab)

chisq_all
chisq_fish
chisq_invert

# which results differ the most - Large residuals (> |2|) indicate that a specific measure (e.g., assoc_hab_n) diverges from the others.
chisq_fish$stdres
chisq_invert$stdres


# quick visual
d8a%>%
  pivot_longer(cols = c(adjacent_n, general_prox_n, assoc_hab_n),
               names_to = "measure", values_to = "count") %>%
  ggplot(aes(x = measure, y = count, fill = association)) +
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ group) +
  theme_minimal() +
  labs(title = "Comparison of association measures for Associated vs Not associated",
       y = "Proportion", x = "Measure")






# # ------------------------------------------------
# summarize by SpeciesGroup-----------------------

# adjacent
d14<-d3a%>%
  group_by(adjacent,SpeciesGroup)%>%
  summarize(
    assoc_body_n=n())%>%
  mutate(association=adjacent)%>%
  ungroup()%>%
  select(-adjacent)%>%
  glimpse()

# general proximity
d15<-d3a%>%
  group_by(general_prox,SpeciesGroup)%>%
  summarize(
    assoc_prox_n=n())%>%
  mutate(association=general_prox)%>%
  ungroup()%>%
  select(-general_prox)%>%
  glimpse()


#habitat
d16<-d3a%>%
  group_by(assoc_habitat2,SpeciesGroup)%>%
  summarize(
    assoc_hab_n=n())%>%
  mutate(association=assoc_habitat2)%>%
  ungroup()%>%
  select(-assoc_habitat2)%>%
  glimpse()


# merge
d17<-d14%>%
  full_join(d15)%>%
  full_join(d16)%>%
  select(SpeciesGroup,association,assoc_body_n,assoc_prox_n,assoc_hab_n)%>%
  # mutate(Association=if_else(is.na(association),"No Data",
  #                            if_else(association==1,"Associated","Not Associated")))%>%
  # mutate(Association_Prob=if_else(association==0,Association,
  #                                 if_else(association==1,"Probable Association", "Definite Association")))%>%
  arrange(association,-assoc_body_n)%>%
  glimpse()

d17



# unsummarized
write_csv(d3a,"./results/association_long.csv")

# fish,invert, algae
write_csv(d7,"./doc/association_fun_facts3.csv")

# fish,invert, algae
write_csv(d6,"./doc/association_fun_facts_habitat.csv")

# other groups
write_csv(d17,"./doc/association_fun_facts2_v3.csv")

