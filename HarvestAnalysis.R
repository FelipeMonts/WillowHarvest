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



###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################

library(randomForest)

library(RColorBrewer)

library(openxlsx)

library(lattice)

library(devtools)

library(forestFloor)

library(rgl)

library(raster)

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
Plant.Survey.2013<-mask(raster(Plants.2013.Tps.sp.V1)*50,Boundary.Polygon);

plot(Plant.Survey.2013, col=terrain.colors(10, rev=T), axes=F, box=F, legend=F, main="Plant Population Survey 2013");

contour(Plant.Survey.2013, add=T) ;

plot(Plant.Survey.2013, legend.only=T, horizontal =T); 



Plant.Survey.2014<-mask(raster(Plants.2014.Tps.sp.V1)*50,Boundary.Polygon);

plot(Plant.Survey.2014, col=terrain.colors(10, rev=T), axes=F, box=F, legend=F, main="Plant Population Survey 2014") ;

contour(Plant.Survey.2014, add=T) ;

plot(Plant.Survey.2014, legend.only=T, horizontal =T)


Plant.survey.2106


#############################  Statistical Analysis #############################################



####  Create the apropriate factors ####


Paper.data$F.VARIETY<-as.factor(Paper.data$VARIETY)  ;
levels(Paper.data$F.VARIETY ) ;



Paper.data$BLOCK<-1 ; 

Paper.data$BLOCK[59:132]<-2 ;  


Paper.data$F.BLOCK<-as.factor(Paper.data$BLOCK) ;

str(Paper.data)


### reshape the data to create two factors Harvest.Year, and Survey.Year


Paper.data.I1<-reshape(Paper.data, drop=c("Plant.Density.pl.ha.2013" , "Plant.Density.pl.ha.2014", "Plant.Density.pl.ha.2016"),varying=list(c("FRESH.LB.2015", "FRESH.LB.2019"), c("MOISTURE.2015", "MOISTURE.2019")) , v.names=c("FRESH.LB","MOISTURE"),idvar="ROW", times=c(2015,2019), timevar = "HARVEST_YEAR", direction="long" ); 

#  View(Paper.data.I1) ; str(Paper.data.I1) ; names(Paper.data.I1)

Paper.data.I2<-reshape(Paper.data.I2, varying=list(c("Plants2013" , "Plants2014" , "Plants2016")) , v.names=c("PLANT.SURVEY"), times=c(2013,2014,2016), timevar = "SURVEY.YEAR", direction="long");

#  View(Paper.data.I2) ; str(Paper.data.I2) ; names(Paper.data.I2)

Paper.data.V2<-as.data.frame(Paper.data.I2, row.names=seq(1,dim(Paper.data.I2)[1])) ;


###  Calculating row yield in Dry mater in kg/ha 

Paper.data$DRY.Mg.2015<-Paper.data$FRESH.LB.2015*(1-Paper.data$MOISTURE.2015)/ 2.204623 / 1000 ;# 2.204623 lb/kg  1000 kg/Mg

Paper.data$DRY.Mg.Ha.2015<-Paper.data$DRY.Mg.2015/Paper.data$Area.m2*10000  ;

Paper.data$DRY.Mg.Ha.Year.2015<-Paper.data$DRY.Mg.Ha.2015/3 ;

Paper.data$DRY.Mg.2019<-Paper.data$FRESH.LB.2019*(1-Paper.data$MOISTURE.2019)/ 2.204623 / 1000  ; # 2.204623 lb/kg  1000 kg/Mg

Paper.data$DRY.Mg.Ha.2019<-Paper.data$DRY.Mg.2019/Paper.data$Area.m2*10000  ;

Paper.data$DRY.Mg.Ha.Year.2019<-Paper.data$DRY.Mg.Ha.2019/3 ;



#******************** Change made 5/21/20 Yield of last two rows of Fabius (DRY.Mg.Ha.2015, DRY.Mg.Ha.2019) were averaged using the geometric mean . The border row had higher yield, and shadowed the row. That fixed matters. 


View(Paper.data)

Paper.data[seq(128,132),] 

Paper.data.Last2Rows.DRY.Mg.Ha<-Paper.data[c(131,132), c('DRY.Mg.Ha.2015','DRY.Mg.Ha.2019' )] 

Paper.data.Last2Rows.DRY.Mg.Ha.GeoMean<-sapply(Paper.data.Last2Rows.DRY.Mg.Ha, function(x)  exp(mean(log(x)))) ;

Paper.data[131, c('DRY.Mg.Ha.2015','DRY.Mg.Ha.2019' )]<-Paper.data.Last2Rows.DRY.Mg.Ha.GeoMean ;

Paper.data[132, c('DRY.Mg.Ha.2015','DRY.Mg.Ha.2019' )]<-Paper.data.Last2Rows.DRY.Mg.Ha.GeoMean ;

Paper.data[c(131,132), c('DRY.Mg.Ha.Year.2015','DRY.Mg.Ha.Year.2019' )]<-Paper.data[c(131,132),c('DRY.Mg.Ha.2015','DRY.Mg.Ha.2019' )]/3 ;

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


#  View(Paper.data) ; str(Paper.data) 

######### Aggregating the data according to the average (mean) of F.VARIETY and F.BLOCK groupings  ####################


