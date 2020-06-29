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

# install.packages('lattice', dep=T)

# install.packages('stringi', dep=T)

# install.packages('rgl', dep=T)

# install_github('sorhawell/forestFloor')

# install.packages('nlme', dep=T)

# install.packages('nlme', dep=T)

# install.packages('broom', dep=T)

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
library(broom)

###############################################################################################################
#                           load data from DataCleaning.RData
###############################################################################################################


  load("DataCleaning.RData")

# View(Paper.data) ; str(Paper.data)

# N.ROW=94

#  View(Planted.Rows[[N.ROW]]);   str(Planted.Rows[[N.ROW]])



###############################################################################################################
#                          Corrections to the data made in consultation with Armen 5/21/2020
###############################################################################################################

#Spreadsheet Row_Data has harvest data summarized by Felipe. Armen and Felipe evaluated if row # and variety name were a match. I all instances marked with red the numbers were corrected. 

#Only one row of SX61 remains highly suspicious (row 101), not on identity but on measured yield. Too high. However, it is next to a row with very low yield so it can be a border row. 

#All the data from row 114 on was moved 1 row down for the columns "Plants2016" and "Plant.Density.pl.ha.2016".Row 114 plant count for 2016 was modified  with the median of the rows above it with the smame block-variety. Plant density for 2016 was modified as well. All the data from row 114 on was moved 1 row down. 



Paper.data[seq(113,132),]

Paper.data.rows.114.131<-Paper.data[seq(114,131),c("Plants2016", "Plant.Density.pl.ha.2016")];


Paper.data[seq(115,132),c("Plants2016","Plant.Density.pl.ha.2016" )]<-Paper.data.rows.114.131  ;

Paper.data[114,c("Plants2016")]<-median(Paper.data[seq(101,113),c("Plants2016")]) ;

Paper.data[114,c("Plant.Density.pl.ha.2016")]<-median(Paper.data[seq(101,113),c("Plant.Density.pl.ha.2016")]) ;



#Yield of last two rows of Fabius were averaged. The border row had higher yield, and shadowed the row. That fixed matters.

Paper.data[seq(128,132),]  #### See This change marked with #*************



#Note on block or row: Correct analysis is by block. However when AVERAGING by block or by row I get the same average by variety. I think we can use row analysis so we can show the effect of population on yield. But use the Supp Information to show the same analysis using block, when covariance with plant number is pretty much useless.

#Average yield was nearly identical in 2015-16 winter vs 2018-19 winter: 291 Mg dry harvest, annual yield 6.7 Mg/ha. An estimate of achievable maximum yield is 8.7 to 9.0 Mg/ha/yr, considering the top 10% of the best rows. 







