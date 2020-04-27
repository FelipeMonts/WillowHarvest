##############################################################################################################
# 
# 
# Program to manage, cleand and prepare willow harvest research data for analysis
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
# Install the packages that are needed #

# install.packages('fields', dep=T)

# install.packages('LatticeKrig', dep=T)

# install.packages('rgeos', dep=T)

# install.packages('RColorBrewer', dep=T)

# install.packages('rgdal', dep=T)

# install.packages('sp', dep=T)

# install.packages('raster', dep=T)

# install.packages('openxlsx', dep=T)

# install.packages(c("Rcpp", "devtools"), dependencies = TRUE)

# install.packages("zip", dependencies = TRUE)

###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################
library(rgdal) ; 

library(soilDB) ;

library(aqp) ;

library(sp) ;

library(raster) ;


library(openxlsx);

library(fields);

library(LatticeKrig)

library(rgeos)

library(sf)
###############################################################################################################
#                           load willow harvest data from 2015
###############################################################################################################
#  readClipboard()

#Harvest2015<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Yield Data\\RockviewWillowHarvest_chips20160222 (1).xlsx", sheet= "PivotTable", startRow = 1 ,colNames = T , cols= c(seq(1,9)), rows=c(seq(1,133)) );

Harvest2015.1<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\RockviewWillowHarvest2016.xlsx", sheet= "PivotTable", startRow = 1 ,colNames = T , cols= c(seq(1,9)), rows=c(seq(1,133)) );

Harvest2015.moisture<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\RockviewWillowHarvest2016.xlsx", sheet= "HarvestRecords", startRow = 11, colNames = T , cols= c(seq(1,20)), rows=c(seq(11,151)) ) ;

Harvest2015<-merge(Harvest2015.1, Harvest2015.moisture[!is.na(Harvest2015.moisture$`Actual.Row.#`),names(Harvest2015.moisture)[c(1,17)]], by.x= names(Harvest2015.1)[1], by.y=names(Harvest2015.moisture)[1] ,all.x=T)

# View(Harvest2015)
# View(Harvest2015.moisture)

# str(Harvest2015.moisture)

names(Harvest2015)

#### convert the row and the variety data to factors

Harvest2015$Factor.Row<-as.factor(Harvest2015$`Actual.Row.#`) ;

#levels(Harvest2015$Factor.Row)

Harvest2015$Cultivar<-as.factor(Harvest2015$Variety) ;

#levels(Harvest2015$Cultivar)


#### convert the fesh weight to kd dry mater per hectare

Harvest2015$DryM.kg<-Harvest2015$`Chips.Weight,.lb`* 0.453592 * (1-Harvest2015$`Moisture.%`) ; # 0.453592 kg/lb

# Harvest2015$DryM.kg.ha.2<-Harvest2015$DryM.kg /(Harvest2015$`Row.Length,.m` * ((2.5+6)* 0.3048 )) * 10000 ; # 0.3048 m/ft  10000 m2/ha



###############################################################################################################
#                           load willow harvest data from 2019
###############################################################################################################
#readClipboard()
Harvest2019<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\RockviewWillowHarvest2019 V2.xlsx", sheet= "Corrected Yield", startRow = 2 , colNames = T , cols= c(seq(1,11)), rows=c(seq(2,134)) );

#  View(Harvest2019)  ; str(Harvest2019)

names(Harvest2019)

#### convert the row and the variety data to factors

Harvest2019$Factor.Row<-as.factor(Harvest2019$Row) ;

#levels(Harvest2019$Factor.Row)

Harvest2019$Cultivar<-as.factor(Harvest2019$Variety) ;

#levels(Harvest2019$Cultivar)



#### convert the fesh weight to kd dry mater per hectare

Harvest2019$DryM.kg<-Harvest2019$`Fresh.Chips.weight.(lb)` * 0.453592 * (1-Harvest2019$`Moisture.(%)`) ; # 0.453592 kg/lb

# Harvest2019$DryM.kg.ha.2<-Harvest2015$DryM.kg /(Harvest2015$`Row.Length,.m` * ((2.5+6)* 0.3048 )) * 10000 ; # 0.3048 m/ft  10000 m2/ha


# View(Harvest2019)