Paper.data.Plots.mean<-aggregate(formula= cbind(DRY.Mg.Ha.Year.2015, MOISTURE.2015, DRY.Mg.Ha.Year.2019, MOISTURE.2019, Plant.Density.pl.ha.2013, Plant.Density.pl.ha.2014, Plant.Density.pl.ha.2016 ,Area.m2 , Length.m ) ~ F.VARIETY + F.BLOCK, FUN=mean,data=Paper.data) ;

names(Paper.data.Plots.mean)[3:11]<-paste0("MEAN_",c("DRY.Mg.Ha.Year.2015" , "MOISTURE.2015" ,  "DRY.Mg.Ha.Year.2019" ,  "MOISTURE.2019" , "Plant.Density.pl.ha.2013" , "Plant.Density.pl.ha.2014" , "Plant.Density.pl.ha.2016", "Area.m2" , "Length.m")) ;

#  View(Paper.data.Plots.mean)

###############################################################################################################
#                           Print the data in a new sheet in the excel workbook WillowHarvestDataAnalysis.xlsx
###############################################################################################################

addWorksheet(Willow.Harvest.wb, sheetName = 'Plot_Data')  ;

writeDataTable(Willow.Harvest.wb, sheet='Plot_Data', x=Paper.data.Plots.mean ) ;

saveWorkbook(Willow.Harvest.wb, file=paste0('../WillowHarvestDataAnalysis',format(Sys.time(),"%Y_%m_%d_%H_%M"), '.xlsx'), overwrite = F ) ;



###############################################################################################################
#                           Analysis using lm 
###############################################################################################################

#   str(Paper.data.Plots.mean) ;View(Paper.data.Plots.mean)

AnalysisHArvest2015.Plot<-lm(MEAN_DRY.Mg.Ha.Year.2015 ~ F.BLOCK + F.VARIETY +  MEAN_Plant.Density.pl.ha.2013 +  MEAN_Plant.Density.pl.ha.2014, data=Paper.data.Plots.mean);

AnalysisHArvest2015.Plot<-lm(MEAN_DRY.Mg.Ha.Year.2015 ~ F.BLOCK + F.VARIETY * MEAN_Plant.Density.pl.ha.2014, data=Paper.data.Plots.mean);

anova(AnalysisHArvest2015.Plot, test="F")
summary(AnalysisHArvest2015.Plot)
plot(AnalysisHArvest2015.Plot)
effects(AnalysisHArvest2015.Plot)

AnalysisHArvest2019.Plot<-lm(MEAN_DRY.Mg.Ha.Year.2019 ~ F.BLOCK + F.VARIETY +  MEAN_Plant.Density.pl.ha.2013 +  MEAN_Plant.Density.pl.ha.2014 + MEAN_Plant.Density.pl.ha.2016, data=Paper.data.Plots.mean);

anova(AnalysisHArvest2019.Plot,test = "F")
summary(AnalysisHArvest2019.Plot)
effects(AnalysisHArvest2019.Plot)
plot(AnalysisHArvest2019.Plot)

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
#                           Statistical Analysis using row as experimental unit
###############################################################################################################

#  View(Paper.data) ; str(Paper.data) 



AnalysisHArvest2015.Row<-lm(DRY.Mg.Ha.Year.2015  ~ F.BLOCK + F.VARIETY + Plant.Density.pl.ha.2013 +  Plant.Density.pl.ha.2014 + Plant.Density.pl.ha.2016, data=Paper.data[1:131,], );

AnalysisHArvest2015.RowV2<-lm(DRY.Mg.Ha.Year.2015  ~ F.BLOCK + F.VARIETY * Plant.Density.pl.ha.2014, data=Paper.data[1:131,], );

summary(AnalysisHArvest2015.RowV2)

anova(AnalysisHArvest2015.RowV2, test= "F")

plot(AnalysisHArvest2015.Row)


AnalysisHArvest2019.Row<-lm(DRY.Mg.Ha.Year.2019 ~ F.BLOCK + F.VARIETY +  Plant.Density.pl.ha.2013  +   Plant.Density.pl.ha.2014 + Plant.Density.pl.ha.2016, data=Paper.data[1:131,])

AnalysisHArvest2019.RowV2<-lm(DRY.Mg.Ha.Year.2019 ~ F.BLOCK + F.VARIETY * Plant.Density.pl.ha.2016, data=Paper.data[1:131,])

summary(AnalysisHArvest2019.RowV2)

anova(AnalysisHArvest2019.RowV2, test= "F")

plot(AnalysisHArvest2019.Row)


###############################################################################################################
#                           Plots analysis by rows
###############################################################################################################

bwplot(Length.m ~ VARIETY | F.BLOCK  , data=Paper.data )
 
bwplot(DRY.Mg.Ha.Year.2015 ~ VARIETY | F.BLOCK  , data=Paper.data ) 

bwplot(DRY.Mg.Ha.Year.2015 ~ VARIETY , data=Paper.data ) 

bwplot(DRY.Mg.Ha.Year.2019 ~ VARIETY | F.BLOCK  , data=Paper.data ) 


plot(Freq ~ Var1, data=data.frame(table(Paper.data$F.VARIETY,Paper.data$F.BLOCK)), ylab="Number of Rows", xlab="VARIETY")

View(Paper.data)
