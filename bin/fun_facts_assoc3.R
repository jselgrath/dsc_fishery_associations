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
  # mutate(species_group2=group)%>%
  # select(-association_references,-habitat_reference)%>%
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
  left_join(d2)%>%
  unique()%>%
  glimpse()

# d1$assoc_habitat
# d1$assoc_habitat[d1$assoc_habitat=="Multispecies group"]<-999
# d1$assoc_habitat<-as.numeric(d1$assoc_habitat)

# figure out NAs --------------
unique(d3$assoc_habitat)
# view(d3a%>%filter(is.na(assoc_habitat2))) # these are all unspecified



# -------------------------------------------------------------
# update missing species groups - this includes basking sharks -----------------
# -------------------------------------------------------------

# ID missing for species that are not currently fished like abalone and basking shark
# can be used iteratively after run  code below to check
ID<-filter(d3,is.na(SpeciesGroup))%>%
  select(species_name,species_id,SpeciesGroup,species_group2)%>%
  arrange(species_id)%>%
  glimpse()




# -------------------------------------------------------------
# species group ------
# fixed outside R so not all needed

# # inverts
# d3$species_group2[d3$species_id==702|d3$species_id==703|d3$species_id==704|d3$species_id==705|d3$species_id==706|d3$species_id==707|d3$species_id==708|d3$species_id==728|d3$species_id==723]<-"Invertebrate"
# 
# # fish
# d3$species_group2[d3$species_id==41|d3$species_id==212|d3$species_id==431|d3$species_id==275|d3$species_id==477]<-"Fish"
# 
# # basking shark -
# d3$species_group2[d3$species_id==156]<-"Fish"
# 
# # check
# unique(d3$species_group2)
# 

# -------------------------------------------------------------
# SPECIES GROUP -----------
# unique(d3$SpeciesGroup)
# 
# # inverts
# d3$SpeciesGroup[d3$species_id==702|d3$species_id==703|d3$species_id==704|d3$species_id==705|d3$species_id==706|d3$species_id==707|d3$species_id==708|d3$species_id==728|d3$species_id==723]<-"Shellfish"
# 
# # fish
# d3$SpeciesGroup[d3$species_id==41|d3$species_id==212|d3$species_id==431|d3$species_id==275]<-"All Other"
# 
# d3$SpeciesGroup[d3$species_id==477]<-"Rockfish"
# 
# # basking shark 
# d3$SpeciesGroup[d3$species_id==156]<-"All Other"




# 
# # -------------------------------------------------------------
# # add in other information ------------------------------------
d3a<-d3%>%

  # # adjacent
  # mutate(adjacent2=if_else(is.na(adjacent ),"No Data",
  #                          if_else(adjacent ==1,"Associated","Not Associated")))%>%
  # 
  # # proximity
  # mutate(general_prox2=if_else(is.na(general_prox ),"No Data",
  #                                    if_else(general_prox ==1,"Associated","Not Associated")))%>%

  # habtiat
  mutate(assoc_habitat2=if_else(habitat_depth ==0,"Not associated",
                                if_else(habitat_depth ==1,"Probable association", 
                                        if_else(habitat_depth ==2,"Definite association",habitat_depth))))%>%
  mutate(Group=species_group2)%>%
  glimpse()

d3a




# ----------------------------
# distinguish multispecies groups from no data in other associations

# # body length
# d3a$adjacent [d3a$assoc_habitat2=="Multispecies Group"]<-"Multispecies Group"
# 
# # proximity
# d3a$general_prox [d3a$assoc_habitat2=="Multispecies Group"]<-"Multispecies Group"
# 
# unique(d3a$species_group2)
# 
# examples of species with unknown associations (no Data) ----------------------------
d3%>%
  filter(group=="Invertebrate" & general_prox=="No data")%>%
  select(species_id,species_name, depth_min_m:SpeciesGroup)

d3%>%
  filter(group=="Fish" & general_prox=="No data")%>%
  select(species_name, depth_min_m:SpeciesGroup)



# ------------------------------------------------
# summarize by species group2-----------------------

# adjacent
d4<-d3%>%
  group_by(adjacent,group)%>%
  summarize(
    adjacent_n=n())%>%
  mutate(association=adjacent)%>%
  ungroup()%>%
  select(-adjacent)%>%
  glimpse()

d4

# general proximity
d5<-d3%>%
  group_by(general_prox,group)%>%
  summarize(
    general_prox_n=n())%>%
  mutate(association=general_prox)%>%
  ungroup()%>%
  select(-general_prox)%>%
  glimpse()
d5

#habitat
d6<-d3a%>%
  group_by(assoc_habitat2,group)%>%
  summarize(
    assoc_hab_n=n())%>%
  mutate(association=assoc_habitat2)%>%
  ungroup()%>%
  select(-assoc_habitat2)%>%
  glimpse()
d6

# merge
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



# # ------------------------------------------------
# summarize by SpeciesGroup-----------------------

# body length
d14<-d3a%>%
  group_by(adjacent,SpeciesGroup)%>%
  summarize(
    assoc_body_n=n())%>%
  mutate(association=adjacent)%>%
  ungroup()%>%
  select(-adjacent)%>%
  glimpse()

# proximity
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
  # select(SpeciesGroup,association,assoc_body_n,assoc_prox_n,assoc_hab_n)%>%
  # mutate(Association=if_else(is.na(association),"No Data",
  #                            if_else(association==1,"Associated","Not Associated")))%>%
  # mutate(Association_Prob=if_else(association==0,Association,
  #                                 if_else(association==1,"Probable Association", "Definite Association")))%>%
  glimpse()

d17



# unsummarized
write_csv(d3a,"./results/association_long.csv")

# fish,invert, algae
write_csv(d7,"./doc/association_fun_facts3.csv")

# fish,invert, algae
write_csv(d6,"./doc/association_fun_facts_habitat.csv")

# other groups
write_csv(d17,"./results/association_fun_facts2_v3.csv")
