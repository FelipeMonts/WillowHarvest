##############################################################################################################
# 
# 
#       Program to produce soil profiles for the Willow harvest paper
#       Felipe Montes 2020 /06 /12
#    
# 
############################################################################################################### 



###############################################################################################################
#                             Tell the program where the package libraries are stored                        
###############################################################################################################


#  Tell the program where the package libraries are  #####################

.libPaths("C:/Felipe/SotwareANDCoding/R_Library/library")  ;


###############################################################################################################
#                             Setting up working directory                        
###############################################################################################################


#      set the working directory

readClipboard()

setwd("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\WillowHarvest") ;   # 



###############################################################################################################
#                            Install the packages that are needed                       
###############################################################################################################


# Install the packages that are needed #

# install.packages('remotes', dep=TRUE)

# install.packages('ggplot2', dep=TRUE)
# install.packages('base64enc' , dep=TRUE)
# install.packages("raster", dep = TRUE)
# install.packages('plyr', dep=TRUE)
# install.packages('Hmisc', dep=TRUE)
# install.packages('soilDB', dep=TRUE) # stable version from CRAN + dependencies
# install.packages("soilDB", repos="http://R-Forge.R-project.org") # most recent copy from r-forge
# install.packages("SSOAP", repos = "http://www.omegahat.org/R", type="source") # SSOAP and XMLSchema




# install.packages("foreign")
# install.packages("httr", dep=TRUE)
# install.packages("rgdal", dep = TRUE)

# install.packages("rgeos", dep = TRUE)
# install.packages("RColorBrewer")
# install.packages("latticeExtra")
# install.packages("reshape")
# install.packages("dplyr", dep=TRUE)
# install.packages("aqp", dep=TRUE)
# install.packages("maps", dep=TRUE)
# install.packages("png", dep=TRUE)
# install.packages("tmap", dep=TRUE)

# remotes::install_github('ncss-tech/aqp', dependencies = FALSE, force=T)
# remotes::install_github('ncss-tech/soilDB', dependencies = FALSE, force=T)

###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################


# load libraries
library(remotes) ;
library(Hmisc) ;
library(plyr) ;
library(dplyr)  ;
library(soilDB) ;
library(raster) ;
library(aqp) ;
library(sp) ;
library(rgdal) ; 
library(rgeos) ; 
library(lattice) ;
library(MASS) ;
library(RColorBrewer) ;
library(ggplot2)  ;
#library(tmap) ;
library(tidyr)  ;
library(devtools) ;
library(stats)
library(DescTools);
library(openxlsx)
library(tmap)

# ########################## import the Shape file with the GSSURGO Data for RockView ####################
# 
# readClipboard() 

RockViewSoils.info<-ogrInfo("..\\WillowHarvestGIS\\SoilsSSURGO.shp") ;


RockViewSoils<-readOGR("..\\WillowHarvestGIS\\SoilsSSURGO.shp") ;


# ##### The File above contains all the mukeys in the GSSURGO raster data enclosed by the RockView boundaries. Thi


aggregate(formula=Shape_Area ~ MUKEY, data=RockViewSoils@data, FUN="sum")

# The Most are is covered by MUKEY's  1= 538283  and 2= 538284

MUKEYS<-c(538283,538284) ;


################################ Query the Soil Data access database with SQL through R #################


# from https://sdmdataaccess.sc.egov.usda.gov/queryhelp.aspx
# and https://sdmdataaccess.sc.egov.usda.gov/documents/ReturningSoilTextureRelatedAttributes.pdf


