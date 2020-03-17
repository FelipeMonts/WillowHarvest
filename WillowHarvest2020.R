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

#install.packages('fields', dep=T)

#install.packages('LatticeKrig', dep=T)

#install.packages('rgeos', dep=T)


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


 plot(TractorGPS)
 
 #################   Extract rows based on the tractor gps files and boundary files recorded with the GPS ###################### 
 
 Boundary.Polygon.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\Boundary_Track_2014-04-11 09_00_54_Polygon.shp") ;

 Boundary.Polygon<-spTransform(Boundary.Polygon.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )
   
 plot(Boundary.Polygon, add=T,col="RED") 
   

##### read the tractor lines that are inside the boundary 
 
 Tractor.Inside.Boundary.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\TractorCoverageinsideBoudaryTrack.shp") ;
 
 Tractor.Inside.Boundary<-spTransform(Tractor.Inside.Boundary.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )  ;
 
 plot(Tractor.Inside.Boundary, add=T,col="BLUE");
 

##### Select the first line and the middle of the line by using the centroids of the tractor polygons
  
FirstlineTractor.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\FirstLineTractorCoverage.shp") ;
 
FirstlineTractor<-spTransform(FirstlineTractor.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )  ;
 
 
plot(FirstlineTractor,add=T);
 
 
FirstlineCentroid.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\FirstLineCentroid.shp") ;
 
FirstlineCentroid<-spTransform(FirstlineCentroid.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )  ;
 
 str(FirstlineCentroid)
 
 plot(FirstlineCentroid, add=T,col="RED");
 
plot(FirstlineTractor[!is.na(over(FirstlineTractor,geometry(FirstlineCentroid))),])
 
dim(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords)


(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,1]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,1])/(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,2]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,2])


##### find the slope of the line so new lines can be drawn with the width off the tractor swaths polygons
 
FirstLineSlope<-(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,1]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,1])/(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[21,2]-FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[1,2])

FirstlineCentroid.xmin<-min(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,1])
FirstlineCentroid.xmax<-max(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,1])

FirstlineCentroid.ymin<-min(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,2])
FirstlineCentroid.ymax<-max(FirstlineCentroid@lines[[1]]@Lines[[1]]@coords[,2])



FirstlineCentroid.tips.1<-data.frame(c(FirstlineCentroid.xmax,FirstlineCentroid.xmin), c(FirstlineCentroid.ymin,FirstlineCentroid.ymax)) ;
 