###############################################################################################################
#                           load Willow field GIS Maps
###############################################################################################################

#################    Tractor GPS Coverage Maps ######################

########### Read infor mation about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\BrianGISFile Tractor\\Coverage.shp")  ; 


#### read the shape file 

TractorGPS.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\BrianGISFile Tractor\\Coverage.shp")  ;


#### Change the projection to NAD83/Pennsylvania North EPSG:32128 NAD83 / Pennsylvania North
# Extent
# -80.53, 40.60, -74.70, 42.53
# Proj4
# +proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

TractorGPS<-spTransform(TractorGPS.1,  CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )


 plot(TractorGPS)
 
 #################   Extract rows based on the tractor gps files and boundary files recorded with the GPS ###################### 
 
 Boundary.Polygon.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Boundary_Track_2014-04-11 09_00_54_Polygon.shp") ;

# summary(Boundary.Polygon.1)

 Boundary.Polygon<-spTransform(Boundary.Polygon.1, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )
   
 plot(Boundary.Polygon, add=T,col="RED") 
   

##### read the tractor lines that are inside the boundary 
 
 Tractor.Inside.Boundary.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\TractorCoverageinsideBoudaryTrack.shp") ;
 
# summary(Tractor.Inside.Boundary.1) 
 
 Tractor.Inside.Boundary<-spTransform(Tractor.Inside.Boundary.1,  CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )  ;
 
 plot(Tractor.Inside.Boundary, add=T,col="BLUE");
 

##### Select the first line and the middle of the line by using the centroids of the tractor polygons
  
FirstlineTractor.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\FirstLineTractorCoverage.shp") ;
 
# summary(FirstlineTractor.1) 
 
FirstlineTractor<-spTransform(FirstlineTractor.1, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )  ;
 
 
plot(FirstlineTractor,add=T, col="RED1");
 
 
FirstlineCentroid.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\FirstLineCentroid.shp") ;
 
# summary(FirstlineCentroid.1)  
 
FirstlineCentroid<-spTransform(FirstlineCentroid.1,  CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )  ;
 
 str(FirstlineCentroid)
 
 plot(FirstlineCentroid, add=T,col="YELLOW");
 
plot(FirstlineTractor[!is.na(over(FirstlineTractor,geometry(FirstlineCentroid))),], add=T, col="CYAN")
 
dim(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords)


(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,1]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,1])/(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,2]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,2])


##### find the slope of the line so new lines can be drawn with the width off the tractor swaths polygons
 
FirstLineSlope<-(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,1]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,1])/(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,2]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,2])

FirstlineCentroid.xmin<-min(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,1])
FirstlineCentroid.xmax<-max(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,1])

FirstlineCentroid.ymin<-min(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,2])
FirstlineCentroid.ymax<-max(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,2])



FirstlineCentroid.tips.1<-data.frame(c(FirstlineCentroid.xmax,FirstlineCentroid.xmin), c(FirstlineCentroid.ymin,FirstlineCentroid.ymax)) ;
 
