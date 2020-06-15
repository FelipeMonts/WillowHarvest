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





###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################


# load libraries
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