# --Sample query begins.
# --Note that a pair of dashes denotes the beginning of a comment. 
# SELECT
# saversion, saverest, -- attributes from table "sacatalog"
# l.areasymbol, l.areaname, l.lkey, -- attributes from table "legend"
# musym, muname, museq, mu.mukey, -- attributes from table "mapunit"
# comppct_r, compname, localphase, slope_r, c.cokey, -- attributes from table "component"
# hzdept_r, hzdepb_r, ch.chkey, -- attributes from table "chorizon"
# sandtotal_r, silttotal_r, claytotal_r, --total sand, silt and clay fractions from table "chorizon"
# sandvc_r, sandco_r, sandmed_r, sandfine_r, sandvf_r,--sand sub-fractions from table "chorizon"
# texdesc, texture, stratextsflag, chtgrp.rvindicator, -- attributes from table "chtexturegrp"
# texcl, lieutex, -- attributes from table "chtexture"
# texmod -- attributes from table "chtexturemod"
# FROM sacatalog sac
# INNER JOIN legend l ON l.areasymbol = sac.areasymbol AND l.areatypename = 'Non-MLRA Soil Survey Area'
# INNER JOIN mapunit mu ON mu.lkey = l.lkey
# AND mu.mukey IN
# ('107559','107646','107674','107682','107707','107794','107853','107854','107865','107867','107869','107870','107871')
# LEFT OUTER JOIN component c ON c.mukey = mu.mukey
# LEFT OUTER JOIN chorizon ch ON ch.cokey = c.cokey
# LEFT OUTER JOIN chtexturegrp chtgrp ON chtgrp.chkey = ch.chkey
# LEFT OUTER JOIN chtexture cht ON cht.chtgkey = chtgrp.chtgkey
# LEFT OUTER JOIN chtexturemod chtmod ON chtmod.chtkey = cht.chtkey
# --WHERE.
# --ORDER BY l.areaname, museq, comppct_r DESC, compname, hzdept_r -- standard soil report ordering
# --Sample query ends. 

# extract the map unit keys from the RAT, and format for use in an SQL IN-statement
#in.statement2 <- format_SQL_in_statement(MUKEYS$ID); 

in.statement2 <- format_SQL_in_statement(MUKEYS); 

# The above is teh same as the two instructions below combined 
# Temp_1 <- paste(MUKEYS, collapse="','") ;
# Temp_2<- paste("('", Temp_1 , "')", sep='') ;



# format query in SQL- raw data are returned

Pedon.query<- paste0("SELECT component.mukey, component.cokey, component.compname, component.taxorder, component.taxsuborder, component.taxgrtgroup, component.taxsubgrp, comppct_r, majcompflag, slope_r, hzdept_r, hzdepb_r,hzthk_r, hzname, awc_r, sandtotal_r, silttotal_r, claytotal_r, om_r,dbtenthbar_r, dbthirdbar_r, dbfifteenbar_r, fraggt10_r, frag3to10_r, sieveno10_r, sieveno40_r, sieveno200_r, ksat_r  FROM component JOIN chorizon ON component.cokey = chorizon.cokey AND mukey IN ", in.statement2," ORDER BY mukey, comppct_r DESC, hzdept_r ASC") ;

# now get component and horizon-level data for these map unit keys
Pedon.info<- SDA_query(Pedon.query);
head(Pedon.info) ;
str(Pedon.info)  ;



# filter components that are the major components of each unit map with the Flag majcompflag=='Yes'

Pedon.info.MajorC<-Pedon.info[which(Pedon.info$majcompflag == 'Yes'),]  ;
head(Pedon.info.MajorC) ; 
str(Pedon.info.MajorC)  ;

# Both MUKEY's have dominant component Hagerstown Alfisols      Udalfs  Hapludalfs Typic Hapludalfs

Mukey.Pedon<-Pedon.info.MajorC[Pedon.info.MajorC$mukey == 538283, ] ;

#  Transform the Pedon.info query in to the right format to be converted into a SoilProfileCollection object
#   https://ncss-tech.github.io/AQP/aqp/aqp-intro.html


#Pedon.info$id<-Pedon.info$mukey ;
# Pedon.info$top<-Pedon.info$hzdept_r ;
# Pedon.info$bottom<-Pedon.info$hzdept_r ;
#Pedon.info$name<-Pedon.info$hzname ;

depths(Mukey.Pedon)<-mukey ~ hzdept_r + hzdepb_r  ;
Mukey.Pedon@horizons    ;


plot(Mukey.Pedon, name='hzname',color='dbthirdbar_r')  ;


explainPlotSPC(Mukey.Pedon, name='name')

#    Get the Color from the Pedon Description at    https://ncsslabdatamart.sc.egov.usda.gov/querypage.aspx  

Pedons.Info<-read.xlsx("..\\Soils\\PedonColor.xlsx", sheet="Color")

str(Pedons.Info)
Pedons.Info$hue<-sapply(strsplit(Pedons.Info$Main_Color,split=" "),'[', 1) ;

Pedons.Info$value<-sapply(strsplit(sapply(strsplit(Pedons.Info$Main_Color,split=" "),'[', 2), split="/"),'[', 1) ;

Pedons.Info$chroma<-sapply(strsplit(sapply(strsplit(Pedons.Info$Main_Color,split=" "),'[', 2), split="/"),'[', 2) ;

Pedons.Info$RGBColor<-munsell2rgb(the_hue = Pedons.Info$hue, the_value = Pedons.Info$value , the_chroma = Pedons.Info$chroma) ;

