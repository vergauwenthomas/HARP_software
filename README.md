# HARP_software
Scripts used that are based on Harp


# Required software



# Run locally
In order to run this script, one has to adapt the paths to the data. These paths are handled by the script path_handlin.R. 
* `workdir`: The working directory
* `model_output_folder`: Where the model output is stored. The data is stored by subfolders (YYYYMMDD), for each subfolder it contains the model output (PFAR07...)
* `obs_folder`: This folder contains all the observations in the format of TITAN output. NOTE all files in this folder will be readed.
* `clim_file`: The location of the clim file. (This is used to get orography information)
* `fctable_folder`: The folder where the model sqlite files will be stored (format that is used by Harp).
