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
  select(-association_references,-habitat_reference)%>%
  glimpse()

length(unique(d1$species_id)) # 3 duplicates because 3 grenadier spp have 1 species_id (198)

# species group info
d2<-read_csv("./results/data_species_group2.csv")%>%
  select(-SpeciesName)%>%
  glimpse()


# join species group info to association info
d3a<-d1%>%
  left_join(d2)%>%
  unique()%>%
  glimpse()

unique(d3a$species_group2)

# remove algae
d3b<-d3a%>%
  filter(species_name!="Agar"& species_name!="Algae marine" & species_name!="Kelp giant")%>%
  glimpse()

#remove roe
d3<-d3b%>%
  filter(species_name!="Herring Pacific - roe"& species_name!="Herring Pacific - roe on kelp")%>%
  glimpse()


view(d3b)



d3$assoc_habitat[d3$assoc_habitat=="?"]<-999
d3$assoc_habitat<-as.numeric(d3$assoc_habitat)


unique(d3$species_group2)





# -------------------------------------------------------------
# update missing species groups - this includes basking sharks -----------------
# -------------------------------------------------------------

# ID missing for species that are not currently fished like abalone and basking shark
ID<-filter(d3,is.na(SpeciesGroup))%>%
  select(species_name,species_id,SpeciesGroup,species_group2)%>%
  arrange(species_id)%>%
  glimpse()




# -------------------------------------------------------------
# species group ------
# inverts
d3$species_group2[d3$species_id==702|d3$species_id==703|d3$species_id==704|d3$species_id==705|d3$species_id==706|d3$species_id==707|d3$species_id==708|d3$species_id==728]<-"Invertebrate"

# fish
d3$species_group2[d3$species_id==41|d3$species_id==212|d3$species_id==431]<-"Fish"

# basking shark -
d3$species_group2[d3$species_id==156]<-"Fish"

# check
unique(d3$species_group2)


# -------------------------------------------------------------
# SPECIES GROUP -----------
unique(d3$SpeciesGroup)

# inverts
d3$SpeciesGroup[d3$species_id==702|d3$species_id==703|d3$species_id==704|d3$species_id==705|d3$species_id==706|d3$species_id==707|d3$species_id==708|d3$species_id==728]<-"Shellfish"

# fish
d3$SpeciesGroup[d3$species_id==41|d3$species_id==212|d3$species_id==431]<-"All Other"

# basking shark 
d3$SpeciesGroup[d3$species_id==156]<-"All Other"





# -------------------------------------------------------------
# add in other information ------------------------------------
d3a<-d3%>%
  
  # body length
  mutate(assoc_body_length2=if_else(is.na(assoc_body_length ),"No Data",
                           if_else(assoc_body_length ==1,"Associated","Not Associated")))%>%
  
  # proximity
  mutate(assoc_proximity2=if_else(is.na(assoc_proximity ),"No Data",
                                     if_else(assoc_proximity ==1,"Associated","Not Associated")))%>%
  
  # habtiat
  mutate(assoc_habitat2=if_else(assoc_habitat==0,"Not Associated",
                                  if_else(assoc_habitat==1,"Probable Association", "Definite Association")))%>%
  mutate(Group=species_group2)%>%
  glimpse()

d3a

# figure out NAs
unique(d3a$assoc_habitat2)
view(d3a%>%filter(is.na(assoc_habitat2))) # these are all unspecified

d3a$assoc_habitat2[is.na(d3a$assoc_habitat2)]<-"Multispecies Group"
unique(d3a$assoc_habitat2)

# ----------------------------
# distinguish multispecies groups from no data in other associations

# body length
d3a$assoc_body_length2 [d3a$assoc_habitat2=="Multispecies Group"]<-"Multispecies Group"

# proximity
d3a$assoc_proximity2 [d3a$assoc_habitat2=="Multispecies Group"]<-"Multispecies Group"

unique(d3a$species_group2)

# examples of species with unknown associations (no Data) ----------------------------
d3a%>%
  filter(species_group2=="Invertebrate" & assoc_proximity2=="No Data")%>%
  select(species_name, depth_range:SpeciesGroup)

d3a%>%
  filter(species_group2=="Fish" & assoc_proximity2=="No Data")%>%
  select(species_name, depth_range:SpeciesGroup)

d3a%>%
  filter(species_group2=="Fish" & assoc_proximity2=="No Data")%>%
  select(species_name, depth_range:SpeciesGroup)

# ------------------------------------------------
# summarize by species group2-----------------------

# body length
d4<-d3a%>%
  group_by(assoc_body_length2,species_group2)%>%
  summarize(
    assoc_body_n=n())%>%
  mutate(association=assoc_body_length2)%>%
  ungroup()%>%
  select(-assoc_body_length2)%>%
  glimpse()

d4

# proximity
d5<-d3a%>%
  group_by(assoc_proximity2,species_group2)%>%
  summarize(
    assoc_prox_n=n())%>%
  mutate(association=assoc_proximity2)%>%
  ungroup()%>%
  select(-assoc_proximity2)%>%
  glimpse()
d5

#habitat
d6<-d3a%>%
  group_by(assoc_habitat2,species_group2)%>%
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
  select(species_group2,association,assoc_body_n,assoc_prox_n,assoc_hab_n)%>%
  mutate(group=species_group2)%>%
  select(-species_group2,group,association:assoc_hab_n)%>%
  glimpse()

d7

#total sp
d7%>%
  summarize(
    assoc_tot=sum(assoc_body_n,na.rm=T)
  )%>%
  glimpse()

# groups()
d7%>%
  group_by(group)%>%
  summarize(
    assoc_tot=sum(assoc_body_n,na.rm=T)
  )%>%
  glimpse()

# # ------------------------------------------------
# summarize by SpeciesGroup-----------------------

# body length
d14<-d3a%>%
  group_by(assoc_body_length2,SpeciesGroup)%>%
  summarize(
    assoc_body_n=n())%>%
  mutate(association=assoc_body_length2)%>%
  ungroup()%>%
  select(-assoc_body_length2)%>%
  glimpse()

# proximity
d15<-d3a%>%
  group_by(assoc_proximity2,SpeciesGroup)%>%
  summarize(
    assoc_prox_n=n())%>%
  mutate(association=assoc_proximity2)%>%
  ungroup()%>%
  select(-assoc_proximity2)%>%
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
write_csv(d7,"./doc/association_fun_facts2.csv")

# fish,invert, algae
write_csv(d6,"./doc/association_fun_facts_habitat.csv")

# other groups
write_csv(d17,"./results/association_fun_facts2_v2.csv")