#  Transform the Pedon.info query in to the right format to be converted into a SoilProfileCollection object
#   https://ncss-tech.github.io/AQP/aqp/aqp-intro.html

depths(Pedons.Info)<-pedon_key~hzn_top + hzn_bot ;

plot(Pedons.Info, name='hzn_desgn', color='RGBColor')

View(Pedons.Info@horizons)


### The pedon that is more representative of the Rock view site is  04N0805. This is the one that is going to be used in the figure for the paper

Pedon.04N0805<-Pedons.Info[1] ; 

str(Pedon.04N0805@horizons)

Pedon.04N0805.horizons<-Pedon.04N0805@horizons ;

Pedon.04N0805.PSD<-read.csv("..\\Soils\\Pedon04N0805\\PSDA_and_Rock_Fragments.csv", header = T) ;

Pedon.04N0805.Organic<-read.csv("..\\Soils\\Pedon04N0805\\Carbon_and_Extractions.csv", header = T) ;

Pedon.04N0805.BD<-read.csv("..\\Soils\\Pedon04N0805\\Bulk_Density_and_Moisture.csv", header = T) ;

Pedon.04N0805.pH<-read.csv("..\\Soils\\Pedon04N0805\\pH_and_Carbonates.csv", header = T) ;

      
Pedon.04N0805.Other<-data.frame(Pedon.04N0805.PSD [, c("layer_key","Clay_3A1a1a_Sjj_39_SSL_0_0" , "Silt_d.1_S" , "Sand_d.1_S" , "wp25_d.1_S" , "wp520_d.1_S" , "wp2075_d.1_S" , "wp0175_d.1_S" , "wpG2_d.1_S")],  Pedon.04N0805.Organic[, c(14,18)],Pedon.04N0805.BD[,c("Db13b_3B1b_Caj_0_SSL_0_0")], Pedon.04N0805.pH[ , c( "pHh2o_4C1a2a1_Sjj_73_SSL_0_0")] )  ;

Pedon.04N0805@horizons<-merge(Pedon.04N0805.horizons,Pedon.04N0805.Other, by="layer_key", all.x=T) ;

str(Pedon.04N0805)

explainPlotSPC(Pedon.04N0805, name='hzn_desgn', color='RGBColor')

plotSPC(Pedon.04N0805, name='hzn_desgn', name.style = 'left-center', color='RGBColor', width=0.1, cex.depth.axis = 1.5, print.id = F, plot.depth.axis=F)
addVolumeFraction(Pedon.04N0805, colname='wp25_d.1_S', cex.min = 0.1, cex.max=0.1)
addVolumeFraction(Pedon.04N0805, colname='wp0175_d.1_S', cex.min = 0.2, cex.max=0.5)
addVolumeFraction(Pedon.04N0805, colname='wpG2_d.1_S', cex.min = 1, cex.max=2)

explainPlotSPC(Pedon.04N0805, name='hzn_desgn', color='RGBColor')

######################################################################################################################################################################



# Emailed Andrew Brown USDA-NRCS Soil and plant divisions Sonora CA for help with the individual soil profile
# https://github.com/brownag 
# Brown, Andrew.G - NRCS, Sonora, CA <andrew.g.brown@usda.gov>
# Andrew Brown
# Soil Scientist
# Phone: 209-591-5186
# E-mail: andrew.g.brown@usda.gov


# 1. this one just uses arguments to plotSPC -- but the axis still has the default orientation...
#  plotSPC(your.spc, name.style = "left-center", axis.line.offset = -20, width = 0.1)

# 2. this one rebuilds the axis custom to switch the side the tick marks are on
# 
# plotSPC(your.spc, name.style = "left-center", plot.depth.axis = FALSE, width = 0.1)
# 
# depth_axis_intervals <- pretty(seq(from=0, to=max(your.spc), by=1), n=5)
# 
# depth_axis_labels <- paste(depth_axis_intervals, "cm")
# 
# axis(side=2, las=2, line = -10, at=depth_axis_intervals,
#      
#      labels = depth_axis_labels,
#      
#      cex.axis=0.5,
#      
#      col.axis=par('fg'))


######################################################################################################################################################################



#### Arrange the data for the profile properties plotting

