##############################################################################################################
# 
# 
# Program to analyze willow harvest research data 
# 
#    
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

setwd("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\WillowHarvest") ;   # 



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

library(RColorBrewer)

###############################################################################################################
#                           load data from DataCleaning.RData
###############################################################################################################


  load("DataCleaning.RData")

# View(Paper.data) ; str(Paper.data)

# N.ROW=35

#  View(Planted.Rows[[N.ROW]]@data);   str(Planted.Rows[[N.ROW]]@data)


###############################################################################################################
#                           Define Colors for Willow Varieties
###############################################################################################################

Paper.data$Colors<-as.factor(Paper.data$Variety.y)

levels(Paper.data$Colors)<-c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE')

Paper.data$Colors<-as.character(Paper.data$Colors)


###############################################################################################################
#                           Plot plant densities
###############################################################################################################




for (N.ROW in seq(1,N.ROWS ) ){
  
  Planted.Rows[[N.ROW]]@data$CumPlants2013<-cumsum(Planted.Rows[[N.ROW]]@data$Plants2013)
  Planted.Rows[[N.ROW]]@data$CumPlants2014<-cumsum(Planted.Rows[[N.ROW]]@data$Plants2014)
  
}

max(Paper.data$Length.m[-1])
max(c(max(Paper.data$Plants2013[-1]),max(Paper.data$Plants2014[-1])))
Paper.data$Plant.Density.pl.ha.2013
View(Paper.data)

plot(Paper.data$`Actual.Row.#`, Paper.data$Plant.Density.pl.ha.2013 )
points(Paper.data$`Actual.Row.#`, Paper.data$Plant.Density.pl.ha.2016, col="RED")



############ Figure 1 ##################################

plot(Planted.Rows[[2]]@data$P.length.along,Planted.Rows[[2]]@data$CumPlants2013, type='l', col="LIGHTGRAY", lwd=3,xlim=c( 0,max(Paper.data$Length.m[-1]) ), ylim=c(0, max(c(max(Paper.data$Plants2013[-1]),max(Paper.data$Plants2014[-1]))) ), xlab= "Length along each row, m" , ylab="Number of plants")
points(Planted.Rows[[2]]@data$P.length.along,Planted.Rows[[2]]@data$CumPlants2014, type='l', col="DARKGRAY",lwd=3)


for (N.ROW in seq(2,N.ROWS ) ){
  
  points(Planted.Rows[[N.ROW]]@data$P.length.along,Planted.Rows[[N.ROW]]@data$CumPlants2013, type='l', col="LIGHTGRAY" ,lwd=3)
  points(Planted.Rows[[N.ROW]]@data$P.length.along,Planted.Rows[[N.ROW]]@data$CumPlants2014, type='l', col="DARKGRAY",lwd=3)
  
}

points(Paper.data$Length.m,Paper.data$Plants2016, pch=21, col="BLACK", bg="white",cex=1.5)

legend(0,2500,legend=c("2014","2013","2016"), lty=c(1,1,NA), col=c("DARKGRAY","LIGHTGRAY", "BLACK"), pch=c(NA,NA, 21))

############ Figure 1 a ##################################



plot(Planted.Rows[[2]]@data$P.length.along,Planted.Rows[[2]]@data$CumPlants2013, type='l', col=Paper.data$Colors[2], lwd=5, xlim=c( 0,max(Paper.data$Length.m[-1]) ), ylim=c(0,max(Paper.data$Plants2013[-1])) , xlab= "Length along each row, m" , ylab="Number of plants")



for (N.ROW in seq(2,N.ROWS ) ){
  
  points(Planted.Rows[[N.ROW]]@data$P.length.along,Planted.Rows[[N.ROW]]@data$CumPlants2013, type='l', col=Paper.data$Colors[N.ROW] ,lwd=5)
 
  
}

points(Paper.data$Length.m,Paper.data$Plants2016, pch=21, col=Paper.data$Colors, bg=Paper.data$Colors,cex=2)