# ###############################################################################################################
# #                           Define Colors for Willow Varieties
# ###############################################################################################################
# 
# Paper.data$Colors<-as.factor(Paper.data$VARIETY)
# 
# levels(Paper.data$Colors)<-c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE')
# 
# Paper.data$Colors<-as.character(Paper.data$Colors)
# 
# 
# ###############################################################################################################
#                           Plot plant densities
###############################################################################################################
# 
# 
# max(Paper.data$Length.m)
# max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))
# Paper.data$Plant.Density.pl.ha.2013
# 
# 
# plot(Paper.data$ROW, Paper.data$Plant.Density.pl.ha.2016, col="RED", ylim=c(0,16000))
# points(Paper.data$ROW, Paper.data$Plant.Density.pl.ha.2013 )
# 
# ###############################################################################################################
# #                           Figure ##
# ###############################################################################################################
# 
# 
# 
# plot(Planted.Rows[[1]]$Points.1.Cumdistance, Planted.Rows[[1]]$P.length.along.2013, type='l', col="LIGHTGRAY", lwd=3,xlim=c( 0,max(Paper.data$Length.m) ), ylim=c(0, max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))+100), xlab= "Length along each row, m" , ylab="Number of plants")  ;
# points(Planted.Rows[[1]]$Points.1.Cumdistance, Planted.Rows[[1]]$P.length.along.2014, type='l', col="DARKGRAY",lwd=3)
# 
# 
# for (N.ROW in seq(2,N.ROWS ) ){
#   
#   points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance, Planted.Rows[[N.ROW]]$P.length.along.2013, type='l', col="LIGHTGRAY" ,lwd=3)
#   points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance, Planted.Rows[[N.ROW]]$P.length.along.2014, type='l', col="DARKGRAY",lwd=3)
#   
# }
# 
# points(Paper.data$Length.m,Paper.data$Plants2013, pch=21, col="BLACK", bg="LIGHTGRAY",cex=1.5) ;
# 
# points(Paper.data$Length.m,Paper.data$Plants2014, pch=21, col="BLACK", bg="DARKGRAY",cex=1.5) ;
# 
# points(Paper.data$Length.m,Paper.data$Plants2016, pch=21, col="BLACK", bg="white",cex=1.5) ;
# 
# legend(0,1200,legend=c("2014","2013","2016"), lty=c(1,1,NA), col=c("DARKGRAY","LIGHTGRAY", "BLACK"), pch=c(NA,NA, 21))
# 
# 
# ###############################################################################################################
# #                           Figure ## a
# ###############################################################################################################
# 
# plot(Planted.Rows[[1]]$Points.1.Cumdistance , Planted.Rows[[1]]$P.length.along.2013, type='l', col=Paper.data$Colors[1], lwd=5, xlim=c( 0,max(Paper.data$Length.m) ),ylim=c(0, max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))+100) , xlab= "Length along each row, m" , ylab="Number of plants")
# 
# 
# 
# for (N.ROW in seq(2,N.ROWS ) ){
#   
#   points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance , Planted.Rows[[N.ROW]]$P.length.along.2013, type='l', col=Paper.data$Colors[N.ROW] ,lwd=5)
#  
#   
# }
# 
# points(Paper.data$Length.m , Paper.data$Plants2016, pch=21, col=Paper.data$Colors, bg=Paper.data$Colors,cex=2)
# 
# legend(0,1400,legend=c("PREBLE-2013","FABIUS-2013","MILBROOK-2013","SX61-2013","OTISCO-2013", "FISHCREEK-2013","2016"), lty=c(1,1,1,1,1,1,NA), lwd=c(2,2,2,2,2,2,NA),col=c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE','BLACK'), pch=c(NA,NA,NA,NA,NA,NA, 21))
# 
# 
# 
# ###############################################################################################################
# #                           Figure ## b
# ###############################################################################################################
# 
# 
# plot(Planted.Rows[[1]]$Points.1.Cumdistance , Planted.Rows[[1]]$P.length.along.2014, type='l', col=Paper.data$Colors[1], lwd=5, xlim=c( 0,max(Paper.data$Length.m) ),ylim=c(0, max(c(max(Paper.data$Plants2013),max(Paper.data$Plants2014)))+100) , xlab= "Length along each row, m" , ylab="Number of plants")
# 
# 
# 
# for (N.ROW in seq(2,N.ROWS ) ){
#   
#   points(Planted.Rows[[N.ROW]]$Points.1.Cumdistance , Planted.Rows[[N.ROW]]$P.length.along.2014, type='l', col=Paper.data$Colors[N.ROW] ,lwd=5)
#   
#   
# }
# 
# points(Paper.data$Length.m , Paper.data$Plants2016, pch=21, col=Paper.data$Colors, bg=Paper.data$Colors,cex=2)
# 
# legend(0,1400,legend=c("PREBLE-2014","FABIUS-2014","MILBROOK-2014","SX61-2014","OTISCO-2014", "FISHCREEK-2014","2016"), lty=c(1,1,1,1,1,1,NA), lwd=c(2,2,2,2,2,2,NA),col=c('LIGHTGREEN', 'GREEN','DARKGREEN','LIGHTBLUE','BLUE', 'DARKBLUE','BLACK'), pch=c(NA,NA,NA,NA,NA,NA, 21))


###############################################################################################################
#                           Plot survey results
###############################################################################################################


###############################################################################################################
#                           Figure 1
###############################################################################################################

# create standard colors and break points for the figures of the spatila plant distribution according to the surveys

Survey.Raster.Levels<-seq(0,120,10) ;

Survey.Raster.Colors<-terrain.colors(13, rev=T)
+

postscript(file="..\\Agronomy Journal\\Figure2Surveys.eps" , onefile=F, width=8, height=4, paper= "letter") ;

par(mfcol=c(1,3))


Plant.Survey.2013<-mask(raster(Plants.2013.Tps.sp.V1)*50,Boundary.Polygon);


plot(Plant.Survey.2013, breaks=Survey.Raster.Levels, col=Survey.Raster.Colors, axes=F, box=F, legend=F, main="2013");

contour(Plant.Survey.2013, add=T) ;

#plot(Plant.Survey.2013, legend.only=T, breaks=Survey.Raster.Levels, col=Survey.Raster.Colors, horizontal =T); 



Plant.Survey.2014<-mask(raster(Plants.2014.Tps.sp.V1)*50,Boundary.Polygon);

plot(Plant.Survey.2014, breaks=Survey.Raster.Levels, col=Survey.Raster.Colors, axes=F, box=F, legend=F, main="2014") ;

contour(Plant.Survey.2014, add=T) ;

plot(Plant.Survey.2014, breaks=Survey.Raster.Levels, col=Survey.Raster.Colors, legend.only=T, horizontal =T, legend.shrink=1.1)




Plant.Survey.2016<-Raster.2016*50;

maxValue(Plant.Survey.2016)

### reduce the max values to 120 to be able to plot in the same color and break format

Plant.Survey.2016@data@values[which(Plant.Survey.2016@data@values>120)]<-120

plot(Plant.Survey.2016, breaks=Survey.Raster.Levels, col=Survey.Raster.Colors, axes=F, box=F, legend=F, main="2016", interpolate=T) ;

contour(Plant.Survey.2016, levels=c(0,20,40,60,80,100,120), add=T) ;
max(Plant.Survey.2016)

#plot(Plant.Survey.2016, breaks=Survey.Raster.Levels, col=Survey.Raster.Colors,legend.only=T, horizontal =T, legend.shrink=1.1)

invisible(dev.off())

#############################  Statistical Analysis #############################################



####  Create the apropriate factors ####


Paper.data$F.VARIETY<-as.factor(Paper.data$VARIETY)  ;
levels(Paper.data$F.VARIETY ) ;



