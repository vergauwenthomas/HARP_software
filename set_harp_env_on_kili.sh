#!/bin/bash
echo "Source this file !!!"

module purge

host=`echo ${HOSTNAME^^} | cut -f1 -d'.' `
module use /mnt/netapp/group/mealadin/${host}/modules




#MODULEPATH=${MODULEPATH}:/mnt/netapp/group/mealadin/KILI/modules/
#export MODULEPATH


#module load aladin/2021
module load R/4.0.4


#add Directory with R packages to the libpath
R_LIBS_USER='/mnt/netapp/group/mealadin/CS-MASK/software/R'
export R_LIBS_USER
