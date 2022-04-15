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

analyse_stations = c('knmi_VLISSINGENAWS', 'Vlinder37')

#surfex files
model = 'ICMSHAR07'
postfix_model = '.sfx'
field = 'SFX.T2M'

max_LT = 24

start_year = 2020
start_month = 8
start_day = 1
start_hour = 0

end_year = start_year
end_month = start_month
end_day = 3
end_hour = 23

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

cat('Analyse from ', startdatestring, ' --> ', enddatestring, ' for model ',model, ' with max LT: ', as.character(max_LT), '\n')

source(file.path(workdir, 'custom_functions.R'))


# ------------------------------------------------IO (forecaste and observations) ---------------------------------------------------


#show templates
# harpIO::show_file_templates()
# harpIO::show_harp_parameters()


#Get all stations (rejected and Ok)
station_df = read_station_df(stations_meta_df)

#check if sqlite file exists and if so, if you whant to overwrite it
if (dir.exists(file.path(fctable_folder, model))){
  cat('FC table already exist!! \n')
  terminal_input <- readline(prompt="overwrite sql fctable? (y/n): ")
  if (terminal_input == 'y'){ open_fc = TRUE}
  else{open_fc = FALSE}
}else{open_fc = TRUE}

if (open_fc){
  #Read in forecast, interpolate to stations location, and save as sqlite
 read_forecast(
    start_date    = startdatestring,           # the first forecast for which we have data
    end_date      = enddatestring,           # the last forecast for which we have data
    fcst_model     = model, # the name of the deterministic model as in the file name
    parameter     = field,                # We are going to read 2m temperature
    lead_time     = seq(0, max_LT, 1),        # We have data for lead times 0 - 48 at 3 hour intervals
    # by            = "1h",                 # We have forecasts every 6 hours
    file_path     = model_output_folder,    # We don't include AROME_Arctic_prod in the path...
    file_template = paste0("{file_path}/{YYYY}{MM}{DD}/{fcst_model}+{LDT4}", postfix_model), # ...because it's in the template
    return_data   = FALSE,                  # We want to get some data back - by default nothing is returned
    transformation_opts = interpolate_opts(stations = station_df,
                                           method="nearest",
                                           correct_t2m = TRUE,
                                           clim_file = clim_file), #TODO: check effect of temperature corrections
    transformation = 'interpolate',
    output_file_opts = sqlite_opts(path = fctable_folder) #output to sqlite format
  )
}

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

max_SID_in_fc = max(t2m$ICMSHAR07$SID)
cat("MAX SID IN FC: ", max_SID_in_fc)

#add unit K if it is not present (this is true for surfex files)
t2m[[model]]$units = 'K'



# ---------------------------------------------------------- adding observations to the interpolated forecast -----------------------------------------



#Read observations
obs = read_observations(obsfolder = obs_folder,
                        stationdf = station_df)

ok_obs = obs %>% filter(quality_flag == 'ok')



# Combine fcst with observations
t2m_joined = add_observations_to_fc(fcst = t2m,
                                    observations = ok_obs) #only the surviving observations





#-----------------------------------------------------------filter/subsetting forecast ----------------------------------------------------


#filter to one moment (fcdate or validdate)
fc_at_this_time = expand_date(t2m_joined, validdate) %>% filter(SID==16,
                                                         valid_year == 2020,
                                                         valid_month == 8,
                                                         valid_day == 1,
                                                         valid_hour == 2)


#---------------------------------------------------------Analyse at one point ------------------------------------------------------------

for (stationname in analyse_stations){
  fig1 = plot_at_station_level(fcst = t2m_joined,
                               stationname = stationname,
                               dateresolution = "1h")
  
  filename = paste0('T2m_at', stationname,'_for_', model, '.png')
  ggsave(
    file.path(figure_folder,filename),
    plot = fig1,
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

}



# ------------------------------------------------------Calculate basic scores --------------------------------------------------------------

fig2 = plot_basic_scores(t2m_joined)

filename = paste0('T2m_scores_for_', model, '.png')
ggsave(
  file.path(figure_folder,filename),
  plot = fig2,
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