Paper.data$BLOCK<-1 ; 

Paper.data$BLOCK[59:132]<-2 ;  


Paper.data$F.BLOCK<-as.factor(Paper.data$BLOCK) ;

str(Paper.data)


### reshape the data to create two factors Harvest.Year, and Survey.Year


Paper.data.I1<-reshape(Paper.data, drop=c("Plant.Density.pl.ha.2013" , "Plant.Density.pl.ha.2014", "Plant.Density.pl.ha.2016"),varying=list(c("FRESH.LB.2015", "FRESH.LB.2019"), c("MOISTURE.2015", "MOISTURE.2019")) , v.names=c("FRESH.LB","MOISTURE"),idvar="ROW", times=c(2015,2019), timevar = "HARVEST.YEAR", direction="long" ); 

#  View(Paper.data.I1) ; str(Paper.data.I1) ; names(Paper.data.I1)

Paper.data.I2<-reshape(Paper.data.I1, varying=list(c("Plants2013" , "Plants2014" , "Plants2016")) , v.names=c("PLANT.SURVEY"), times=c(2013,2014,2016), timevar = "SURVEY.YEAR", direction="long");

#  View(Paper.data.I2) ; str(Paper.data.I2) ; names(Paper.data.I2)

Paper.data.V2<-as.data.frame(Paper.data.I2, row.names=seq(1,dim(Paper.data.I2)[1])) ;

Paper.data.V2$F.HARVEST.YEAR<-as.factor(Paper.data.V2$HARVEST.YEAR);

Paper.data.V2$F.SURVEY.YEAR<-as.factor(Paper.data.V2$SURVEY.YEAR);


##  View(Paper.data.V2) ; str(Paper.data.V2) ; names(Paper.data.V2)

###  Calculating row yield in Dry mater in kg/ha 


Paper.data.V2$DRY.Mg<-Paper.data.V2$FRESH.LB*(1-Paper.data.V2$MOISTURE)/ 2.204623 / 1000 ;# 2.204623 lb/kg  1000 kg/Mg

Paper.data.V2$DRY.Mg.Ha<-Paper.data.V2$DRY.Mg/Paper.data.V2$Area.m2*10000  ;

Paper.data.V2$DRY.Mg.Ha.Year<-Paper.data.V2$DRY.Mg.Ha/3 ;


###  Recalculating Plant Densities in plants.ha

Paper.data.V2$PLANT.DENSITY.pl.ha<-(Paper.data.V2$PLANT.SURVEY/Paper.data.V2$Area.m2)*10000


### check the changes made with Armen have not been modified 

Paper.data[which(Paper.data$ROW==114) ,]

Paper.data.V2[which(Paper.data.V2$ROW==114) ,]

### recalculate value of plant density of row 114 of the survey 2016 to the median of the rows above it with the smame block-variety

Paper.data.V2[which(Paper.data.V2$ROW==114 & Paper.data.V2$SURVEY.YEAR==2016), c('PLANT.DENSITY.pl.ha')]<-median(Paper.data[seq(101,113),c("Plant.Density.pl.ha.2016")]) ;



#******************** Change made 5/21/20 Yield of last two rows of Fabius (DRY.Mg.Ha.2015, DRY.Mg.Ha.2019) were averaged using the geometric mean . The border row had higher yield, and shadowed the row. That fixed matters. 

Paper.data.V2[which((Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) & Paper.data.V2$HARVEST_YEAR==2015),c('DRY.Mg.Ha')] 


Paper.data.Last2Rows.DRY.Mg.Ha.2015<-unique(Paper.data.V2[which((Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) & Paper.data.V2$HARVEST_YEAR==2015),c('DRY.Mg.Ha')] )

Paper.data.Last2Rows.DRY.Mg.Ha.GeoMean.2015<-exp(mean(log(Paper.data.Last2Rows.DRY.Mg.Ha.2015))) ;

Paper.data.V2[which((Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) & Paper.data.V2$HARVEST_YEAR==2015),c('DRY.Mg.Ha')] <-Paper.data.Last2Rows.DRY.Mg.Ha.GeoMean.2015 ;


Paper.data.V2[which((Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) & Paper.data.V2$HARVEST_YEAR==2019),c('DRY.Mg.Ha')] 

Paper.data.Last2Rows.DRY.Mg.Ha.2019<-unique(Paper.data.V2[which((Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) & Paper.data.V2$HARVEST_YEAR==2019),c('DRY.Mg.Ha')] )

Paper.data.Last2Rows.DRY.Mg.Ha.GeoMean.2019<-exp(mean(log(Paper.data.Last2Rows.DRY.Mg.Ha.2019))) ;

Paper.data.V2[which((Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) & Paper.data.V2$HARVEST_YEAR==2019),c('DRY.Mg.Ha')] <-Paper.data.Last2Rows.DRY.Mg.Ha.GeoMean.2019 ;



Paper.data.V2[which(Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) , c('DRY.Mg.Ha.Year')]<-Paper.data.V2[which(Paper.data.V2$ROW==131 | Paper.data.V2$ROW==132 ) , c('DRY.Mg.Ha')]/3 ;


###############################################################################################################
#                           Print the data in an excel workbook WillowHarvestDataAnalysis.xlsx
###############################################################################################################

