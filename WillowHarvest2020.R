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

library(sp) ;


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

Harvest2015$Factor.Row<-as.factor(Harvest2015$`Actual.Row.#`) ;

#levels(Harvest2015$Factor.Row)

Harvest2015$Cultivar<-as.factor(Harvest2015$Variety) ;

#levels(Harvest2015$Cultivar)



###############################################################################################################
#                           load willow harvest data from 2019
###############################################################################################################
#readClipboard()
Harvest2019<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Wilow Harvest 2019\\RockviewWillowHarvest2019V2.xlsx", sheet= "Yield", startRow = 2 ,colNames = T , cols= c(seq(1,10)), rows=c(seq(1,134)) );

#View(Harvest2019)
#str(Harvest2015)

names(Harvest2019)

#### convert the row and the variety data to factors

Harvest2019$Factor.Row<-as.factor(Harvest2019$Row) ;

#levels(Harvest2019$Factor.Row)

Harvest2019$Cultivar<-as.factor(Harvest2019$Variety) ;

#levels(Harvest2019$Cultivar)


###############################################################################################################
#                           load Willow field GIS Maps
###############################################################################################################

#################    Tractor GPS Coverage Maps ######################

########### Read infor mation about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\BrianGISFile Tractor\\Coverage.shp")  ; 


#### read the shape file 

TractorGPS.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\BrianGISFile Tractor\\Coverage.shp")  ;

#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  

TractorGPS<-spTransform(TractorGPS.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )


Proj4
+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

 plot(TractorGPS)

#################    Plots  and varieties  ######################

########### Read infor mation about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\RockviewPlotsV3AR7.shp")  ; 


#### read the shape file 

PlotsData.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\RockviewPlotsV3AR7.shp")  ;
 
#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  
 
PlotsData<-spTransform(PlotsData.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )
 

plot(PlotsData, lwd=2, border="CYAN", add=T)


#################                         Plant population estimates  based on the 0 ,1 ,2 survey system              ######################

#########################            Plants_0 2013                          ###########################

########### Read information about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_0.shp")  ; 
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_part2_0.shp")  ; 


#### read the shape files 

Plants_0.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_0.shp")  ;
Plants_0.2<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_part2_0.shp")  ;


#### Aggreate the sape files into one

Plants_0_all<-rbind(Plants_0.1,Plants_0.2) ;

#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  

Plants_0_2013<-spTransform(Plants_0_all, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_0_2013, pch=20, col="RED", add=T) ;


#########################            Plants_1 2013                        ###########################

########### Readinfor mation about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_1.shp")  ; 
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_part2_1.shp")  ; 


#### read the shape file 

Plants_1.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_1.shp")  ;
Plants_1.2<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_part2_1.shp")  ;


#### Aggreate the sape files into one

Plants_1_all<-rbind(Plants_1.1,Plants_1.2) ;

#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  

Plants_2_2013<-spTransform(Plants_1_all, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_2_2013, pch=20, col="BLUE", add=T) ;



#########################            Plants_2 2013                        ###########################


########### Read information about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_2.shp")  ;
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_part2_2.shp")  ;


#### read the shape file 

Plants_2.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_2.shp")  ;
Plants_2.2<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\Plants_part2_2.shp")  ;

#### Aggreate the shape files into one

Plants_2_all<-rbind(Plants_2.1,Plants_2.2) ;

#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  

Plants_2_2013<-spTransform(Plants_2_all, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_2_2013, pch=20, col="DARKGREEN", add=T) ;



#########################            Plants_0 2014                        ###########################

########### Read information about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-09.10.11-plants0.shp")  ;
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-10_plants0.shp")  ;


#### read the shape file 

Plants_0.1.2014<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-09.10.11-plants0.shp")  ;
Plants_0.2.2014<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-10_plants0.shp")  ;


#### Aggreate the shape files into one

Plants_0_all.2014<-rbind(Plants_0.1.2014,Plants_0.2.2014) ;

#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  

Plants_0_all.2014<-spTransform(Plants_0_all.2014, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_0_all.2014, pch=20, col="RED", add=T) ;


#########################            Plants_1 2014                        ###########################

########### Read information about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-09.10.11-plants1.shp")  ;
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-10_plants1.shp")  ;


#### read the shape file 

Plants_1.1.2014<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-09.10.11-plants1.shp")  ;
Plants_1.2.2014<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-10_plants1.shp")  ;


#### Aggreate the shape files into one

Plants_1_all.2014<-rbind(Plants_1.1.2014,Plants_1.2.2014) ;

#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  

Plants_1_all.2014<-spTransform(Plants_1_all.2014, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_1_all.2014, pch=20, col="BLUE", add=T) ;


#########################            Plants_2 2014                        ###########################

########### Read information about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-09.10.11-plants2.shp")  ;
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-10_plants2.shp")  ;


#### read the shape file 

Plants_2.1.2014<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-09.10.11-plants2.shp")  ;
Plants_2.2.2014<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Final.data_2014-04-10_plants2.shp")  ;


#### Aggreate the shape files into one

Plants_2_all.2014<-rbind(Plants_2.1.2014,Plants_2.2.2014) ;

#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  

Plants_2_all.2014<-spTransform(Plants_2_all.2014, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_2_all.2014, pch=20, col="DARKGREEN", add=T) ;





#################   Conversion of the Plant population estimates  based on the 0 ,1 ,2 survey system to plants/m2             ######################
#
#
# Based on the diagram of the planting C:\Felipe\Willow_Project\Drawings and Pictures\Final Drawings\Cutting Spacing Rockview20120502.tif 
#
#
##################                            #################                                   #################

#### Two plants per row

Row.width.ft<-3.0 + 2.5 + 3.0
Row.length.PerTwoplants.ft<-2.0 

Plant.Density.2.ft2<-Row.width.ft*Row.length.PerTwoplants.ft /2    #ft2/plant

Plant.Density.1.ft2<-Row.width.ft*Row.length.PerTwoplants.ft /1   #ft2/plant


Plant.Density.2.m2<-Plant.Density.2.ft2 / 10.76391   # m2/plant

Plant.Density.1.m2<-Plant.Density.1.ft2 / 10.76391   # m2/plant

Plant.Density.2.ha<-10000 / Plant.Density.2.m2  # plants/ha 

Plant.Density.1.ha<-10000 / Plant.Density.1.m2 # plants/ha 

##############  Addint the information about plant density to the plaqnt population estimates shape files