Pedon.04N0805.1<-Pedon.04N0805@horizons[,c("layer_key", "hzID", 'hzn_top', 'hzn_bot', 'hzn_desgn', 'Clay_3A1a1a_Sjj_39_SSL_0_0' , 'Silt_d.1_S' , 'Sand_d.1_S' , 'Ctot_4H2a_Sjf_8_SSL_0_0' , 'Ntot_4H2a_Sjf_8_SSL_0_0', 'Pedon.04N0805.BD...c..Db13b_3B1b_Caj_0_SSL_0_0...' , 'Pedon.04N0805.pH...c..pHh2o_4C1a2a1_Sjj_73_SSL_0_0...' )] ;

Pedon.04N0805.2<-reshape(data=Pedon.04N0805.1, varying=list(names(Pedon.04N0805.1)[6:12]) , direction= 'long', idvar=c('layer_key', 'hzn_desgn', 'hzID', 'hzn_top', 'hzn_bot'), v.names='Values',times=c("Clay %", "Silt %","Sand %" ,"T. Carbon %" , "T. Nitrogen %","B. Density*",  "pH"))


Pedon.04N0805@horizons$hzname<-Pedon.04N0805@horizons$hzn_desgn ;

Pedon.04N0805@site$pedon_key<-c("HAGERSTOWN  ")


postscript(file="..\\Agronomy Journal\\Figure2Soil.eps" , onefile=F, width=8, height=2, paper= "letter")

par(mar=c(4.1,5,2,1),xpd=NA)

layout(matrix(c(1, rep(0,7)), 1,8, byrow=T))


 plotSPC(Pedon.04N0805, name='hzn_desgn', name.style = 'left-center', color='RGBColor', width=0.4, print.id = F, plot.depth.axis=F,y.offset=0, cex.names= 1.0 ,relative.pos = c(1.75), id.style = "top")
 
 depth_axis_intervals <- c(0,20,40,60,80,100,120) #pretty(seq(from=0, to=max(Pedon.04N0805@horizons$hzn_bot), by=1), n=5)
 
 depth_axis_labels <- depth_axis_intervals 
 
 axis(side=2, las=2, line = 0.5, at=depth_axis_intervals,
      
      labels = depth_axis_labels,
      
      cex.axis=1.2,
      
      col.axis=par('fg'))
 mtext("Depth cm", side = 2, line = 3.5)
 
 
 # addVolumeFraction(Pedon.04N0805, colname='wp25_d.1_S', cex.min = 0.1, cex.max=0.1)
 # addVolumeFraction(Pedon.04N0805, colname='wp0175_d.1_S', cex.min = 0.2, cex.max=0.5)
 # addVolumeFraction(Pedon.04N0805, colname='wpG2_d.1_S', cex.min = 1, cex.max=2)

 Plot.2<-xyplot(hzn_top ~ Values | time, data=Pedon.04N0805.2, index.cond=list(c(2,5,4,1,6,7,3)), ylim=c(130,-2), ylab=NULL,ylab.right="Depth cm", strip=strip.custom(bg=grey(0.8),par.strip.text=list(cex=0.8)), par.strip.text=list(cex=0.8),layout=c(7,1), type="b", grid=T, col.line="BLACK", col.symbol="BLACK", bg="BLACK" ,lwd=2,scales=list(x=list(tick.number=4, alternating=3, relation="free", cex=0.8), y=list(draw=T,relation="same", alternating=2)))


print(Plot.2, position=c(0.125,0,1,1),more=T)


invisible(dev.off())



#### Add the data from the soil samplesa and the laboratory analysis taken from the field and available in the file C:\Felipe\Willow_Project\Willow_Experiments\Willow_Rockview\WillowHarvestPaper\Agronomy Journal\JournalResponse20201117\RockViewSoilSamples24396 Report_FM.xlsx

#  readClipboard()

RockView.Soildata.2012_1<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Soil Data\\Soil Sampling 20121016\\FN 24396 Report_FM.xlsx", sheet=1, startRow = 16, colNames = T ); 

#    str(RockView.Soildata.2012) ; View(RockView.Soildata.2012)


RockView.Soildata.2012<-RockView.Soildata.2012_1[3:10,] ;

#  str(RockView.Soildata.2012)

RockView.Soildata.2012<-lapply(RockView.Soildata.2012[,2:15], as.numeric) ;

names(RockView.Soildata.2012)<-paste(names(RockView.Soildata.2012_1), RockView.Soildata.2012_1[1,],RockView.Soildata.2012_1[2,],sep = "_")[2:15]

#  str(RockView.Soildata.2012)

RockView.Soildata.2012.avg<-lapply(RockView.Soildata.2012, mean) ;
RockView.Soildata.2012.rng<-lapply(RockView.Soildata.2012, range) ;