Willow.Harvest.wb<-createWorkbook() ;

addWorksheet(Willow.Harvest.wb, sheetName='Row_Data') ;

writeDataTable(Willow.Harvest.wb, sheet='Row_Data',x=Paper.data ) ;


# ###############################################################################################################
# #                           Exploratory Analysis using Random Forest
# ###############################################################################################################
# 
# 
# #  str(Paper.data)  ; View(Paper.data)   ; names(Paper.data)
# 
# # set the seed for the random number generator
# 
# #  Rand.Num.Seed<-.Random.seed 
# 
# .Random.seed<-Rand.Num.Seed ;
# 
# 
# ###############################################################################################################
# #                           Random Forest exploratory analysis for  2015 Harvest (DRY.MgHa.2015)
# ###############################################################################################################
# 
# 
# 
# rf.Paper.data.2015<-randomForest(formula=DRY.Mg.Ha.Year.2015 ~ ROW + F.VARIETY + F.BLOCK + MOISTURE.2015 + Plant.Density.pl.ha.2013 + Plant.Density.pl.ha.2014 +Plant.Density.pl.ha.2016 + Length.m,  data=Paper.data[1:131,], importance=T, proximity=T ) ;
# 
# print(rf.Paper.data.2015) ;
# 
# plot(rf.Paper.data.2015) ;
# 
# varImpPlot(rf.Paper.data.2015) ;
# 
# print(rf.Paper.data.2015$importance) ;
# 
# 
# partialPlot(rf.Paper.data.2015, pred.data = Paper.data[1:131,], x.var=F.VARIETY, plot=T) ;
# 
# partialPlot(rf.Paper.data.2015, pred.data = Paper.data[1:131,], x.var=Length.m , plot=T) ;
# 
# partialPlot(rf.Paper.data.2015, pred.data = Paper.data[1:131,], x.var=ROW, plot=T) ;
# 
# partialPlot(rf.Paper.data.2015, pred.data = Paper.data[1:131,], x.var=Plant.Density.pl.ha.2013, plot=T) ;
# 
# partialPlot(rf.Paper.data.2015, pred.data = Paper.data[1:131,], x.var=Plant.Density.pl.ha.2014, plot=T) ;
# 
# partialPlot(rf.Paper.data.2015, pred.data = Paper.data[1:131,], x.var=Plant.Density.pl.ha.2016, plot=T) ;
# 
# partialPlot(rf.Paper.data.2015, pred.data = Paper.data[1:131,], x.var=MOISTURE.2015, plot=T) ;
# 
# varUsed(rf.Paper.data.2015, by.tree=FALSE, count=TRUE)
# 
# 
# 
# ###############################################################################################################
# #                           Random Forest exploratory analysis for  2019 Harvest (DRY.MgHa.2019)
# ###############################################################################################################
# 
# 
# rf.Paper.data.2019<-randomForest(formula=DRY.Mg.Ha.Year.2019 ~ ROW + F.VARIETY + F.BLOCK + Plant.Density.pl.ha.2016 + DRY.Mg.Ha.Year.2015 ,  data=Paper.data[1:131,], importance=T, keep.inbag=T) ;
# 
# print(rf.Paper.data.2019) ;
# 
# plot(rf.Paper.data.2019) ;
# 
# varImpPlot(rf.Paper.data.2019) ;
# 
# print(rf.Paper.data.2019$importance) ;
# 
# partialPlot(rf.Paper.data.2019, pred.data = Paper.data[1:131,], x.var=F.VARIETY, plot=T) ;
# 
# partialPlot(rf.Paper.data.2019, pred.data = Paper.data[1:131,], x.var=Length.m, plot=T) ;
# 
# partialPlot(rf.Paper.data.2019, pred.data = Paper.data[1:131,], x.var=ROW, plot=T) ;
# 
# partialPlot(rf.Paper.data.2019, pred.data = Paper.data[1:131,], x.var=Plant.Density.pl.ha.2013, plot=T) ;
# 
# partialPlot(rf.Paper.data.2019, pred.data = Paper.data[1:131,], x.var=Plant.Density.pl.ha.2014, plot=T) ;
# 
# partialPlot(rf.Paper.data.2019, pred.data = Paper.data[1:131,], x.var=Plant.Density.pl.ha.2016, plot=T) ;
# 
# partialPlot(rf.Paper.data.2019, pred.data = Paper.data[1:131,], x.var=MOISTURE.2019, plot=T) ;
# 
# 
# 
# ###################### Forest Floor visualizations #################################
# 
# fF.Paper.data.2019<-forestFloor(rf.Paper.data.2019, X=Paper.data[1:131,])
# 
# print(fF.Paper.data.2019)
# 
# head(fF.Paper.data.2019$X)
# head(fF.Paper.data.2019$FCmatrix)
# fF.Paper.data.2019$importance
# 
# 
# fcol(fF.Paper.data.2019,cols=)
# 
# plot(fF.Paper.data.2019, col=fcol(fF.Paper.data.2019,2))
# 
# show3d(fF.Paper.data.2019, Xi=c(1,5),col=fcol(fF.Paper.data.2019,1) )
# 
# rgl.postscript("3dPlot.eps", fmt = "eps", drawText = TRUE )


