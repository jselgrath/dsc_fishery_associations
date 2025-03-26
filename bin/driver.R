# Jenny Selgrath
# NOAA CINMS
# Deep Sea Coral Valuation

# goal: driver for association data
# ---------------------------------------------------
library(tidyverse)

# ---------------------------------------------------
remove(list=ls())
setwd("C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/")

# ------------------------------------------
# combine fish ticket data from 2025 agreement
source("./bin/landed_sp_2010_2024.R")
# input:    C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/data/MLDS_2025/.....csv  (Fishtix 2010-2020)
# output:   ./results/fishtix_spp_2010_2024.csv
#           ./results/fishtix_spp_2010_2024_landing_no.csv

# landing category record numbers and remove fresh, algae, eggs/roe
source("./bin/organize_fish_ticket_data.R")
# output:   ./results/lc_record_no.csv

# upload, remove extra columns, remove freshwater spp
source("./bin/1_clean_files.R")
# input:    ./data/fishtix_assoc_20240520.csv
# output:   ./results/fishtix_assoc_clean_no_fresh.csv
#           ./results/fishtix_assoc_clean.csv


# summary statistics for association measures by type of catch (e.g., invert), remove algae
source("./bin/fun_facts_assoc3.R") # use 2 version from google drive for older code
# input:    ./results/fishtix_assoc_clean_no_fresh.csv
#           ./results/data_species_group2.csv
# output:   ./doc/association_fun_facts2.csv # fish, invert, algae
#           ./doc/association_fun_facts2_v2.csv # econ groups - DO NOT USE
#           ./doc/association_long.csv


# graph of associations
source("./bin/fun_facts_assoc2_graph.R")
# input:    ./doc/association_long.csv
# output:   

# used in text of results
source("./bin/summary_stats.R")
# input:    ./doc/association_fun_facts2.csv
# output:   ./doc/assoc_bl_prox.csv
#           ./doc/assoc_hab.csv

#Fig 4.  reference types used in analysis
source("./bin/figx_reference_type.R")
# input:    
# output:   

# Tables
source("./bin/table_s1_and_table_1.R")
# input:    ./results/association_long.csv
# output:   ./doc/table_s1.csv
#           ./doc/table_1.csv

# input:    
# output:   

# input:    
# output:   

