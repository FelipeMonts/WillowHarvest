##############################################################################################################
# 
# 
# Program to manage and analyze willow harvest research data
# 
#    
# 
# 
#  Felipe Montes 2020/02/19
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

#readClipboard()
setwd("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\WillowHarvest") ;   # 



###############################################################################################################
#                            Install the packages that are needed                       
###############################################################################################################


# Install the packages that are needed #






###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################
library(rgdal) ; 

library(soilDB) ;

library(aqp) ;


library(openxlsx);


###############################################################################################################
#                           load willow harvest data from 2015
###############################################################################################################
#readClipboard()
Harvest2015<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Yield Data\\RockviewWillowHarvest_chips20160222 (1).xlsx", sheet= "PivotTable", startRow = 1 ,colNames = T , cols= c(seq(1,9)), rows=c(seq(1,133)) );

#View(Harvest2015)
#str(Harvest2015)

names(Harvest2015)

#### convert the row and the variety data to factors

Harvest2015$Row<-as.factor(Harvest2015$`Actual.Row.#`) ;

#levels(Harvest2015$Row)

Harvest2015$Cultivar<-as.factor(Harvest2015$Variety) ;

#levels(Harvest2015$Cultivar)





