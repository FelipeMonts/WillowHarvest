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

# install.packages('randomForest', dep=T)



###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################

library(randomForest)

library(RColorBrewer)

###############################################################################################################
#                           load data from DataCleaning.RData
###############################################################################################################


  load("DataCleaning.RData")

# View(Paper.data) ; str(Paper.data)

# N.ROW=94

#  View(Planted.Rows[[N.ROW]]);   str(Planted.Rows[[N.ROW]])


###############################################################################################################
#                           Define Colors for Willow Varieties
###############################################################################################################

Paper.data$Colors<-as.factor(Paper.data$VARIETY)

levels(Paper.data$Colors)<-c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE')

Paper.data$Colors<-as.character(Paper.data$Colors)


###############################################################################################################
#                           Plot plant densities
###############################################################################################################


max(Paper.data$Length.m)
max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))
Paper.data$Plant.Density.pl.ha.2013


plot(Paper.data$ROW, Paper.data$Plant.Density.pl.ha.2016, col="RED", ylim=c(0,16000))
points(Paper.data$ROW, Paper.data$Plant.Density.pl.ha.2013 )


############ Figure 1 ##################################

plot(Planted.Rows[[1]]$Points.1.Cumdistance, Planted.Rows[[1]]$P.length.along.2013, type='l', col="LIGHTGRAY", lwd=3,xlim=c( 0,max(Paper.data$Length.m) ), ylim=c(0, max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))+100), xlab= "Length along each row, m" , ylab="Number of plants")  ;
points(Planted.Rows[[1]]$Points.1.Cumdistance, Planted.Rows[[1]]$P.length.along.2014, type='l', col="DARKGRAY",lwd=3)


for (N.ROW in seq(2,N.ROWS ) ){
  
  points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance, Planted.Rows[[N.ROW]]$P.length.along.2013, type='l', col="LIGHTGRAY" ,lwd=3)
  points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance, Planted.Rows[[N.ROW]]$P.length.along.2014, type='l', col="DARKGRAY",lwd=3)
  
}

points(Paper.data$Length.m,Paper.data$Plants2013, pch=21, col="BLACK", bg="LIGHTGRAY",cex=1.5) ;

points(Paper.data$Length.m,Paper.data$Plants2014, pch=21, col="BLACK", bg="DARKGRAY",cex=1.5) ;

points(Paper.data$Length.m,Paper.data$Plants2016, pch=21, col="BLACK", bg="white",cex=1.5) ;

legend(0,1200,legend=c("2014","2013","2016"), lty=c(1,1,NA), col=c("DARKGRAY","LIGHTGRAY", "BLACK"), pch=c(NA,NA, 21))

############ Figure 1 a ##################################


plot(Planted.Rows[[1]]$Points.1.Cumdistance , Planted.Rows[[1]]$P.length.along.2013, type='l', col=Paper.data$Colors[1], lwd=5, xlim=c( 0,max(Paper.data$Length.m) ),ylim=c(0, max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))+100) , xlab= "Length along each row, m" , ylab="Number of plants")



for (N.ROW in seq(2,N.ROWS ) ){
  
  points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance , Planted.Rows[[N.ROW]]$P.length.along.2013, type='l', col=Paper.data$Colors[N.ROW] ,lwd=5)
 
  
}

points(Paper.data$Length.m , Paper.data$Plants2016, pch=21, col=Paper.data$Colors, bg=Paper.data$Colors,cex=2)

legend(0,1400,legend=c("PREBLE-2013","FABIUS-2013","MILBROOK-2013","SX61-2013","OTISCO-2013", "FISHCREEK-2013","2016"), lty=c(1,1,1,1,1,1,NA), lwd=c(2,2,2,2,2,2,NA),col=c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE','BLACK'), pch=c(NA,NA,NA,NA,NA,NA, 21))


############ Figure 1 b ##################################

plot(Planted.Rows[[1]]$Points.1.Cumdistance , Planted.Rows[[1]]$P.length.along.2014, type='l', col=Paper.data$Colors[1], lwd=5, xlim=c( 0,max(Paper.data$Length.m) ),ylim=c(0, max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))+100) , xlab= "Length along each row, m" , ylab="Number of plants")



for (N.ROW in seq(2,N.ROWS ) ){
  
  points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance , Planted.Rows[[N.ROW]]$P.length.along.2014, type='l', col=Paper.data$Colors[N.ROW] ,lwd=5)
  
  
}

points(Paper.data$Length.m , Paper.data$Plants2016, pch=21, col=Paper.data$Colors, bg=Paper.data$Colors,cex=2)