legend(0,2000,legend=c("PREBLE-2013","FABIUS-2013","MILBROOK-2013","SX61-2013","OTISCO-2013", "FISHCREEK-2013","2016"), lty=c(1,1,1,1,1,1,NA), lwd=c(2,2,2,2,2,2,NA),col=c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE','BLACK'), pch=c(NA,NA,NA,NA,NA,NA, 21))


#################  Statistical Analysis using row as experimental unit #########################

Paper.data$Variety<-as.factor(Paper.data$Variety.x)
levels(Paper.data$Variety)

Paper.data$Block<-1 ; 

Paper.data$Block[59:132]<-2 ;

names(Paper.data)[c(3,5)]<-c("HarvestWeight2015.lb","HarvestWeight2019.lb")

AnalysisHArvest2015<-lm(HarvestWeight2015.lb ~ Block + Variety +  Plant.Density.pl.ha.2013 +  Plant.Density.pl.ha.2014, data=Paper.data)

anova(AnalysisHArvest2015)
summary(AnalysisHArvest2015)

AnalysisHArvest2019.row<-glm(HarvestWeight2019.lb ~ Block + Variety +  Plant.Density.pl.ha.2013  + Plant.Density.pl.ha.2016, data=Paper.data)

anova(AnalysisHArvest2019)
summary(AnalysisHArvest2019)


#################  Statistical Analysis  using  plot as experimental unit #########################
 
#  View(Paper.data) ; str(Paper.data) 

Paper.data$BlockVariety<-as.factor(paste(Paper.data$Variety,Paper.data$Block,sep='_')) ;

str(Paper.data)




Paper.data.Plots.sum<-aggregate(formula= cbind(Plants2013, Plants2014, Plants2016, HarvestWeight2015.lb, HarvestWeight2019.lb, Area.m2) ~ Variety + Block, FUN=sum,data=Paper.data) ;

names(Paper.data.Plots.sum)<-c("Variety" , "Block",  "Sum_of_Plants2013" , "Sum_of_Plants2014" , "Sum_of_Plants2016" , "Sum_of_HarvestWeight2015.lb", "Sum_of_HarvestWeight2019.lb", "Sum_of_Area.m2")
  
Paper.data.Plots.mean<-aggregate(Paper.data, by=list(Paper.data$Variety,Paper.data$Block),FUN=mean) ;

names(Paper.data.Plots.mean)<-c("Variety" , "Block", "Actual.Row.#", "Variety.x" ,"mean_HarvestWeight2015.lb", "Variety.y" , "mean_HarvestWeight2019.lb","mean_Plants2016", "mean_Area.m2" ,"mean_Length.m", "mean_Plants2013", "mean_Plants2014", "mean_Plant.Density.pl.ha.2013","mean_Plant.Density.pl.ha.2014", "mean_Plant.Density.pl.ha.2016", "Colors", "Variety" , "Block", "BlockVariety");

DataForAnalysis<-cbind(Paper.data.Plots.sum,Paper.data.Plots.mean);
names(DataForAnalysis)

DataForAnalysis$Lb.m2.2015<-DataForAnalysis$Sum_of_HarvestWeight2015.lb/DataForAnalysis$Sum_of_Area.m2

DataForAnalysis$Lb.m2.2019<-DataForAnalysis$Sum_of_HarvestWeight2019.lb/DataForAnalysis$Sum_of_Area.m2

#  View(DataForAnalysis)

AnalysisHArvest2015.Plot<-lm(Lb.m2.2015 ~ Block + Variety +  mean_Plant.Density.pl.ha.2013 +  mean_Plant.Density.pl.ha.2014, data=DataForAnalysis);

anova(AnalysisHArvest2015.Plot)
summary(AnalysisHArvest2015.Plot)

AnalysisHArvest2019.Plot<-lm(Lb.m2.2019~ Block + Variety +  mean_Plant.Density.pl.ha.2013  +   mean_Plant.Density.pl.ha.2014 + mean_Plant.Density.pl.ha.2016, data=DataForAnalysis);

anova(AnalysisHArvest2019.Plot,test = "F")
summary(AnalysisHArvest2019.Plot)
effects(AnalysisHArvest2019.Plot)

