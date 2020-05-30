##############################################################################################################
# 
# 
# Program to process weather data from the University Park Airport AWOS weather station 
# 
#    USAF-WBAN_ID STATION NAME                   COUNTRY                                            STATE 			      LATITUDE LONGITUDE ELEVATION
# ------------ ------------------------------ -------------------------------------------------- ------------------------------ -------- --------- ---------
#  725128 54739 UNIVERSITY PARK AIRPORT        UNITED STATES                                      PENNSYLVANIA                    +40.850  -077.850   +0377.7
# 
# 
#  Felipe Montes 2020/04/10
# 
# 
# 
# 
############################################################################################################### 



###############################################################################################################
#                             Tell the program where the package libraries are stored                        
###############################################################################################################


#  Tell the program where the package libraries are  #####################

.libPaths("C:/Felipe/SotwareANDCoding/R_Library/library")  ;


###############################################################################################################
#                             Setting up working directory  Loading Packages and Setting up working directory                        
###############################################################################################################


#      set the working directory

# readClipboard()

setwd("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\WeatherUniversityParkAirport") ;   # 



###############################################################################################################
#                            Install the packages that are needed                       
###############################################################################################################


# Install the packages that are needed #

# install.packages('fields', dep=T)

# install.packages('LatticeKrig', dep=T)

# install.packages('rgeos', dep=T)

# install.packages('RColorBrewer', dep=T)

# install.packages('rgdal', dep=T)

# install.packages('sp', dep=T)

# install.packages('raster', dep=T)

# install.packages('openxlsx', dep=T)

# install.packages('openxlsx', dep=T)

# install.packages('randomForest', dep=T)

# install.packages('lattice', dep=T)

# install.packages('stringi', dep=T)

# install.packages('rgl', dep=T)

# install_github('sorhawell/forestFloor')

# install.packages('nlme', dep=T)

# install.packages('nlme', dep=T)

###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################

library(randomForest)

library(RColorBrewer)

library(openxlsx)

library(lattice)

library(devtools)

# library(forestFloor)

# library(rgl)

library(raster)

library(nlme)

###############################################################################################################
#                           Read the data from the text files
###############################################################################################################

University.Park.Weather.Cols<-read.table(file='6094568232309dat.txt', header=F, as.is=T, nrows = 1) ;

University.Park.Weather<-read.csv(file='4779668232165dat.txt', header=F, as.is=T, nrows = 1, skip=1000) ;
