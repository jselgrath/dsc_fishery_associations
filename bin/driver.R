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
# output:   ./results/fishtix_spp_2010_2024.csv             # species list
#           ./results/fishtix_spp_2010_2024_landing_no.csv  # number of landings in each category


# landing category record numbers and remove fresh, algae, eggs/roe
source("./bin/organize_fish_ticket_data.R")
# input:    ./data/dsc_val_associations_freshwater2.csv
#           ./results/fishtix_spp_2010_2024_landing_no.csv
# output:   ./results/lc_record_no_fresh.csv


# upload, remove extra columns
source("./bin/clean_files.R")
# input:    ./data/fishtix_assoc_20240520.csv
# output:   ./results/fishtix_assoc_clean_no_fresh.csv
#           ./doc/fishtix_landings_by_group.csv  # results for first paragraph of results section


# summary statistics for association measures by type of catch (e.g., invert), remove algae
source("./bin/summary_stats1.R") # use 2 version from google drive for older code
# input:    ./results/fishtix_assoc_clean_no_fresh.csv
#           ./results/data_species_group3.csv
# output:   ./doc/association_long.csv
#           ./doc/association_fun_facts3.csv # fish, invert
#           ./doc/association_fun_facts_habitat.csv # econ groups - DO NOT USE
#           ./results/association_fun_facts2_v3.csv

# used in text of results
source("./bin/summary_stats2.R")
# input:    ./doc/association_fun_facts2.csv
# output:   ./doc/assoc_bl_prox.csv
#           ./doc/assoc_hab.csv

# graph of associations - now figures 3 & 4
source("./bin/fig3_graph.R")
# input:    ./doc/association_long.csv
# output:   ./doc/fig3_adjacent.tiff
#           ./doc/fig3_prox.tiff
#           ./doc/fig3_hab.tiff


#Fig 4.  reference types used in analysis
source("./bin/figS1_reference_type.R")
# input:    ./data/table_s2_20250327.csv
# output:   fig_s1_reference_type.tiff


# Tables
source("./bin/table_s1_and_table_1.R")
# input:    ./results/association_long.csv
# output:   ./doc/table_s1.csv
#           ./doc/table_1.csv


# gear analysis step1
source("./bin/gear_landed_sp_2010_2024.R")
# input:    C:/Users/jennifer.selgrath/Documents/research/R_projects/dsc_associations_fishery/data/MLDS_2025/.....csv  (Fishtix 2010-2020)
# output:   ./results/gear_fishtix_spp_2010_2024.csv             # species list with gear info etc

# remove freshwater spp
source("./bin/gear_no_fresh.R")
# input:  ./results/fishtix_spp_2010_2024_gear.csv
#         ./data/dsc_val_associations_freshwater2.csv
# output  ./results/gear_fishtix_spp_2010_2024_no_fresh.csv


# summarize gears 
source("./bin/gear_summary.R")
# input: ./results/fishtix_spp_2010_2024_gear_no_fresh.csv
# output: ./doc/gear_landing_category_wide_20251008.csv
#         ./doc/gear_group_landing_category_wide_20251008.csv

# gears related to associated species
source("./bin/sfi_assoc_gears.R")
# input:  ./results/association_long.csv
#         ./results/trip_tix_ca_with_groups.csv
# output: ./results/gear_species_number.csv
#         ./results/gear_top_species_number.csv
#         ./results/species_gear_number.csv


