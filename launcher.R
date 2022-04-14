#!/usr/bin/env Rscript

#localt machine thomas

local_thomas_id = '/home/thoverga'
kili_id = '/fileserver/home'


if (grepl( kili_id, getwd(), fixed = TRUE)){
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
  
  
  #running on Kili
  workdir = '/home/thoverga/Documents/Thesis studenten/project AM/data_vis_tests'
  model_output_folder = '/mnt/HDS_ALD_DATA/ALD_DATA/thoverga/testrun_LUMI/fc'
  obs_folder = '/media/thoverga/WORK/init_lumi_fc/observations'
  fctable_folder = '/media/thoverga/WORK/init_lumi_fc/FCTABLE'
  clim_file = '/mnt/HDS_ALD_DATA/ALD_DATA/thoverga/testrun_LUMI/clim_m08'
  
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
  clim_file = '/home/thoverga/Documents/github/HARP_software/input_data/clim/clim_m08'
  #output
  fctable_folder = '/home/thoverga/Documents/github/HARP_software/output/FCTABLE'
  figure_folder = "/home/thoverga/Documents/github/HARP_software/output/figures"
  
}

setwd(workdir)
source("analyse.R")