###############################################################################################################
#                           Statistical Analysis  using  plot (Variety and Block) as experimental unit
###############################################################################################################


#  View(Paper.data.V2) ; str(Paper.data.V2) 

######### Aggregating the data according to the average (mean) of F.VARIETY, F.BLOCK , F.HARVEST.YEAR and  F.SURVEY.YEARgroupings  ####################


Paper.data.Plots.mean<-aggregate(formula= cbind(DRY.Mg.Ha,DRY.Mg.Ha.Year, MOISTURE, PLANT.DENSITY.pl.ha, Area.m2 , Length.m ) ~ F.VARIETY + F.BLOCK + F.HARVEST.YEAR + F.SURVEY.YEAR , FUN=mean,data=Paper.data.V2) ;

#  View(Paper.data.Plots.mean); str(Paper.data.Plots.mean) ; names(Paper.data.Plots.mean)

names(Paper.data.Plots.mean)[5:10]<-paste0("MEAN_",c("DRY.Mg.Ha", "DRY.Mg.Ha.Year" , "MOISTURE" , "PLANT.DENSITY.pl.ha" , "Area.m2" , "Length.m")) ;

#  View(Paper.data.Plots.mean)


######### Aggregating the data according to the total (sum) of F.VARIETY and F.BLOCK groupings  ####################

Paper.data.Plots.sum<-aggregate(formula= cbind(Area.m2 , Length.m ) ~ F.VARIETY + F.BLOCK + F.HARVEST.YEAR + F.SURVEY.YEAR , FUN=sum,data=Paper.data.V2) ;

#  View(Paper.data.Plots.sum); str(Paper.data.Plots.sum) ; names(Paper.data.Plots.sum)

names(Paper.data.Plots.sum)[5:6]<-paste0("TOTAL_",c("Area.m2" , "Length.m")) ;

######### Putting together  the data according to the average (mean) and the total (sum) groupings  ####################

Paper.data.Plots<-merge(Paper.data.Plots.mean, Paper.data.Plots.sum) ;

#  str(Paper.data.Plots) ; View(Paper.data.Plots) ;

###############################################################################################################
#                           Print the data in a new sheet in the excel workbook WillowHarvestDataAnalysis.xlsx
###############################################################################################################

addWorksheet(Willow.Harvest.wb, sheetName = 'Row_Data.V2')  ;

writeDataTable(Willow.Harvest.wb, sheet='Row_Data.V2', x=Paper.data.V2) ;


addWorksheet(Willow.Harvest.wb, sheetName = 'Plot_Data')  ;

writeDataTable(Willow.Harvest.wb, sheet='Plot_Data', x=Paper.data.Plots) ;



saveWorkbook(Willow.Harvest.wb, file=paste0('../WillowHarvestDataAnalysis', format(Sys.time(),"%Y_%m_%d_%H_%M"), '.xlsx'), overwrite = F ) ;

###############################################################################################################
#                           Results Figures
###############################################################################################################


#### Bar Chart, of Results, Need to aggregate by harvest and Variety

#  str(Paper.data.Plots)

postscript(file="..\\Agronomy Journal\\Figure5Harvest.eps" , onefile=F, width=8, height=6, paper= "letter")

# par("mar")  default (5.1 4.1 4.1 2.1)

par(mar=c(5.1, 4.1, 4.1 ,4.1))

### Bar Chart MEAN_DRY.Mg.Ha

Paper.data.Plots.bar.chart.2<-aggregate(formula= MEAN_DRY.Mg.Ha ~  F.HARVEST.YEAR + F.VARIETY  , FUN=mean , data=Paper.data.Plots) ;

barplot(MEAN_DRY.Mg.Ha ~ F.HARVEST.YEAR + F.VARIETY , data=Paper.data.Plots.bar.chart.2, beside=T, legend.text=T,args.legend = list(x = 16 , y = 26), col=c("RED", "BLUE"),mgp=c(2,1,0), ylab=expression(paste("OD Mg ","ha"^-1)), xlab="Genetic Material", cex.names=0.8,main="Biomass Yield");


#add Temp  plot
par(new=T);


### Bar Chart MEAN_DRY.Mg.Ha.Year

Paper.data.Plots.bar.chart.1<-aggregate(formula= MEAN_DRY.Mg.Ha.Year ~  F.HARVEST.YEAR + F.VARIETY  , FUN=mean , data=Paper.data.Plots) ;


#  str(Paper.data.Plots.bar.chart) ; View(Paper.data.Plots.bar.chart)

barplot(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR + F.VARIETY , data=Paper.data.Plots.bar.chart.1, beside=T, col=c("RED", "BLUE"), axes=F, ylab="", names=c(rep("",6)),xlab="") ;
        
axis(side=4, mgp=c(4,1,0)) ;

mtext(expression(paste("OD Mg ","ha"^-1, "year"^-1)), side=4, line=2) 

invisible(dev.off())





### Bar Chart MEAN_PLANT.DENSITY.pl.ha

Paper.data.Plots.bar.chart.3<-aggregate(formula= MEAN_PLANT.DENSITY.pl.ha ~  F.SURVEY.YEAR + F.VARIETY  , FUN=mean , data=Paper.data.Plots) ;