FirstlineCentroid.tips<-SpatialPointsDataFrame(FirstlineCentroid.tips.1, data=FirstlineCentroid.tips.1, proj4string=CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
 



####### Extend the FirstlineCentroid by 100 m up and down ######


plot(FirstlineCentroid.tips, col=c("RED","BLUE"), add=T)  


#### extend the line on the y axis  100 m

coordinates(FirstlineCentroid.tips)

FirstlineCentroid.extended.tips.1<-data.frame(c(595887.4 + (FirstLineSlope*100), 595999.0  - (FirstLineSlope*100)),c(77033.80 + 100, 76646.34 - 100))

FirstlineCentroid.extended.tips<-SpatialPointsDataFrame(FirstlineCentroid.extended.tips.1, data=FirstlineCentroid.extended.tips.1, proj4string= CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")) ;

coordinates(FirstlineCentroid.extended.tips)

plot(FirstlineCentroid.extended.tips, col="GREEN", add=T)    
  
# create the extended line

ExtendedLine.1<-FirstlineCentroid.extended.tips@coords  ;
ExtendedLine.2<-Line(ExtendedLine.1);
ExtendedLine.3<-Lines(list(ExtendedLine.2), ID="1") ;
ExtendedLine.4<-SpatialLines(list(ExtendedLine.3),proj4string= CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;
ExtendedLine.5<-SpatialLinesDataFrame(ExtendedLine.4, data=data.frame(ID=c("1"),c(1)))

summary(ExtendedLine.4)
str(ExtendedLine.4)

plot(ExtendedLine.5, col="DARKGREEN", add=T)

writeOGR(ExtendedLine.5,"C:\\Users\\frm10\\Downloads\\Line1.shp",layer="Line1", driver="ESRI Shapefile")


####### move the line in paralell the distance onf one tractor 

#### Calculate the with of the tractor swaths 
# i=8
# j=3
# k=4
# 
# plot(TractorGPS@polygons[[i]]@Polygons[[1]]@coords)
# dim(TractorGPS@polygons[[i]]@Polygons[[1]]@coords)
# text(TractorGPS@polygons[[i]]@Polygons[[1]]@coords,labels=seq(1,dim(TractorGPS@polygons[[i]]@Polygons[[1]]@coords)[1]))
# 
# sqrt((TractorGPS@polygons[[i]]@Polygons[[1]]@coords[j,1]-TractorGPS@polygons[[i]]@Polygons[[1]]@coords[k,1])^2+(TractorGPS@polygons[[i]]@Polygons[[1]]@coords[j,2]-TractorGPS@polygons[[i]]@Polygons[[1]]@coords[k,2])^2)


# ######################################################
# 
#           average distance between tractor swaths 
# 
#                         d.m=2.5723
# 
# 
# #####################################################

N.ROWS=132  ;


#N.ROW=25  ;

d.m<-2.5723 ;

atan(1/FirstLineSlope)

#### Calculate the translation matrix based on the distance  https://en.wikipedia.org/wiki/Translation_(geometry) https://www.mathworks.com/discovery/affine-transformation.html

Transl.matx<-matrix(c(1,0,d.m*N.ROW*sin(-atan(1/FirstLineSlope)),0,1,(d.m*N.ROW*cos(atan(1/FirstLineSlope))),0,0,1), ncol=3,byrow=T) ;

ExtendedLine.4@lines[[1]]@Lines[[1]]@coords

New.line.1<-Transl.matx %*% t(cbind(ExtendedLine.4@lines[[1]]@Lines[[1]]@coords,c(1,1)))


### Create a new line 


New.line.2<-Line(t(New.line.1[1:2,]));
New.line.3<-Lines(list(New.line.2), ID="1") ;
New.line.4<-SpatialLines(list(New.line.3),proj4string=CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;
New.line.5<-SpatialLinesDataFrame(New.line.4, data=data.frame(ID=c("1"),c(1))) ;



summary(New.line.5)

plot(New.line.5, col="PINK", add=T)


writeOGR(New.line.5,"C:\\Users\\frm10\\Downloads\\Line1.shp",layer="Line1", driver="ESRI Shapefile")




##### Create all the lines

#initiallize the SpatialLines object

Tractor.Swath.lines.1<-Lines(ExtendedLine.4@lines[[1]]@Lines[[1]], ID=c(1)) ;


for (N.ROW in seq(1,N.ROWS ) ){
 
  #N.ROW=20  ;
  
  Transl.matx<-matrix(c(1,0,d.m*N.ROW*sin(-atan(1/FirstLineSlope)),0,1,(d.m*N.ROW*cos(atan(1/FirstLineSlope))),0,0,1), ncol=3,byrow=T) ;
  
  New.line.1<-Transl.matx %*% t(cbind(ExtendedLine.4@lines[[1]]@Lines[[1]]@coords,c(1,1)))
  
  New.line.2<-Line(t(New.line.1[1:2,]));
  
  Tractor.Swath.lines.1<-append(Tractor.Swath.lines.1, Lines(list(New.line.2), ID=N.ROW+1)) ;
  

  
}




Tractor.Swath.lines.2<-SpatialLines(Tractor.Swath.lines.1, proj4string= CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")) ;
Tractor.Swath.lines.3<-SpatialLinesDataFrame(Tractor.Swath.lines.2, data=data.frame(ID=sapply(slot(Tractor.Swath.lines.2,"lines"),function (x) slot(x,"ID")),row.names=sapply(slot(Tractor.Swath.lines.2,"lines"),function (x) as.numeric(slot(x,"ID"))))) ;

plot(Tractor.Swath.lines.3, col="PURPLE", add=T)


writeOGR(Tractor.Swath.lines.3,"C:\\Users\\frm10\\Downloads\\Line5.shp",layer="Line5", driver="ESRI Shapefile") ;


############### Clip the extended tractor swath lines and obtain the length of each one ###

Tractor.Swath.lines.4<-crop(Tractor.Swath.lines.3,Boundary.Polygon )  ;

plot(Tractor.Swath.lines.4, col="YELLOW", add=T) ;


SpatialLinesLengths(Tractor.Swath.lines.4)


Tractor.Swath.lines.4@data$Row.Length.m<-SpatialLinesLengths(Tractor.Swath.lines.4) ;





#################    Plots  and varieties  ######################

########### Read information about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\RockviewPlotsV3AR7.shp")  ; 


#### read the shape file 

PlotsData.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\RockviewPlotsV3AR7.shp")  ;
 
#### Change the projection to NAD83/Pennsylvania North EPSG:32128 NAD83 / Pennsylvania North
# Extent
# -80.53, 40.60, -74.70, 42.53
# Proj4
# +proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

 
PlotsData<-spTransform(PlotsData.1, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )
 

plot(PlotsData, lwd=2, border="CYAN", add=T)


#################          Plant population estimates  based on the 0 ,1 ,2 survey system              ######################

#########################            Plants_0 2013                          ###########################

########### Read information about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\Willow Census R\\PlantData2013.shp")  ;
ogrInfo("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\Willow Census R\\PlantDatapart22013.shp")  ;


#### read the shape files

PlantData2013<-readOGR("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\Willow Census R\\PlantData2013.shp")  ;
PlantDatapart22013<-readOGR("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\Willow Census R\\PlantDatapart22013.shp")  ;


#### Aggreate the sape files into one

PlantData2013.all<-union(PlantData2013,PlantDatapart22013) ;

#### Change the projection to NAD83/Pennsylvania North EPSG:32128 NAD83 / Pennsylvania North
# Extent
# -80.53, 40.60, -74.70, 42.53
# Proj4
# +proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

PlantData2013.all<-spTransform(PlantData2013.all, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(PlantData2013.all, pch=20, col="RED", add=T) ;




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

#### Change the projection to NAD83/Pennsylvania North EPSG:32128 NAD83 / Pennsylvania North
# Extent
# -80.53, 40.60, -74.70, 42.53
# Proj4
# +proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs


Plants_0_all.2014<-spTransform(Plants_0_all.2014,  CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_0_all.2014, pch=20, col="PINK", add=T) ;

# View(Plants_0_all.2014@data  )


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

#### Change the projection to NAD83/Pennsylvania North EPSG:32128 NAD83 / Pennsylvania North
# Extent
# -80.53, 40.60, -74.70, 42.53
# Proj4
# +proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs


Plants_1_all.2014<-spTransform(Plants_1_all.2014,  CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


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

#### Change the projection to NAD83/Pennsylvania North EPSG:32128 NAD83 / Pennsylvania North
# Extent
# -80.53, 40.60, -74.70, 42.53
# Proj4
# +proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

Plants_2_all.2014<-spTransform(Plants_2_all.2014, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")) ;


plot(Plants_2_all.2014, pch=20, col="DARKGREEN", add=T) ;




####### Using the fields package to do krigging on the plant data

PlantData2013.all@coords

# View(PlantData2013.all@data)  str(PlantData2013.all@data)


#quilt.plot(Plants.2013@coords,Plants.2013@data$PlantDensity ) ;

#  Reamove data that was missing and marked with the  9999 value 


Plants.2013<-PlantData2013.all[!PlantData2013.all@data$Plants==9999,]

str(Plants.2013)

hist(Plants.2013@data$Plants)



#### Plants.2013.sp<-spatialProcess(Plants.2013@coords,Plants.2013@data$PlantDensity); ### spatialProcess doeas not converge in pc time
#### Another methods needs to be tested

### The Thin plate smoothing Tps works, therefore that is what will be used



Plants.2013.Tps.V1<-Tps(Plants.2013@coords,Plants.2013@data$Plants);

###### Coordinates grid to prepare image and raster


Range.in.x.2013<-max(Plants.2013@coords[,1]) - min(Plants.2013@coords[,1]) ;
Range.in.y.2013<-max(Plants.2013@coords[,2]) - min(Plants.2013@coords[,2]) ;



x.coords.2013<-seq(min(Plants.2013@coords[,1]),max(Plants.2013@coords[,1]),1) ;
y.coords.2013<-seq(min(Plants.2013@coords[,2]),max(Plants.2013@coords[,2]),1) ;

Rock.View.grid.2013<-list(x.coords.2013,y.coords.2013) ;
names(Rock.View.grid.2013)<-c('x', 'y') ;






str(Plants.2013@coords)



###### Convert the Thin plate smoothing interpolation into a raster file that then can be sampled with the polygons of the tractor file

### predict interpotated values

Plants.2013.Tps.image.V1<-predictSurface(Plants.2013.Tps.V1,grid.list=Rock.View.grid.2013, extrap = T ) # Survey counts 0,1,2


### Convert to a raster and a spatial object

Plants.2013.Tps.sp.V1<-as(raster(Plants.2013.Tps.image.V1, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), 'SpatialGridDataFrame');



  
#### plot  spatial raster of interpolated values and the tractor files
  
  
  
plot(Plants.2013.Tps.sp.V1)


plot(TractorGPS,add=T)

writeRaster(raster(Plants.2013.Tps.image.V1, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), filename="C:\\Users\\frm10\\Downloads\\2013SurveyDensity.tiff", format='GTiff')


########## Repeat the method  above for the plant census in 2014 #########################


# ##  Addin the information about plant density to the plaqnt population estimates shape files
# 
# 
# Plants_0_all.2014@data$PlantDensity<-Plant.Density.0.ha  ;
# 
# Plants_1_all.2014@data$PlantDensity<-Plant.Density.1.ha  ;
# 
# Plants_2_all.2014@data$PlantDensity<-Plant.Density.2.ha   ;

#### Aggreate the 2014 shape files into one

Plants.2014<-rbind(Plants_0_all.2014,Plants_1_all.2014,Plants_2_all.2014) ;
#  View(as.numeric(Plants.2014@data$comment)) ; str(Plants.2014@data) 

Plants.2014@data$S.Density<-as.numeric(Plants.2014@data$comment)-1 ;

#  View(Plants.2014@data$S.Density) ; str(Plants.2014@data) 


####### Using the fields package to do krigging on the plant data

### The Thin plate smoothing Tps works, therefore that is what will be used

###### Convert the Thin plate smoothing interpolation into a raster file that then can be sampled with the polygons of the tractor file


###### Coordinates grid to prepare image and raster


Plants.2014.Tps.V1<-Tps(Plants.2014@coords[,c(1,2)],Plants.2014@data$S.Density);


Range.in.x.2014<-max(Plants.2014@coords[,1]) - min(Plants.2014@coords[,1]) ;
Range.in.y.2014<-max(Plants.2014@coords[,2]) - min(Plants.2014@coords[,2]) ;



x.coords.2014<-seq(min(Plants.2014@coords[,1]),max(Plants.2014@coords[,1]),1) ;
y.coords.2014<-seq(min(Plants.2014@coords[,2]),max(Plants.2014@coords[,2]),1) ;

Rock.View.grid.2014<-list(x.coords.2014,y.coords.2014) ;
names(Rock.View.grid.2014)<-c('x', 'y') ;

str(Rock.View.grid.2014)

### predict interpotated values

Plants.2014.Tps.image.V1<-predictSurface(Plants.2014.Tps.V1, grid.list=Rock.View.grid.2014, extrap = T ) # Survey counts 0,1,2



### Convert to a raster and a spatial object

Plants.2014.Tps.sp.V1<-as(raster(Plants.2014.Tps.image.V1, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), 'SpatialGridDataFrame');



#### plot  spatial rasted of interpolated values and the tractor files



plot(Plants.2014.Tps.sp.V1)

plot(TractorGPS,add=T)



writeRaster(raster(Plants.2014.Tps.image.V1, CRS("+proj=lcc +lat_1=41.95 +lat_2=40.88333333333333 +lat_0=40.16666666666666 +lon_0=-77.75 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), filename="C:\\Users\\frm10\\Downloads\\2014SurveyDensity.tiff", format='GTiff')


# ################################################################################################################################
# 
# 
# After obtaining the raster interpolated data of density it will be used to intersect the planted row, based on the tractor swaths GIS data.  It will be used to estimate the plant number in each row, as a function of length in the row 
# 
# 
#################################################################################################################################


#Cropping the rows by the perimeter boundary of the site


plot(Boundary.Polygon,col="RED") ;

plot(Tractor.Swath.lines.4, col="YELLOW", add=T) ;

str(Tractor.Swath.lines.4@data)

# sampling the lines at each plant sistance of 2 ft  ( 2 * 0.3048 m/ft )  with the function st_line_sample {sf}. The parametre density is points per distance unit
#
# density = 1 point /( 2 * 0.3048) m  = 1.64042 points/m




Points.1<-spsample(Tractor.Swath.lines.4@lines[[60]]@Lines[[1]],n=Tractor.Swath.lines.4@data[60,c("Row.Length.m")]*1.64,type="regular")

str(Points.1)

# distance between points 
View(pointDistance(Points.1, lonlat=F)[,1])

diff(pointDistance(Points.1, lonlat=F)[,1],lag=1, differences=1)

Df.2013<-extract(raster(Plants.2013.Tps.sp.V1),Points.1, df=T )
Df.2014<-extract(raster(Plants.2014.Tps.sp.V1),Points.1, df=T )
Plants.on.theRow.1<-merge(Df.2013, Df.2014, by='ID')
str(Plants.on.theRow.1)
names(Plants.on.theRow.1)[2:3]<-c('P.2013' , 'P.2014')

#  Discretize back

cut(Plants.on.theRow.1$P.2013,c(-Inf,0.5,1.499,Inf),include.lowest=T,labels=c(0,1,2))

as.numeric(cut(Planted.Rows[[N.ROW]]@data$X2013_Densi,c(-Inf,0.5,1.499,Inf),include.lowest=T,labels=c(0,1,2)))-1

Plants.on.theRow.1$S.2013<-as.numeric(cut(Plants.on.theRow.1$P.2013,c(-Inf,0.5,1.499,Inf),include.lowest=T,labels=c(0,1,2)))-1

Plants.on.theRow.1$S.2014<-as.numeric(cut(Plants.on.theRow.1$P.2014,c(-Inf,0.5,1.499,Inf),include.lowest=T,labels=c(0,1,2)))-1


cumsum(Plants.on.theRow.1$S.2014)




#### Separate the data from each planted row  and collected into a list Planted.Rows


# Initiallize the list of with a spatialPoligonsDataFrame object for each planted row
Planted.Rows<-list()

# N.ROW=1

for (N.ROW in seq(1,N.ROWS ) ){
  Planted.Rows[[N.ROW]]<-raster::intersect(Tractor.Swaths,Tractor.Swath.lines.4[N.ROW,])
}

plot(Planted.Rows[[16]][seq(11,20),], col="GREEN", add=T)
Tractor.Swath.lines.4[1,]

str(Planted.Rows[[80]]@data)


cumsum(Planted.Rows[[16]]@data[seq(1:20), c("P.length")])

#Tractor.Swaths@data$P.length.along<-cumsum(Tractor.Swaths@data$P.length) ;
Tractor.Swaths@data




#####  estimate plant density as a functions a row distance along the line

for (N.ROW in seq(1,N.ROWS ) ){
  Planted.Rows[[N.ROW]]@data$P.length.along<-cumsum(Planted.Rows[[N.ROW]]@data$P.length)
  
  
}


# RN=94

plot(Planted.Rows[[RN]]@data$P.length.along, Planted.Rows[[RN]]@data$X2013_Densi, type="o", ylim=c(0,2))
points(Planted.Rows[[RN]]@data$P.length.along, Planted.Rows[[RN]]@data$X2014_Densi, type="o", col="RED")


str(Planted.Rows[c(1,2,3)], max.level=2)


# ##############################################################################################################################
# 
# 
# 
#                               Discretize back to (0,1,2) the values of population dnesity obtained using cut ()
# 
#  ##############################################################################################################################

#  View(Planted.Rows[[25]]@data);   str(Planted.Rows[[N.ROW]]@data)

#  Discretize the interpolated values in each row

for (N.ROW in seq(1,N.ROWS ) ){
  
  Planted.Rows[[N.ROW]]@data$Survey2013<-as.numeric(cut(Planted.Rows[[N.ROW]]@data$X2013_Densi,c(-Inf,0.5,1.499,Inf),include.lowest=T,labels=c(0,1,2)))-1
  
  
  Planted.Rows[[N.ROW]]@data$Survey2014<-as.numeric(cut(Planted.Rows[[N.ROW]]@data$X2014_Densi,c(-Inf,0.5,1.499,Inf),include.lowest=T,labels=c(0,1,2)))-1
}


# #################   Conversion of the Plant population estimates  based on the 0 ,1 ,2 survey system to plants/m2             ######################
# #
# #
# # Based on the diagram of the planting C:\Felipe\Willow_Project\Drawings and Pictures\Final Drawings\Cutting Spacing Rockview20120502.tif 
# #
# #
# ##################                            #################                                   #################

# #### Two plants per row

Row.width.ft<-3.0 + 2.5 + 3.0
Row.length.PerTwoplants.ft<-2.0 
Plants.per.Row.lenght<-2/Row.length.PerTwoplants.ft ;


Plant.Density.2.ft2<-Row.width.ft*Row.length.PerTwoplants.ft /2    #ft2/plant
 
Plant.Density.1.ft2<-Row.width.ft*Row.length.PerTwoplants.ft /1   #ft2/plant
 
 
Plant.Density.2.m2<-Plant.Density.2.ft2 / 10.76391   # m2/plant
 
Plant.Density.1.m2<-Plant.Density.1.ft2 / 10.76391   # m2/plant
 
Plant.Density.2.ha<-10000 / Plant.Density.2.m2  # plants/ha 

Plant.Density.1.ha<-10000 / Plant.Density.1.m2 # plants/ha 


# ##### Density of plants per length of row in m


Plants.per.Row.lenght.2.ft<-2/Row.length.PerTwoplants.ft;

Plants.per.Row.lenght.1.ft<-1/Row.length.PerTwoplants.ft;

Plants.per.Row.lenght.2.m<-Plants.per.Row.lenght.2.ft*3.28084;

Plants.per.Row.lenght.1.m<-Plants.per.Row.lenght.1.ft*3.28084 ;


####

# Adding the plant density data to the  data list

# N.ROW=94

#  View(Planted.Rows[[N.ROW]]@data);   str(Planted.Rows[[N.ROW]]@data)


# RWos with NA will not work and need to be corrected

for (N.ROW in seq(1,N.ROWS ) ){
  
 print(which(is.na(Planted.Rows[[N.ROW]]@data$X2014_Densi), arr.ind=T))
  
  
}
  
# There is only one point with NA in the Planted.Rows[[N.ROW]]@data$X2014_Densi: the first point of row 94. It will be changed to the value closet to it.

#  Planted.Rows[[94]]@data$X2014_Densi

Planted.Rows[[94]]@data$X2014_Densi[1]<-Planted.Rows[[94]]@data$X2014_Densi[2]

# and the Survey data corresponding to it as well 

Planted.Rows[[94]]@data$Survey2014[1]<-Planted.Rows[[94]]@data$Survey2014[2]


for (N.ROW in seq(1,N.ROWS ) ){

  #   2013  #
  
  Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2013==0,"Plants2013"]<-Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2013==0,"P.length"]*0
  
  Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2013==1,"Plants2013"]<-Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2013==1,"P.length"]*Plants.per.Row.lenght.1.m
  
  Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2013==2,"Plants2013"]<-Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2013==2,"P.length"]*Plants.per.Row.lenght.2.m
  
  
  #   2014  #
  
  Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2014==0,"Plants2014"]<-Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2014==0,"P.length"]*0
  
  Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2014==1,"Plants2014"]<-Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2014==1,"P.length"]*Plants.per.Row.lenght.1.m
  
  Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2014==2,"Plants2014"]<-Planted.Rows[[N.ROW]]@data[Planted.Rows[[N.ROW]]@data$Survey2014==2,"P.length"]*Plants.per.Row.lenght.2.m
  
}

