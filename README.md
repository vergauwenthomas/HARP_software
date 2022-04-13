# About Harp
Harp is software for NWP analysis, verification and visualization. The github can be found here: https://github.com/harphub

An introduction to harp can be found here: https://harphub.github.io/harp_tutorial/


# HARP_software
Scripts used in the CS-MASK project that are based on Harp. 
`analyse.R` is the script that will analyse the forecast using non-traditional observations (T2m).
`visualise_data.R` is a basic Rfa visualisation script (This will be incorporated in analyse in comming updates)
`path_handling.R` handles the specific paths to folders so it can smoothly be run on different machines. Just add your paths. 
`custom_functions.R` Some custom functions to make visuals, and to load the TITAN observations in Harp. 


# Required software

software to install
* proj4: See installation document https://proj.org/install.html. This is already prepared in the conda env (harp_env). This can be installed with `conda env create -f environment.yml` and then `conda activate harp_env`.

R packages to install
* remotes: use Rstudio installer
* meteogrid: from git: https://github.com/harphub/meteogrid
* Rfa: from RMI gitlab: https://gitlab-me.oma.be/aladin/Rfa (Send me an email if you can connect thomas.vergauwen@meteo.be)(note to myself: donwload from gitlab and install as .tar.gz)
* harp: See installation notes in the ReadMe: https://github.com/harphub/harp. (Make shure to link with the proj4 software installation!)
* tidyverse: use Rstudio installer

# Run locally
In order to run this script, one has to adapt the paths to the data. These paths are handled by the script path_handlin.R. 
* `workdir`: The working directory
* `model_output_folder`: Where the model output is stored. The data is stored by subfolders (YYYYMMDD), for each subfolder it contains the model output (PFAR07...)
* `obs_folder`: This folder contains all the observations in the format of TITAN output. NOTE all files in this folder will be readed.
* `clim_file`: The location of the clim file. (This is used to get orography information)
* `fctable_folder`: The folder where the model sqlite files will be stored (format that is used by Harp).