FirstlineCentroid.tips<-SpatialPointsDataFrame(FirstlineCentroid.tips.1, data=FirstlineCentroid.tips.1, proj4string= CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
 



####### Extend the FirstlineCentroid by 100 m up and down ######


plot(FirstlineCentroid.tips, col=c("RED","BLUE"), add=T)  


#### extend the line on the y axis  100 m

FirstlineCentroid.extended.tips.1<-data.frame(c(1512491 + (FirstLineSlope*100), 1512674 - (FirstLineSlope*100)),c(2128633 + 100, 2128271- 100))

FirstlineCentroid.extended.tips<-SpatialPointsDataFrame(FirstlineCentroid.extended.tips.1, data=FirstlineCentroid.extended.tips.1, proj4string= CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")) ;


plot(FirstlineCentroid.extended.tips, col="MAGENTA", add=T)    
  
# create the extended line

ExtendedLine.1<-FirstlineCentroid.extended.tips@coords  ;
ExtendedLine.2<-Line(ExtendedLine.1);
ExtendedLine.3<-Lines(list(ExtendedLine.2), ID="1") ;
ExtendedLine.4<-SpatialLines(list(ExtendedLine.3),proj4string= CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;
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


#N.ROW=20  ;

d.m<-2.5723 ;

atan(1/FirstLineSlope)

#### Calculate the translation matrix based on the distance  https://en.wikipedia.org/wiki/Translation_(geometry) https://www.mathworks.com/discovery/affine-transformation.html

Transl.matx<-matrix(c(1,0,d.m*N.ROW*sin(-atan(1/FirstLineSlope)),0,1,(d.m*N.ROW*cos(atan(1/FirstLineSlope))),0,0,1), ncol=3,byrow=T) ;

ExtendedLine.4@lines[[1]]@Lines[[1]]@coords

New.line.1<-Transl.matx %*% t(cbind(ExtendedLine.4@lines[[1]]@Lines[[1]]@coords,c(1,1)))


### Create a new line 


New.line.2<-Line(t(New.line.1[1:2,]));
New.line.3<-Lines(list(New.line.2), ID="1") ;
New.line.4<-SpatialLines(list(New.line.3),proj4string= CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;
New.line.5<-SpatialLinesDataFrame(New.line.4, data=data.frame(ID=c("1"),c(1))) ;



summary(New.line.5)

plot(New.line.5, col="RED", add=T)


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




Tractor.Swath.lines.2<-SpatialLines(Tractor.Swath.lines.1,proj4string= CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;
Tractor.Swath.lines.3<-SpatialLinesDataFrame(Tractor.Swath.lines.2, data=data.frame(ID=sapply(slot(Tractor.Swath.lines.2,"lines"),function (x) slot(x,"ID")),row.names=sapply(slot(Tractor.Swath.lines.2,"lines"),function (x) as.numeric(slot(x,"ID"))))) ;

plot(Tractor.Swath.lines.3, col="CYAN", add=T)


writeOGR(Tractor.Swath.lines.3,"C:\\Users\\frm10\\Downloads\\Line5.shp",layer="Line5", driver="ESRI Shapefile") ;


############### Clip the extended tractor swath lines and obtain the length of each one ###

Tractor.Swath.lines.4<-crop(Tractor.Swath.lines.3,Boundary.Polygon )  ;

plot(Tractor.Swath.lines.4, col="YELLOW", add=T) ;


SpatialLinesLengths(Tractor.Swath.lines.4)


Tractor.Swath.lines.4@data$Row.Length.m<-SpatialLinesLengths(Tractor.Swath.lines.4) ;





#################    Plots  and varieties  ######################

########### Read infor mation about the shape files ###########

#readClipboard()
ogrInfo("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\RockviewPlotsV3AR7.shp")  ; 


#### read the shape file 

PlotsData.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\RockviewPlotsV3AR7.shp")  ;
 
#### Change the projection to EPSG:5070 - NAD83 / Conus Albers - Projected  
 
PlotsData<-spTransform(PlotsData.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )
 

plot(PlotsData, lwd=2, border="CYAN", add=T)


#################          Plant population estimates  based on the 0 ,1 ,2 survey system              ######################

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

Plants_1_2013<-spTransform(Plants_1_all, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ) ;


plot(Plants_1_2013, pch=20, col="BLUE", add=T) ;



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
Row.length.Zeroplants.ft<-7.0


Plant.Density.2.ft2<-Row.width.ft*Row.length.PerTwoplants.ft /2    #ft2/plant

Plant.Density.1.ft2<-Row.width.ft*Row.length.PerTwoplants.ft /1   #ft2/plant

############################################### Think about the lower bound for 0 plants ###################################

Plant.Density.0.ft2<-Row.width.ft*Row.length.Zeroplants.ft/1   #ft2/plant Ma  

############################################### Think about the lower bound for 0 plants ###################################

Plant.Density.2.m2<-Plant.Density.2.ft2 / 10.76391   # m2/plant

Plant.Density.1.m2<-Plant.Density.1.ft2 / 10.76391   # m2/plant


############################################### Think about the lower bound for 0 plants ###################################

 Plant.Density.0.m2<-Plant.Density.0.ft2 / 10.76391   # m2/plant

############################################### Think about the lower bound for 0 plants ###################################

Plant.Density.2.ha<-10000 / Plant.Density.2.m2  # plants/ha 

Plant.Density.1.ha<-10000 / Plant.Density.1.m2 # plants/ha 


############################################### Think about the lower bound for 0 plants ###################################

  Plant.Density.0.ha<-10000 / Plant.Density.0.m2 # plants/ha 

############################################### Think about the lower bound for 0 plants ###################################

##############  Addin the information about plant density to the plaqnt population estimates shape files

str(Plants_0_2013@data)
View(Plants_0_2013@data)

Plants_0_2013@data$PlantDensity<-Plant.Density.0.ha  ;

Plants_1_2013@data$PlantDensity<-Plant.Density.1.ha   ;

Plants_2_2013@data$PlantDensity<-Plant.Density.2.ha   ;


#### Aggreate the 2013 shape files into one

Plants.2013<-rbind(Plants_0_2013,Plants_1_2013,Plants_2_2013) ;
View(Plants.2013@data)




####### Using the fields package to do krigging on the plant data

Plants.2013@coords

quilt.plot(Plants.2013@coords,Plants.2013@data$PlantDensity ) ;

str(Plants.2013@data$cmt)

hist(as.numeric(Plants.2013@data$cmt)-1)

Plants.2013@data$S.Density<-as.numeric(Plants.2013@data$cmt)-1

hist(Plants.2013@data$S.Density)

quilt.plot(Plants.2013@coords,Plants.2013@data$S.Density) ;

#### Plants.2013.sp<-spatialProcess(Plants.2013@coords,Plants.2013@data$PlantDensity); ### spatialProcess doeas not converge in pc time
#### Another methods needs to be tested

### The Thin plate smoothing Tps works, therefore that is what will be used



Plants.2013.Tps.V1<-Tps(Plants.2013@coords,Plants.2013@data$PlantDensity);

Plants.2013.Tps.V2<-Tps(Plants.2013@coords,Plants.2013@data$S.Density);




str(Plants.2013@coords)
max(Plants.2013@data$PlantDensity)

###### Coordinates grid to prepare image and raster


Range.in.x.2013<-max(Plants.2013@coords[,1]) - min(Plants.2013@coords[,1]) ;
Range.in.y.2013<-max(Plants.2013@coords[,2]) - min(Plants.2013@coords[,2]) ;



x.coords.2013<-seq(min(Plants.2013@coords[,1]),max(Plants.2013@coords[,1]),1) ;
y.coords.2013<-seq(min(Plants.2013@coords[,2]),max(Plants.2013@coords[,2]),1) ;

Rock.View.grid.2013<-list(x.coords.2013,y.coords.2013) ;
names(Rock.View.grid.2013)<-c('x', 'y') ;


###### Convert the Thin plate smoothing interpolation into a raster file that then can be sampled with the polygons of the tractor file

### predict interpotated values

Plants.2013.Tps.image.V1<-predictSurface(Plants.2013.Tps.V1,grid.list=Rock.View.grid.2013, extrap = T ) # Plant Density Data

Plants.2013.Tps.image.V2<-predictSurface(Plants.2013.Tps.V2,grid.list=Rock.View.grid.2013, extrap = T )  # Survey counts 0,1,2

### Convert to a raster and a spatial object

Plants.2013.Tps.sp.V1<-as(raster(Plants.2013.Tps.image.V1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), 'SpatialGridDataFrame');


Plants.2013.Tps.sp.V2<-as(raster(Plants.2013.Tps.image.V2, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), 'SpatialGridDataFrame');
  
  
#### plot  spatial rasted of interpolated values and the tractor files
  
  
  
plot(Plants.2013.Tps.sp.V1)
plot(Plants.2013.Tps.sp.V2)

plot(TractorGPS,add=T)

writeRaster(raster(Plants.2013.Tps.image.V2, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), filename="C:\\Users\\frm10\\Downloads\\2013SurveyDensity.tiff", format='GTiff')


########## Repeat the method  above for the plant sensus in 2014 #########################


##  Addin the information about plant density to the plaqnt population estimates shape files


Plants_0_all.2014@data$PlantDensity<-Plant.Density.0.ha  ;

Plants_1_all.2014@data$PlantDensity<-Plant.Density.1.ha  ;

Plants_2_all.2014@data$PlantDensity<-Plant.Density.2.ha   ;

#### Aggreate the 2014 shape files into one

Plants.2014<-rbind(Plants_0_all.2014,Plants_1_all.2014,Plants_2_all.2014) ;
View(as.numeric(Plants.2014@data$comment))

Plants.2014@data$S.Density<-as.numeric(Plants.2014@data$comment)-1


####### Using the fields package to do krigging on the plant data

### The Thin plate smoothing Tps works, therefore that is what will be used

Plants.2014.Tps.V1<-Tps(Plants.2014@coords[,c(1,2)],Plants.2014@data$PlantDensity);

Plants.2014.Tps.V2<-Tps(Plants.2014@coords[,c(1,2)],Plants.2014@data$S.Density);


###### Convert the Thin plate smoothing interpolation into a raster file that then can be sampled with the polygons of the tractor file


###### Coordinates grid to prepare image and raster


Range.in.x.2014<-max(Plants.2014@coords[,1]) - min(Plants.2014@coords[,1]) ;
Range.in.y.2014<-max(Plants.2014@coords[,2]) - min(Plants.2014@coords[,2]) ;



x.coords.2014<-seq(min(Plants.2014@coords[,1]),max(Plants.2014@coords[,1]),1) ;
y.coords.2014<-seq(min(Plants.2014@coords[,2]),max(Plants.2014@coords[,2]),1) ;

Rock.View.grid.2014<-list(x.coords.2014,y.coords.2014) ;
names(Rock.View.grid.2014)<-c('x', 'y') ;

str(Rock.View.grid.2014)

### predict interpotated values

Plants.2014.Tps.image.V1<-predictSurface(Plants.2014.Tps.V1, grid.list=Rock.View.grid.2014, extrap = T ) # Plant Density Data

Plants.2014.Tps.image.V2<-predictSurface(Plants.2014.Tps.V2, grid.list=Rock.View.grid.2014, extrap = T )  # Survey counts 0,1,2


### Convert to a raster and a spatial object

Plants.2014.Tps.sp.V1<-as(raster(Plants.2014.Tps.image.V1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), 'SpatialGridDataFrame');


Plants.2014.Tps.sp.V2<-as(raster(Plants.2014.Tps.image.V2, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), 'SpatialGridDataFrame');


#### plot  spatial rasted of interpolated values and the tractor files



plot(Plants.2014.Tps.sp.V1)
plot(Plants.2014.Tps.sp.V2)


writeRaster(raster(Plants.2014.Tps.image.V2, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")), filename="C:\\Users\\frm10\\Downloads\\2014SurveyDensity.tiff", format='GTiff')


# ################################################################################################################################
# 
# 
# After obtaining the raster interpolated data of density it will be used to estimate the mode of each tractor swath density and from that to estimate the density in each planted row, based on the tractor swaths GIS data. After obtaining the zonal statistics survey density mode for each tractor swath polygon it will be gouped by planting row and together with the area of each tractor swath polygon (proxy for length) it will be used to estimate the plant number in each row, as a function of length in the row 
# 
# 
#################################################################################################################################


#### Reading the Tractor swaths again with the updated infomration with the mode of the plant density estimates fro 2013 and 2014

##### read the tractor lines that are inside the boundary 

Tractor.Swaths.1<-readOGR("C:\\Felipe\\Willow_Project\\FelipeQGIS\\RockViewSite2013\\ReplantingWillow2014\\TractorCoverageinsideBoudaryTrack.shp") ;

Tractor.Swaths<-spTransform(Tractor.Swaths.1, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") )  ;


plot(Tractor.Swaths,col="BLUE");

####   Get the area of each tractor swath polygon


Tractor.Swaths@data$P.area.m<-sapply(slot(Tractor.Swaths,"polygons"),slot,"area")  ;



#### Separate the data from each planted row 

# Initiallize the list of with a spatialPoligonsDataFrame object for each planted row
Planted.Rows<-list()

for (N.ROW in seq(1,N.ROWS ) ){
  Planted.Rows[[N.ROW]]<-raster::intersect(Tractor.Swaths,Tractor.Swath.lines.4[N.ROW,])
}

Planted.Rows[[2]]@data



plot(Planted.Rows[[100]], col="BLACK", add=T)


Tractor.Swaths[!is.na(over(Tractor.Swaths,Tractor.Swath.lines.4)),]

gIntersects(Tractor.Swath.lines.4@lines[[1]]@Lines, Tractor.Swath.lines.4@proj4string, Tractor.Swaths )

str(Tractor.Swaths@data)

str(Tractor.Swath.lines.4@data)


#################          Plant population estimates based on counts of plants 2016             ######################

#########################            Plants by row 2016                     ###########################


