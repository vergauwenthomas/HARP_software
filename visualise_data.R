library(proj4)
library(meteogrid)
library(Rfa)

datadir = '/media/thoverga/WORK/init_lumi_fc'
# fc_file = '20200801/ICMSHAR07+0003.sfx' 
file = file.path(datadir,'model_output', '20200801', 'ICMSHAR07+0003.sfx') #surfex file
# file = file.path(datadir,'model_output', '20200801', 'PFAR07csm07+0003') #arome file
# file = file.path(datadir,'clim', 'clim_m08') #clim file


x=Rfa::FAopen(file)

variables = x$list
print(variables)

# fieldname='INTSURFGEOPOTENT'
# 
# y=Rfa::FAdec(x, fieldname)
# iview(y)