# N.ROW=50


#  View(Planted.Rows[[N.ROW]]@data);   str(Planted.Rows[[N.ROW]]@data)





#################          Plant population estimates based on counts of plants 2016             ######################

#########################            Plants by row 2016                     ###########################

###### Read the data from the excell spreadsheet

#  readClipboard()

Plants.2016<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Plant Data\\RockViewCensus20160308.xlsx", sheet= "HarvestRecords",startRow = 2, colNames=T, rows=seq(1,133), cols= c(1,2)) ;

#  View(Plants.2016)  str(Plants.2016)

# ################################################################################################################################
# 
# Counting tests performed during the census gave the following counting errors:
# Test 1: Average = 1210, Variance = 4825, Standard deviation = 69, CV% = 0.057 , n=6
# Test 2: Average = 899, Variance = 471, Standard deviation = 22, CV% = 0.024 , n=3
# Test 3: Average = 646, Variance = 1684, Standard deviation = 41, CV% = 0.064 , n=8
# 
# Weighted average of the variance = (((1210-1)*4825)+((899-1)*471)+((646-1)*1684)) / ((1210-1)+(899-1)+(646-1)) = 2668.082
# Standard deviation = 51.65348 ~ 52
#
#################################################################################################################################


# ###############################################################################################################
# 
# 
#                           Gather all data together for analysis
# 
# 
# 
# 
###############################################################################################################

