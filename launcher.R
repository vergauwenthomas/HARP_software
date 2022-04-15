#!/usr/bin/env Rscript

#localt machine thomas

local_thomas_id = '/home/thoverga'
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
  
  workdir = '/mnt/netapp/group/mealadin/CS-MASK/github/HARP_software'
  #running on Kili
  model_output_folder = '/mnt/netapp/group/mealadin/CS-MASK/github/HARP_software/input_data/fc'
  obs_folder = '/mnt/netapp/group/mealadin/CS-MASK/github/HARP_software/input_data/observations'
  clim_file = '/mnt/netapp/group/mealadin/CS-MASK/github/HARP_software/input_data/clim_m08'
  stations_meta_df = '/home/thoverga/fileserver/home/cs-mask/db/stations_df.csv'
  
  #output
  fctable_folder = '/mnt/netapp/group/mealadin/CS-MASK/github/HARP_software/output/FCTABLE'
  figure_folder = "/mnt/netapp/group/mealadin/CS-MASK/github/HARP_software/output/figures"
  
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
  model_output_folder = '/home/thoverga/Documents/github/HARP_software/input_data/model_output'
  obs_folder = '/home/thoverga/Documents/github/HARP_software/input_data/observations'
  stations_meta_df = '/home/thoverga/Documents/github/db/stations_df.csv'
  clim_file = '/home/thoverga/Documents/github/HARP_software/input_data/clim/clim_m08'
  #output
  fctable_folder = '/home/thoverga/Documents/github/HARP_software/output/FCTABLE'
  figure_folder = "/home/thoverga/Documents/github/HARP_software/output/figures"
  
}

setwd(workdir)
source("analyse.R")