barplot(MEAN_PLANT.DENSITY.pl.ha  ~ F.SURVEY.YEAR + F.VARIETY , data=Paper.data.Plots.bar.chart.3, beside=T, legend.text=T,args.legend = list(x = 26 , y = 15000), col=c("YELLOW", "GREEN", "BROWN"),mgp=c(2,1,0), ylab=expression(paste(" Plants  ","ha"^-1)), xlab="WILLOW CLONE", cex.names=1, ylim=c(0,15000),main="Plant Density");


###########   plot of total plants per ha  vs total harvest per ha

#  View(Paper.data.V2) ; str(Paper.data.V2) 

CLONE="SX61" 

SURVEY="2013"
HARVEST="2015"

plot(Paper.data.V2[which(Paper.data.V2$VARIETY == CLONE & Paper.data.V2$F.SURVEY.YEAR == SURVEY & Paper.data.V2$HARVEST.YEAR == HARVEST),'PLANT.DENSITY.pl.ha'],
     Paper.data.V2[which(Paper.data.V2$VARIETY == CLONE & Paper.data.V2$F.SURVEY.YEAR == SURVEY & Paper.data.V2$HARVEST.YEAR == HARVEST),'DRY.Mg.Ha'], col='BLUE',
     main=paste0(CLONE," SURVEY=",SURVEY ," HARVEST=",HARVEST),ylab="OD Mg" ,xlab="PLANTS / ha",xlim=c(0, 12000)) ;

SURVEY="2014"

points(Paper.data.V2[which(Paper.data.V2$VARIETY == CLONE & Paper.data.V2$F.SURVEY.YEAR == SURVEY & Paper.data.V2$HARVEST.YEAR == HARVEST),'PLANT.DENSITY.pl.ha'],
       Paper.data.V2[which(Paper.data.V2$VARIETY == CLONE & Paper.data.V2$F.SURVEY.YEAR == SURVEY & Paper.data.V2$HARVEST.YEAR == HARVEST),'DRY.Mg.Ha'], col='RED') ;
legend(x='top', legend=c("2013", "2014"), text.col = c("BLUE" , "RED"))


SURVEY="2016"
HARVEST="2019"

plot(Paper.data.V2[which(Paper.data.V2$VARIETY == CLONE & Paper.data.V2$F.SURVEY.YEAR == SURVEY & Paper.data.V2$HARVEST.YEAR == HARVEST),'PLANT.DENSITY.pl.ha'],
     Paper.data.V2[which(Paper.data.V2$VARIETY == CLONE & Paper.data.V2$F.SURVEY.YEAR == SURVEY & Paper.data.V2$HARVEST.YEAR == HARVEST),'DRY.Mg.Ha'], col='BLACK', 
     main=paste0(CLONE," SURVEY=",SURVEY ," HARVEST=",HARVEST),ylab="OD Mg" ,xlab="PLANTS / ha") ;






###############################################################################################################
#                           Analysis using lm 
###############################################################################################################

#   str(Paper.data.Plots) ;View(Paper.data.Plots)

Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]

AnalysisHArvest.Plot<-lm(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * F.BLOCK * F.VARIETY  , data=Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]); ### Overfitted


AnalysisHArvest.Plot.TS1<-lm(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * (F.BLOCK + F.VARIETY)  , data=Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]); ### Table S1

summary(AnalysisHArvest.Plot.TS1)

anova(AnalysisHArvest.Plot.TS1, test="F")

TS1<-tidy(anova(AnalysisHArvest.Plot.TS1, test="F"))
names(TS1)

TS1.coeff<-tidy(AnalysisHArvest.Plot.TS1)



AnalysisHArvest.Plot.T1<-lm(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * F.VARIETY  , data=Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]);### Table 1

summary(AnalysisHArvest.Plot.T1)

anova(AnalysisHArvest.Plot.T1, test="F")

T1<-tidy(anova(AnalysisHArvest.Plot.T1, test="F"))

T1.coeff<-tidy(AnalysisHArvest.Plot.T1)



# ###############################################################################################################
# #                           Analysis using lm  and adding a dummy variable to include the survey year
# ###############################################################################################################
# 
# # View(Paper.data.Plots)  ;  str(Paper.data.Plots)
# 
# #  For three different cathegories, two dummy variables are needed to differentiate between them; [z1, z2] where z1={1, 0, 0} and z2={0, 1, 0}
# #  See Draper and Smith, 1998. Applied Regression Analysis
# # 
# 
# Paper.data.Plots$Z1<-Paper.data.Plots$Z2<-0 ;
# 
# # Dummy variables for survey year 2013 = {z1=1, z2=0}
# 
# Paper.data.Plots[Paper.data.Plots$F.SURVEY.YEAR == "2013", c("Z1")]<-1 ;
# Paper.data.Plots[Paper.data.Plots$F.SURVEY.YEAR == "2013", c("Z2")]<-0 ;
# 
# 
# # Dummy variables for survey year 2014 = {z1=0, z2=1}
# 
# Paper.data.Plots[Paper.data.Plots$F.SURVEY.YEAR == "2014", c("Z1")]<-0 ;
# Paper.data.Plots[Paper.data.Plots$F.SURVEY.YEAR == "2014", c("Z2")]<-1 ;
# 
# 
# 
# # Dummy variables for survey year 2015 = {z1=0, z2=0}
# 
# Paper.data.Plots[Paper.data.Plots$F.SURVEY.YEAR == "2016", c("Z1","Z2")]<-0 ;
# 
# ### Analysis with lm with survey year and the dummy variables z1 z2
# 
# 
# AnalysisHArvest.Plot.T2<-lm(MEAN_DRY.Mg.Ha.Year ~ Z1 + Z2 + ( F.HARVEST.YEAR * F.VARIETY * MEAN_PLANT.DENSITY.pl.ha) , data=Paper.data.Plots);
# 
# 
# summary(AnalysisHArvest.Plot.T2)
# 
# anova(AnalysisHArvest.Plot.T2, test="F")
# 
# T2<-tidy(anova(AnalysisHArvest.Plot.T2, test="F"))
# 
# T2.coeff<-tidy(AnalysisHArvest.Plot.T2)
# 
# 

