#library(proj4) #see website + install package proj4 installed in conda env --> link --with-proj = /home/thoverga/anaconda3/envs/harp_env/include/proj
# library(meteogrid) #from git
# library(Rfa) #from .gz.tar file
# library(harp) #from git: remotes::install_github("harphub/harpIO")
# library(tidyverse)
# library(harpVis) #from git



#harptutorial: https://harphub.github.io/harp_tutorial/index.html


#Note: Reading error is resolved after executing the visualise_data.R script. I think this is because of the dependency on Rfa?? I explicitly load it now.

#-------------------------------------------------------Analysis settings -------------------------------------------------------------------
#specify forecast

#arome files
# model='PFAR07csm07'
# postfix_model = '' #no postfix
# field = 'T2m' #should be in show_harp_parameters

#surfex files
model = 'ICMSHAR07'
postfix_model = '.sfx'
field = 'SFX.T2M'

max_LT = 3

start_year = 2020
start_month = 8
start_day = 1
start_hour = 0

end_year = start_year
end_month = start_month
end_day = 1
end_hour = 5

# -------------------------------------------------start analysis ---------------------------------------------------------------


startdatestring = paste0(as.character(start_year),
                         str_pad(as.character(start_month), 2, side = "left", pad = "0"),
                         str_pad(as.character(start_day), 2, side = "left", pad = "0"),
                         str_pad(as.character(start_hour), 2, side = "left", pad = "0")
                         )

enddatestring = paste0(as.character(end_year),
                         str_pad(as.character(end_month), 2, side = "left", pad = "0"),
                         str_pad(as.character(end_day), 2, side = "left", pad = "0"),
                         str_pad(as.character(end_hour), 2, side = "left", pad = "0")
)


source(file.path(workdir, 'custom_functions.R'))


# ------------------------------------------------IO (forecaste and observations) ---------------------------------------------------


#show templates
# harpIO::show_file_templates()
# harpIO::show_harp_parameters()


#Read observations
obs = read_custom_observations(obsfolder = obs_folder)
station_df = obs %>% arrange(SID) %>% filter(duplicated(SID) == FALSE) %>% select(SID, lat, lon, elev)

print(station_df)

#Read in forecast, interpolate to stations location, and save as sqlite
fcst = read_forecast(
  start_date    = startdatestring,           # the first forecast for which we have data
  end_date      = enddatestring,           # the last forecast for which we have data
  fcst_model     = model, # the name of the deterministic model as in the file name
  parameter     = field,                # We are going to read 2m temperature
  lead_time     = seq(0, max_LT, 1),        # We have data for lead times 0 - 48 at 3 hour intervals
  # by            = "1h",                 # We have forecasts every 6 hours
  file_path     = model_output_folder,    # We don't include AROME_Arctic_prod in the path...
  file_template = paste0("{file_path}/{YYYY}{MM}{DD}/{fcst_model}+{LDT4}", postfix_model), # ...because it's in the template
  return_data   = TRUE,                  # We want to get some data back - by default nothing is returned
  transformation_opts = interpolate_opts(stations = station_df,
                                         method="nearest",
                                         correct_t2m = TRUE,
                                         clim_file = clim_file), #TODO: check effect of temperature corrections
  transformation = 'interpolate',
  output_file_opts = sqlite_opts(path = fctable_folder) #output to sqlite format
)


#NOTE
  # fcdate = the date the forecast has started (so at midnight)
  # validdate = the date of the forcasted output (so to compair with observations at this time)


#open the forcast sqlite data (not shure if this is necesarry as i assume is the same as fcst)

t2m <- read_point_forecast(
  start_date = startdatestring,
  end_date   = enddatestring,
  fcst_model = model,
  fcst_type  = "det",
  parameter  = field,
  lead_time = seq(0, max_LT, 1),
  # by         = "6h",
  file_path  = fctable_folder,
  file_template = "{file_path}/{fcst_model}/{YYYY}/{MM}/FCTABLE_{parameter}_{YYYY}{MM}_{HH}.sqlite"
)

#add unit K if it is not present (this is true for surfex files)
t2m[[model]]$units = 'K'



# ---------------------------------------------------------- adding observations to the interpolated forecast -----------------------------------------

#subset observations by time
starttime = as.POSIXct(startdatestring,format="%Y%m%d%H")
endtime = as.POSIXct(enddatestring,format="%Y%m%d%H")
relevant_obs = obs %>% filter(validdate >= starttime) %>% filter(validdate <= endtime)
#add observations to the fct
t2m = join_to_fcst(t2m, relevant_obs,
                   join_type = 'inner', #TODO: er geraken rijen in de fc verloren, hoe komt dit?
                   by=c('SID', 'validdate'))



#-----------------------------------------------------------filter/subsetting forecast ----------------------------------------------------


#filter to one moment (fcdate or validdate)
fc_at_this_time = expand_date(t2m, validdate) %>% filter(SID==16,
                                                         valid_year == 2020,
                                                         valid_month == 8,
                                                         valid_day == 1,
                                                         valid_hour == 2)




#---------------------------------------------------------Analyse at one point ------------------------------------------------------------
stationname = 'synop_Melle'

plot_at_station_level(fcst = t2m,
                      observations = obs,
                      stationname = stationname,
                      dateresolution = "1h")

filename = paste0('T2m_at', stationname,'_for_', model, '.png')
ggsave(
  file.path(figure_folder,filename),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 1,
  width = NA,
  height = NA,
  units = c("in", "cm", "mm", "px"),
  dpi = 300,
  limitsize = TRUE,
  bg = NULL
)


# ------------------------------------------------------Calculate basic scores --------------------------------------------------------------

plot_basic_scores(t2m)

filename = paste0('T2m_scores_for_', model, '.png')
ggsave(
  file.path(figure_folder,filename),
  plot = last_plot(),
  device = NULL,
  path = NULL,
  scale = 1,
  width = NA,
  height = NA,
  units = c("in", "cm", "mm", "px"),
  dpi = 300,
  limitsize = TRUE,
  bg = NULL
)