#  View(Planted.Rows[[N.ROW]]@data);   str(Planted.Rows[[N.ROW]]@data)

# str(Harvest2015) ; str(Harvest2019)


Paper.data.1<-merge(Harvest2015[, c('Actual.Row.#', 'Variety', 'Chips.Weight,.lb')], Harvest2019[,c('Row', 'Variety', 'Fresh.Chips.weight.lb')], by.x= 'Actual.Row.#', by.y='Row') ;


Paper.data<-merge(Paper.data.1,Plants.2016, by.x='Actual.Row.#',by.y="ROW" ,all.x=T) ;

names(Paper.data)[6]<-c('Plants2016')

# View(Paper.data) str(Paper.data)

#  Calculate summary plant population data for each row

#  View(Planted.Rows[[N.ROW]]@data);   str(Planted.Rows[[N.ROW]]@data)

#Paper.data<-data.frame(row = numeric(0), area = double(0) , length = double(0), Plants2013= double(), Plants2014 = double(), Plants2016 = double() , ChipsWeight.2015.lb = double(), ChipsWeight.2019.lb =double() )

# N.ROW=4


for (N.ROW in seq(1,N.ROWS ) ){
  
  Paper.data$Area.m2[N.ROW]<-sum(Planted.Rows[[N.ROW]]@data$P.area.m)
  
  Paper.data$Length.m[N.ROW]<-sum(Planted.Rows[[N.ROW]]@data$P.length)
  
  Paper.data$Plants2013[N.ROW]<-sum(Planted.Rows[[N.ROW]]@data$Plants2013)
  
  Paper.data$Plants2014[N.ROW]<-sum(Planted.Rows[[N.ROW]]@data$Plants2014)
  
  
}

Paper.data$Plant.Density.pl.ha.2013<-Paper.data$Plants2013/(Paper.data$Length.m * Row.width.ft/3.28084)*10000
Paper.data$Plant.Density.pl.ha.2014<-Paper.data$Plants2014/(Paper.data$Length.m * Row.width.ft/3.28084)*10000
Paper.data$Plant.Density.pl.ha.2016<-Paper.data$Plants2016/(Paper.data$Length.m * Row.width.ft/3.28084)*10000

# View(Paper.data) ; str(Paper.data)

# save.image("DataCleaning.RData")

#  load("DataCleaning.RData")

matplot(Paper.data$`Actual.Row.#`, Paper.data$Plant.Density.pl.ha.2013 , type='o' , col="RED", ylim=c(0,12000))
matpoints(Paper.data$`Actual.Row.#`, Paper.data$Plant.Density.pl.ha.2014, type='o' , col="BLUE", ylim=c(0,12000))
matpoints(Paper.data$`Actual.Row.#`, Paper.data$Plant.Density.pl.ha.2016, type='o' , col="GREEN", ylim=c(0,12000))

