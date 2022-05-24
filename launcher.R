#!/usr/bin/env Rscript

#localt machine thomas

local_thomas_id = '/home/thoverga'
local_tom_id = '/home/tomvdp'
local_brecht_id = '........'
kili_id_1 = '/fileserver/home'
kili_id_2 = '/group/mealadin'

if (grepl( kili_id_1, getwd(), fixed = TRUE) || grepl( kili_id_2, getwd(), fixed = TRUE)){
  cat('Running on Kili')
  #Loading packages (normal location)
  library("meteogrid", lib.loc="/mnt/netapp/group/mealadin/CS-MASK/software/R")
  library("harpIO", lib.loc="/mnt/netapp/group/mealadin/CS-MASK/software/R")
  library("harpPoint", lib.loc="/mnt/netapp/group/mealadin/CS-MASK/software/R")
  library("harpVis", lib.loc="/mnt/netapp/group/mealadin/CS-MASK/software/R")
  library("harpSpatial", lib.loc="/mnt/netapp/group/mealadin/CS-MASK/software/R")
  library("harp", lib.loc="/mnt/netapp/group/mealadin/CS-MASK/software/R")
  library(Rfa)
  library(tidyverse)
  library("here")
  workdir = here()
  
  #running on Kili
  model_output_folder = file.path(workdir, 'input_data', 'fc')
  obs_folder = file.path(workdir, 'input_data', 'observations')
  clim_file = file.path(workdir, 'input_data', 'clim_m08')
  stations_meta_df = file.path('input_data', 'stations_df.csv')
  
  fc_folder_structure = "{file_path}/{YYYY}{MM}{DD}/{fcst_model}+{LDT4}"
  
  #output
  fctable_folder = file.path(workdir, 'output', 'FCTABLE')
  figure_folder = file.path(workdir, 'output', 'figures')
  
  #do not use ggplot bus basic r graphics
  use_ggplot = TRUE
  
  #Do not overwrite outputtable
  do_not_overwrite_fctable = FALSE
}



if (grepl( local_thomas_id, getwd(), fixed = TRUE)){
  cat('Running on local machine Thomas')
  
  
  library(meteogrid) #from git
  library(Rfa) #from .gz.tar file
  library(harp) #from git: remotes::install_github("harphub/harpIO")
  library(tidyverse)
  
  #running on local machine thomas
  workdir = '/home/thoverga/Documents/github/HARP_software'
  #input
  # model_output_folder = '/home/thoverga/Documents/github/HARP_software/input_data/model_output'
  model_output_folder = '/home/thoverga/LUMI_scratch_mount/experiment1/work'
  obs_folder = '/home/thoverga/Documents/github/TITAN_software/cs-data/output'
  stations_meta_df = '/home/thoverga/Documents/github/db/stations_df.csv'
  clim_file = '/home/thoverga/Documents/github/HARP_software/input_data/clim/clim_m08'
  
  fc_folder_structure = "{file_path}/{YYYY}{MM}{DD}/fc/{fcst_model}+{LDT4}"
  
  #output
  # fctable_folder = '/home/thoverga/Documents/github/HARP_software/output/FCTABLE_kili'
  fctable_folder = '/media/thoverga/WORK/init_lumi_fc/full_month_FCTABLE'
  figure_folder = "/home/thoverga/Documents/github/HARP_software/output/figures"
  
  #use ggplot instead of basic r graphics
  use_ggplot = TRUE
  do_not_overwrite_fctable = TRUE
  
}

if (grepl( local_tom_id, getwd(), fixed = TRUE)){
  cat('Running on local machine Tom')
  
  
  library(meteogrid) #from git
  library(Rfa) #from .gz.tar file
  library(harp) #from git: remotes::install_github("harphub/harpIO")
  library(tidyverse)
  
  #running on local machine tom
  workdir = '/home/tomvdp/Documenten/AM_project/HARP_software'
  #input
  # model_output_folder = '/home/tomvdp/Documenten/AM_project/HARP_software/input_data/model_output'
  # obs_folder = '/home/tomvdp/Documenten/HARP_software/input_data/observations'
  # stations_meta_df = '/home/thoverga/Documents/github/db/stations_df.csv'
  # clim_file = '/home/thoverga/Documents/github/HARP_software/input_data/clim/clim_m08'
  
  fc_folder_structure = "{file_path}/{YYYY}{MM}{DD}/fc/{fcst_model}+{LDT4}"
  
  #output
  fctable_folder = '/home/tomvdp/Documenten/AM_project/HARP_software/output/FCTABLE'
  figure_folder = "/home/tomvdp/Documenten/AM_project/HARP_software/output/figures"
  
  #use ggplot instead of basic r graphics
  use_ggplot = TRUE
  do_not_overwrite_fctable = TRUE
  
}

if (grepl( local_brecht_id, getwd(), fixed = TRUE)){
  cat('Running on local machine Brecht')
  
  
  library(meteogrid) #from git
  library(Rfa) #from .gz.tar file
  library(harp) #from git: remotes::install_github("harphub/harpIO")
  library(tidyverse)
  
  #running on local machine tom
  workdir = ' .... '
  #input
  # model_output_folder = '/home/tomvdp/Documenten/AM_project/HARP_software/input_data/model_output'
  # obs_folder = '/home/tomvdp/Documenten/HARP_software/input_data/observations'
  # stations_meta_df = '/home/thoverga/Documents/github/db/stations_df.csv'
  # clim_file = '/home/thoverga/Documents/github/HARP_software/input_data/clim/clim_m08'
  fc_folder_structure = "{file_path}/{YYYY}{MM}{DD}/fc/{fcst_model}+{LDT4}"
  
  #output
  fctable_folder = ' .... '
  figure_folder = " .... "
  
  #use ggplot instead of basic r graphics
  use_ggplot = TRUE
  do_not_overwrite_fctable = TRUE
  
}



setwd(workdir)
source("analyse.R")