RockView.Soildata.2013<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Soil Data\\NO3 Sampling 20131115\\RockViewNO3SoilSampling20131112.xlsx", sheet=2, startRow = 1, colNames = T ) ;


#   str(RockView.Soildata.2013) ; View(RockView.Soildata.2013)

RockView.Soildata.2013.avg<-mean(RockView.Soildata.2013$`Nitrate-N.ppm`) ;
RockView.Soildata.2013.rng<-range(RockView.Soildata.2013$`Nitrate-N.ppm`) ;

RockView.Soildata.2014<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Soil Data\\NO3 Sampling 20140501\\RockViewNO3SoilSampling20140501.xlsx", sheet=2, startRow = 1, colNames = T ) ;


#   str(RockView.Soildata.2014) ; View(RockView.Soildata.2014)

RockView.Soildata.2014.avg<-mean(RockView.Soildata.2014$`Nitrate-N.ppm`) ;
RockView.Soildata.2014.rng<-range(RockView.Soildata.2014$`Nitrate-N.ppm`) ;

RockView.Soildata.2015<-read.xlsx("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowRockViewData\\Soil Data\\NO3 Sampling 20151010\\RockViewNO3SoilSampling201510.xlsx", sheet=2, startRow = 1, colNames = T ) ;


#   str(RockView.Soildata.2015) ; View(RockView.Soildata.2015)

RockView.Soildata.2015.avg<-mean(RockView.Soildata.2015$`Nitrate-N.ppm`) ;
RockView.Soildata.2015.rng<-range(RockView.Soildata.2015$`Nitrate-N.ppm`) ;


barplot(c(unlist(RockView.Soildata.2015.avg),unlist(RockView.Soildata.2015.rng), unlist(RockView.Soildata.2014.avg), unlist(RockView.Soildata.2014.rng), unlist(RockView.Soildata.2013.avg), unlist(RockView.Soildata.2013.rng),unlist(RockView.Soildata.2012.avg$`NO3_NA_mg/Kg`), unlist(RockView.Soildata.2012.rng$`NO3_NA_mg/Kg`)),names.arg= c(rep(2015,3),rep(2014,3), rep(2013,3), rep(2012,3)))

barplot(c(unlist(RockView.Soildata.2012.avg$`Organic_matter_%`), unlist(RockView.Soildata.2012.rng$`Organic_matter_%`)),names.arg= rep(2012,3))

#### Update Pedon.04N0805 with the soil sampling data 


#  str(Pedon.04N0805.2); View(Pedon.04N0805.2);

Pedon.04N0805.2.Soil.Update<-Pedon.04N0805.2;

# The total carbon data for the 0-40 cm layers is updated with the range of Loss of Ignition range from the 2012 soil analysis 


Pedon.04N0805.2.Soil.Update[which(Pedon.04N0805.2.Soil.Update$time == 'T. Carbon %'),c('Values')][c(1,2)]<-unlist(RockView.Soildata.2012.rng$`Organic_matter_%`)[c(2,1)] ;



# The Total nitrogen for the 0-40 cm layers is updated with the median of all the Nitrate measurements taken troughout the experiment in Between 2012 and 2015 

Soil.NO3.data<-c(unlist(RockView.Soildata.2012$`NO3_NA_mg/Kg`), unlist(RockView.Soildata.2013$`Nitrate-N.ppm`), unlist(RockView.Soildata.2014$`Nitrate-N.ppm`),unlist(RockView.Soildata.2015$`Nitrate-N.ppm`))

plot(Soil.NO3.data)

median(Soil.NO3.data)
abline(h=median(Soil.NO3.data), col='RED')


Pedon.04N0805.2.Soil.Update[which(Pedon.04N0805.2.Soil.Update$time == 'T. Nitrogen %'),c('Values')]

Plot.2.Updated<-xyplot(hzn_top ~ Values | time, data=Pedon.04N0805.2, index.cond=list(c(2,5,4,1,6,7,3)), ylim=c(130,-2), ylab=NULL,ylab.right="Depth cm", strip=strip.custom(bg=grey(0.8),par.strip.text=list(cex=0.8)), par.strip.text=list(cex=0.8),layout=c(7,1), type="b", grid=T, col.line="BLACK", col.symbol="BLACK", bg="BLACK" ,lwd=2,scales=list(x=list(tick.number=4, alternating=3, relation="free", cex=0.8), y=list(draw=T,relation="same", alternating=2)))