legend(0,1400,legend=c("PREBLE-2014","FABIUS-2014","MILBROOK-2014","SX61-2014","OTISCO-2014", "FISHCREEK-2014","2016"), lty=c(1,1,1,1,1,1,NA), lwd=c(2,2,2,2,2,2,NA),col=c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE','BLACK'), pch=c(NA,NA,NA,NA,NA,NA, 21))







#############################  Statistical Analysis #############################################



####  Create the apropriate factors ####


Paper.data$F.VARIETY<-as.factor(Paper.data$VARIETY)  ;
levels(Paper.data$F.VARIETY ) ;



Paper.data$BLOCK<-1 ; 

Paper.data$BLOCK[59:132]<-2 ;  


Paper.data$F.BLOCK<-as.factor(Paper.data$BLOCK) ;

str(Paper.data)

###  Calculating row yield in Dry mater in kg/ha 

Paper.data$DRY.MgHa.2015<-Paper.data$FRESH.LB.2015*(1-Paper.data$MOISTURE.2015)/ 2.204623 / 1000 ;# 2.204623 lb/kg  1000 kg/Mg


Paper.data$DRY.MgHa.2019<-Paper.data$FRESH.LB.2019*(1-Paper.data$MOISTURE.2019)/ 2.204623 / 1000  ; # 2.204623 lb/kg  1000 kg/Mg


#################  Exploratory Analysis using Random Forest  #########################

#  str(Paper.data)  ; View(Paper.data)  





#################  Statistical Analysis  using  plot as experimental unit #########################

#  View(Paper.data) ; str(Paper.data) 

######### Aggregating the data according to the total (sum) and the avreage (mean) of F.VARIETY and F.BLOCK groupings  ####################

Paper.data.Plots.sum<-aggregate(formula= cbind(Plants2013, Plants2014, Plants2016, DRY.MgHa.2015, DRY.MgHa.2019, Area.m2, Length.m ) ~ F.VARIETY + F.BLOCK, FUN=sum,data=Paper.data) ;

names(Paper.data.Plots.sum)[3:9]<- paste0("SUM_",c("Plants2013" ,   "Plants2014"  ,  "Plants2016"   , "DRY.MgHa.2015" , "DRY.MgHa.2019", "Area.m2", "Length.m"  )) ;




Paper.data.Plots.mean<-aggregate(formula= cbind(Plants2013, Plants2014, Plants2016, DRY.MgHa.2015, MOISTURE.2015, DRY.MgHa.2019, MOISTURE.2019, Area.m2, Length.m, Plant.Density.pl.ha.2013, Plant.Density.pl.ha.2014, Plant.Density.pl.ha.2016 ) ~ F.VARIETY + F.BLOCK, FUN=mean,data=Paper.data) ;

names(Paper.data.Plots.mean)[3:14]<-paste0("MEAN_",c("Plants2013" ,   "Plants2014"  ,  "Plants2016"   , "DRY.MgHa.2015" , "MOISTURE.2015" , "DRY.MgHa.2019", "MOISTURE.2019" ,"Area.m2", "Length.m" , "Plant.Density.pl.ha.2013" , "Plant.Density.pl.ha.2014" , "Plant.Density.pl.ha.2016"  )) ;

DataForAnalysis<-merge(Paper.data.Plots.sum,Paper.data.Plots.mean, by=c("F.VARIETY","F.BLOCK"));

names(DataForAnalysis)




#  View(DataForAnalysis)

AnalysisHArvest2015.Plot<-lm(Lb.m2.2015 ~ Block + Variety +  mean_Plant.Density.pl.ha.2013 +  mean_Plant.Density.pl.ha.2014, data=DataForAnalysis);

anova(AnalysisHArvest2015.Plot)
summary(AnalysisHArvest2015.Plot)

AnalysisHArvest2019.Plot<-lm(Lb.m2.2019~ Block + Variety +  mean_Plant.Density.pl.ha.2013  +   mean_Plant.Density.pl.ha.2014 + mean_Plant.Density.pl.ha.2016, data=DataForAnalysis);

anova(AnalysisHArvest2019.Plot,test = "F")
summary(AnalysisHArvest2019.Plot)
effects(AnalysisHArvest2019.Plot)

#########################################################################################################
#
#
#               A very good resource for glm analysis in R is the website of 
#            German Rodriguez, Senior Research Demographer
#                 Office of Population Research (OPR)
#               Princeton University's Woodrow Wilson School of Public and International Affaris 
#                        https://data.princeton.edu/P
#
#
#########################################################################################################






#################  Statistical Analysis using row as experimental unit #########################


AnalysisHArvest2015<-glm(FRESH.LB.2015 ~ F.BLOCK + F.VARIETY +  Plants2013 +  Plants2014 + Plant.Density.pl.ha.2013 +  Plant.Density.pl.ha.2014 + Plant.Density.pl.ha.2016, data=Paper.data, family=gaussian );

summary(AnalysisHArvest2015)


anova(AnalysisHArvest2015)


AnalysisHArvest2019.row<-glm(2015.FRESH.LB ~ Block + Variety +  Plant.Density.pl.ha.2013  + Plant.Density.pl.ha.2016, data=Paper.data)

anova(AnalysisHArvest2019)
summary(AnalysisHArvest2019)