#####Analysis using only the population density of the 2016 survey which is an random effect factor

AnalysisHArvest.Plot.T2<-lme(MEAN_DRY.Mg.Ha.Year ~  MEAN_PLANT.DENSITY.pl.ha + (F.HARVEST.YEAR * F.VARIETY) + MEAN_PLANT.DENSITY.pl.ha * F.VARIETY, data=Paper.data.Plots[Paper.data.Plots$F.SURVEY.YEAR == '2016',], random = ~ MEAN_PLANT.DENSITY.pl.ha | F.VARIETY);

summary(AnalysisHArvest.Plot.T2)

anova(AnalysisHArvest.Plot.T2)

T2<-anova(AnalysisHArvest.Plot.T2)

T2.coeff<-tidy(AnalysisHArvest.Plot.T2)

###############################################################################################################
#                           Print the data in an excel workbook Tables.xlsx
###############################################################################################################
## Set excel table formatting parameters and create workbook

HeadersStyle<-createStyle(fontName="Times New Roman",fontSize = 12, halign = "CENTER", textDecoration = "bold", border = "Bottom", fontColour = "black") ;

CellStyle<-createStyle(fontName="Times New Roman",fontSize = 12, halign = "CENTER", fontColour='black') ;




Willow.Harvest.Tables.wb<-createWorkbook() ;



#### Table_S1

addWorksheet(Willow.Harvest.Tables.wb, sheetName='Table_S1') ;


writeData(Willow.Harvest.Tables.wb, sheet='Table_S1',x= TS1, headerStyle = HeadersStyle) ;

addStyle(Willow.Harvest.Tables.wb, sheet='Table_S1', style=CellStyle, rows=seq(2,dim(TS1)[1]+2), cols=seq(1,dim(TS1)[2]), gridExpand = TRUE );

writeData(Willow.Harvest.Tables.wb, sheet='Table_S1',x= TS1.coeff, startRow= dim(TS1)[1]+10) ;



#### Table_1

addWorksheet(Willow.Harvest.Tables.wb, sheetName='Table_1') ;

writeData(Willow.Harvest.Tables.wb, sheet='Table_1',x= T1 , headerStyle = HeadersStyle)  ;

addStyle(Willow.Harvest.Tables.wb, sheet='Table_1', style=CellStyle, rows=seq(2,dim(T1)[1]+2), cols=seq(1,dim(T1)[2]), gridExpand = TRUE ) ;

writeData(Willow.Harvest.Tables.wb, sheet='Table_1',x= T1.coeff, startRow= dim(T1)[1]+10) ;


#### Table_2

addWorksheet(Willow.Harvest.Tables.wb, sheetName='Table_2') ;

writeData(Willow.Harvest.Tables.wb, sheet='Table_2',x= T2, headerStyle = HeadersStyle, rowNames = T) ;

addStyle(Willow.Harvest.Tables.wb, sheet='Table_2', style=CellStyle, rows=seq(2,dim(T2)[1]+2), cols=seq(1,dim(T2)[2]), gridExpand = TRUE ) ;

writeData(Willow.Harvest.Tables.wb, sheet='Table_2',x= T2.coeff, startRow= dim(T2)[1]+10) ;




saveWorkbook(Willow.Harvest.Tables.wb, file=paste0('../Agronomy Journal/Tables', '.xlsx'), overwrite = T ) ;

# saveWorkbook(Willow.Harvest.Tables.wb, file=paste0('../Tables', format(Sys.time(),"%Y_%m_%d_%H_%M"), '.xlsx'), overwrite = F ) ;


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


###############################################################################################################
#                           Analysis using mixed effects and repeated measure using the nlme package
#
#   Edmondson, Rodney, Hans-Peter Piepho, and Muhammad Yaseen. 2019. AgriTutorial: Tutorial Analysis of Some Agricultural Experiments (version 0.1.5).
#    https://CRAN.R-project.org/package=agriTutorial.
#
#   Piepho, H. P., and R. N. Edmondson. 2018. "A Tutorial on the Statistical Analysis of Factorial Experiments with Qualitative and Quantitative Treatment Factor Levels." 
#   Journal of Agronomy and Crop Science 204 (5): 429-55. https://doi.org/10.1111/jac.12267.
#    
###############################################################################################################

#  str(Paper.data.Plots) ; View(Paper.data.Plots) ;


