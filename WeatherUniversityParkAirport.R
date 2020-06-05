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


# install.packages('lattice', dep=T)

# install.packages('stringi', dep=T)

# install.packages('rgl', dep=T)

# install_github('sorhawell/forestFloor')

# install.packages('nlme', dep=T)

# install.packages('nlme', dep=T)

###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################



library(RColorBrewer)

library(openxlsx)

library(lattice)

library(devtools)

# library(forestFloor)

# library(rgl)

# library(raster)
# 
# library(nlme)

###############################################################################################################
#                           Read the data from the text files
###############################################################################################################

University.Park.Weather.1<-read.table(file='6094568232309dat.txt', header=T, as.is=T, na.strings = c("*","**","***","****","*****" )) ;


#   str(University.Park.Weather.1) ; View(University.Park.Weather.1)


### convert YR..MODAHRMN to .POSIXct date time format

University.Park.Weather.1$Date.Time<-as.POSIXct(as.character(University.Park.Weather.1$YR..MODAHRMN), tz = "", format=c("%Y%m%d%H%M")) ;

### Aggregate  the data by months to plot 

University.Park.Weather.1$Year.Month<-as.factor(as.character(format(University.Park.Weather.1$Date.Time, "%Y_%m")))


University.Park.Temp<-aggregate(TEMP~Year.Month, University.Park.Weather.1,FUN=mean ) ;

University.Park.Temp<-merge(University.Park.Temp, aggregate(MAX~Year.Month, University.Park.Weather.1,FUN=max ), by=c("Year.Month"), all=T)  ;

University.Park.Temp<-merge(University.Park.Temp, aggregate(MIN ~ Year.Month, University.Park.Weather.1,FUN=min ), by=c("Year.Month"), all=T)  ;

University.Park.Temp<-merge(University.Park.Temp, aggregate(PCP01~Year.Month, University.Park.Weather.1,FUN=sum ), by=c("Year.Month"), all=T)  ;

University.Park.Temp.Pcp<-University.Park.Temp ;

University.Park.Temp.Pcp[is.na(University.Park.Temp.Pcp$PCP01),c('PCP01')]<-0 ;


###############################################################################################################
#
#                           Transform the data to SI units
#
#                 https://www.nist.gov/pml/weights-and-measures/si-units
#                  https://www.nist.gov/pml/special-publication-330
#
###############################################################################################################



###### Transform the data to SI units #########

# View(University.Park.Temp.Pcp)  ; str(University.Park.Temp.Pcp)


University.Park.Temp.Pcp$TEMP_C<-(University.Park.Temp.Pcp$TEMP-32)/1.8 ;

University.Park.Temp.Pcp$MAX_C<-(University.Park.Temp.Pcp$MAX-32)/1.8  ;

University.Park.Temp.Pcp$MIN_C<-(University.Park.Temp.Pcp$MIN-32)/1.8   ;

University.Park.Temp.Pcp$PCP_MM<-University.Park.Temp.Pcp$PCP01*25.4  ;

###############################################################################################################
#                           Read the data from the text files
#    
#    Plot the Hyetograph together with the temperature using theR Water Module 3
#           https://web.ics.purdue.edu/~vmerwade/rwater.html
#
#
###############################################################################################################


###### set the graphical parameters right for creating the hyetograph

#There are a lof of NA values in the data set

University.Park.Temp.Pcp[is.na(University.Park.Temp.Pcp$PCP01),] ;

# Return the Year.Month to a date form of POSIXct class

University.Park.Temp.Pcp$Date.Year.Month<-as.Date(paste0(as.character(University.Park.Temp.Pcp$Year.Month),"_1"),format="%Y_%m_%d")


# mar :A numerical vector of the form c(bottom, left, top, right) which gives the number of lines of margin to be specified on the four sides of the plot. The default is c(5, 4, 4, 2) + 0.1.




# find the range of values to be plotted

Pcp.range<-range(University.Park.Temp.Pcp$PCP_MM) ; 

Temp.range<-range(range(University.Park.Temp.Pcp[,c('TEMP_C')]),range(University.Park.Temp.Pcp[!is.na(University.Park.Temp.Pcp$MAX_C),c('MAX_C')]), range(University.Park.Temp.Pcp[!is.na(University.Park.Temp.Pcp$MIN_C),c('MIN_C')])) ; 


DateTime.range<-range(University.Park.Weather.1[!is.na(University.Park.Weather.1$Date.Time),"Date.Time"]);

### adding a year to make the axis beter

DateTime.range.2<-DateTime.range ;

DateTime.range.2[2]<-as.Date(DateTime.range[2])+365


##### Create the graphics in EPS Postscript format ######

postscript(file="Figure1Weather.eps" , onefile=F, width=8, height=4, paper= "letter")


par(mar=c(3,5,1,4)+0.1);

#  plot the pcp
plot(University.Park.Temp.Pcp$Date.Year.Month, University.Park.Temp.Pcp$PCP_MM, type="h",yaxt="n",xaxt="n", ylim=rev(c(0,4*Pcp.range[2])), bty="n", main="University Park Airport",col="light blue",ylab=NA,xlab=NA, lwd=3);

# add axis with proper labeling

axis(side = 3, pos = 0, tck = 0,xaxt = "n") ;
axis(side = 4, at = pretty(seq(0, floor(Pcp.range[2] + 1),length=c(5))),labels=pretty(seq(0, floor(Pcp.range[2] + 1),length=c(5)))) ;
mtext(side=4,"Precipitation mm",line = 2, cex = 0.9, adj = 0.95) ;

#add Temp  plot
par(new=T);

par(mar=c(5.1, 4.1, 4.1 ,2.1))

plot(University.Park.Temp.Pcp$Date.Year.Month,University.Park.Temp.Pcp$TEMP_C, type='l',col="BLACK",axes=F,yaxt="n", ylab="Temperature °C",xlab="Date", ylim =c(-25,40));

#coordinates for the Temp max min polygon

#  View(University.Park.Temp.Pcp) ; str(University.Park.Temp.Pcp)  ; names(University.Park.Temp.Pcp)

Polygon.coords<-University.Park.Temp.Pcp[seq(7,96),c("TEMP_C" , "MAX_C" , "MIN_C" , "PCP_MM", "Date.Year.Month")] ;

Polygon.coords[1,c("MAX_C", "MIN_C")]<-(Temp.range[1]+Temp.range[2])/2 ;

polygon(x=c(Polygon.coords$Date.Year.Month, rev(Polygon.coords$Date.Year.Month)), y=c(Polygon.coords$MAX,rev(Polygon.coords$MIN)),col="GRAY")


#add axis with appropriate labels
axis.Date(side=1, at=seq(DateTime.range[1],DateTime.range.2[2],by='year')) 

#axis.POSIXct(side=1,University.Park.Temp.Pcp$Date.Year.Month, at=seq(DateTime.range[1],DateTime.range[2],length.out=5),labels=format(seq(DateTime.range[1],DateTime.range[2],length.out=5),"%Y")) ;
axis(side=2,at=pretty(seq(-25,40,length=15))) ;


#add aditional flow data 
lines(University.Park.Temp.Pcp$Date.Year.Month,University.Park.Temp.Pcp$TEMP_C, col="BLACK")

lines(University.Park.Temp.Pcp$Date.Year.Month,University.Park.Temp.Pcp$MAX_C, col="RED")

lines(University.Park.Temp.Pcp$Date.Year.Month,University.Park.Temp.Pcp$MIN_C, col="BLUE")


invisible(dev.off())


