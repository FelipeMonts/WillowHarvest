##############################################################################################################
# 
# 
# Program to calculatewillow yields from field data
# 
# Felipe Montes 2019  03 19
# 
# 
# 
# 
############################################################################################################### 



###############################################################################################################
#                          Loading Packages and setting up working directory                        
###############################################################################################################



#  Tell the program where the package libraries are  #####################


.libPaths("C:/Felipe/SotwareANDCoding/R_Library/library")  ;

#  Set Working directory

setwd('C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Wilow Harvest 2019') 


#Loand And install packages 
#install.packages('readxl', 'fansi', dependencies = T)

library(readxl,fansi) ;

#Read the data from the excel spreadsheet

Yield.Data.2019<-read_excel('RockviewWillowHarvest2019.xlsx', sheet= 'Yield', range="A2:J134",col_names = T, col_types = c("numeric", "text", "text","date", "date", "numeric", "numeric", "numeric","numeric","numeric")) ;


# Transform truck Id into a factor

Yield.Data.2019$Factor.TruckID<-as.factor(Yield.Data.2019$"Truck ID" ) ;

Yield.Data.2019$Time.as.text<-sapply(strsplit(as.character(Yield.Data.2019$Time),split=" "),"[[",2) ;

Yield.Data.2019$Date.Time<-as.POSIXct(paste(as.character(Yield.Data.2019$Date),Yield.Data.2019$Time.as.text,sep=" "),format="%Y-%m-%d %H:%M:%S")

#Select trucks IV and V (farm wagons that left the chips on the field)

TrucksIVandV<-Yield.Data.2019[Yield.Data.2019$Factor.TruckID == "IV" | Yield.Data.2019$Factor.TruckID == "V" ,];


Yield.leftover<-sum(TrucksIVandV$`Fresh Chips weight lb`);

# Convert the mass of fresh chips into cubic yards based on previous willow harvest

Yield.Data2016<-read_excel('../Yield Data/FreshWeightsBulkDensityLastRowsHarvest20160108.xlsx',sheet= 'BulkDensityData') ;

Bulk.Density<-c(mean(Yield.Data2016$'Bulk Density Free__1',na.rm=T), mean(Yield.Data2016$'Bulk Density Compressed__1')) ; #in lb/yd3

Yield.volume.leftover<-Yield.leftover/Bulk.Density[2] ; # in yd3

#calculate the losses left on the ground based on the % volume of a cone 

#volume of a cone V= (pi*R^2*h)/3
#Volume of a Frustrum V=1/3*pi*(Rb^2+Rb*Rt+Rt^2)

#Angle of repose of wood chips 45 ° 

R=0.8 # radious of a 45 ° angle of repose cone in m
h= 1.60 #height of the silage wagon plattform in m
a=0.3  # height of left out by the loader in m (looses of loading)
R1=(h-a)/2 #radious at the top of the frustrum with agle of repose 45 °
Cone.Volume<-pi/3*((h/2)^2)*h # in m3
Frustum.Volume<-pi/3*a*(R^2+R*R1+R1^2)# # in m3

Loss.percent<-Frustum.Volume/Cone.Volume

# Total yards to pick up
 Pickup.material<-Yield.volume.leftover*(1-Loss.percent)
 
 #truck loads 
 T.cap=30
 
 Total.trucks<-Pickup.material/T.cap
 

# Calculating wagon working hours
 

WagIV<-TrucksIVandV[TrucksIVandV$Factor.TruckID=="IV","Date.Time"];


total.WagIV = difftime("2019-03-02 18:32:00","2019-03-02 12:00:00") + difftime("2019-03-04 18:35:00","2019-03-04 08:05:00") + difftime("2019-03-08 11:45:00","2019-03-08 10:08:00")

WagV<-TrucksIVandV[TrucksIVandV$Factor.TruckID=="V","Date.Time"];

total.WagV = difftime("2019-03-02 18:32:00","2019-03-02 12:00:00") + difftime("2019-03-04 11:35:00","2019-03-04 08:42:00") + difftime("2019-03-04 18:35:00","2019-03-04 16:05:00") + difftime( "2019-03-08 11:45:00","2019-03-08 10:15:00")

Stopped.WagV= difftime("2019-03-04 16:05:00", "2019-03-04 11:35:00")


Total.wagIV.Wagv= total.WagIV + total.WagV

Cost.working.Hours=as.numeric(Total.wagIV.Wagv)*95 # U$95/hour

WagIV$Month.day<-as.factor(as.Date(WagIV$Date.Time)) ;

as.POSIXct(WagIV$Date.Time)[as.POSIXct(WagIV$Date.Time)==as.POSIXct("2019-03-02")]

max(WagIV)

max(as.Date(WagIV$Date.Time))

 
WagIV[as.Date(WagIV$Date)==as.Date("2019-03-02"),"Date.Time"]

 WagV<-TrucksIVandV[TrucksIVandV$`Truck ID`=="V",];


 