AnalysisHArvest.Plot<-nlme::gls(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * F.BLOCK * F.VARIETY  , data=Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]); ### Overfitted


#AnalysisHArvest.Plot.gls<-nlme::gls(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * (F.BLOCK + F.VARIETY)  , corr=corExp(form=~ TIMETOHARVEST|F.BLOCK, nugget=T),
#                                    data=Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]);

AnalysisHArvest.Plot.gls<-nlme::gls(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * (F.BLOCK + F.VARIETY),
                                    data=Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]);


AnalysisHArvest.Plot.gls<-nlme::gls(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * F.VARIETY  , data=Paper.data.Plots[which(Paper.data.Plots$F.SURVEY.YEAR==2014),]);




AnalysisHArvest.Plot.gls<-nlme::gls(MEAN_DRY.Mg.Ha.Year ~ F.HARVEST.YEAR * (F.BLOCK + F.VARIETY + (F.SURVEY.YEAR *MEAN_PLANT.DENSITY.pl.ha) ) , data=Paper.data.Plots);

summary(AnalysisHArvest.Plot.gls)

anova(AnalysisHArvest.Plot.gls, test="F")

nlme::Variogram(AnalysisHArvest.Plot.gls)

plot(AnalysisHArvest.Plot)




###############################################################################################################
#                           Statistical Analysis using row as experimental unit
###############################################################################################################

#  View(Paper.data.V2) ; str(Paper.data.V2) 


##### Use length as weight for the statistical analysis

hist(Paper.data$Length.m)

diff(range(Paper.data$Length.m) )

median(Paper.data$Length.m)

sum(scale(Paper.data$Length.m,center=F,scale=T))/length(Paper.data$Length.m) 


Paper.data.V2$W.Length.m<-scale(Paper.data.V2$Length.m,center=F,scale=T) ;

Paper.data.V2$F.ROW<-as.factor(Paper.data.V2$ROW)


###############################################################################################################
#                           Analysis using lm 
###############################################################################################################


AnalysisHarvest.Rows.lm <-lm(DRY.Mg.Ha ~ W.Length.m * F.VARIETY * F.HARVEST.YEAR , data=Paper.data.V2[which(Paper.data.V2$F.SURVEY.YEAR==2013),])

summary(AnalysisHarvest.Rows.lm)

anova(AnalysisHarvest.Rows.lm)

plot(AnalysisHarvest.Rows.lm)



AnalysisHarvest.Rows.lm<-lm(DRY.Mg.Ha ~ W.Length.m * F.VARIETY * F.HARVEST.YEAR  + (F.SURVEY.YEAR * PLANT.DENSITY.pl.ha)*W.Length.m , data=Paper.data.V2)

summary(AnalysisHarvest.Rows.lm)

anova(AnalysisHarvest.Rows.lm)

plot(AnalysisHarvest.Rows.lm)




###############################################################################################################
#                           Analysis using mixed effects and repeated measure using the nlme package
#
#   Edmondson, Rodney, Hans-Peter Piepho, and Muhammad Yaseen. 2019. AgriTutorial: Tutorial Analysis of Some Agricultural Experiments (version 0.1.5).
#    https://CRAN.R-project.org/package=agriTutorial.
#
#   Piepho, H. P., and R. N. Edmondson. 2018. "A Tutorial on the Statistical Analysis of Factorial Experiments with Qualitative and Quantitative Treatment Factor Levels." 
#   Journal of Agronomy and Crop Science 204 (5): 429-55. https://doi.org/10.1111/jac.12267.
#    
###############################################################################################################


AnalysisHarvest.Rows<-nlme::gls(DRY.Mg.Ha ~ W.Length.m * F.VARIETY * F.HARVEST.YEAR , data=Paper.data.V2[which(Paper.data.V2$F.SURVEY.YEAR==2013),])

summary(AnalysisHarvest.Rows)

anova(AnalysisHarvest.Rows)

nlme::Variogram(AnalysisHarvest.Rows)

plot(AnalysisHarvest.Rows)



AnalysisHarvest.Rows<-nlme::gls(DRY.Mg.Ha ~ W.Length.m * F.VARIETY * F.HARVEST.YEAR  + (F.SURVEY.YEAR * PLANT.DENSITY.pl.ha)*W.Length.m , data=Paper.data.V2)


#[which(Paper.data.V2$F.SURVEY.YEAR==2013),])

summary(AnalysisHarvest.Rows)

anova(AnalysisHarvest.Rows)

nlme::Variogram(AnalysisHarvest.Rows)

plot(AnalysisHarvest.Rows)


###############################################################################################################
#                           Plots analysis by rows
###############################################################################################################

bwplot(Length.m ~ VARIETY | F.BLOCK  , data=Paper.data )
 
bwplot(DRY.Mg.Ha.Year.2015 ~ VARIETY | F.BLOCK  , data=Paper.data ) 

bwplot(DRY.Mg.Ha.Year.2015 ~ VARIETY , data=Paper.data ) 

bwplot(DRY.Mg.Ha.Year.2019 ~ VARIETY | F.BLOCK  , data=Paper.data ) 


plot(Freq ~ Var1, data=data.frame(table(Paper.data$F.VARIETY,Paper.data$F.BLOCK)), ylab="Number of Rows", xlab="VARIETY")

View(Paper.data)
