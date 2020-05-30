
################################################################################################################
#                           Analysis using mixed effects and repeated measure using the nlme package
#
#   Edmondson, Rodney, Hans-Peter Piepho, and Muhammad Yaseen. 2019. AgriTutorial: Tutorial Analysis of Some Agricultural Experiments (version 0.1.5).
#    https://CRAN.R-project.org/package=agriTutorial.
#
#   Piepho, H. P., and R. N. Edmondson. 2018. "A Tutorial on the Statistical Analysis of Factorial Experiments with Qualitative and Quantitative Treatment Factor Levels." 
#   Journal of Agronomy and Crop Science 204 (5): 429-55. https://doi.org/10.1111/jac.12267.
#    
#   Package agriTutorial Felipe Montes 2020/5/29
# 
#    
# 
# 
#  Felipe Montes 2020/5/29
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

setwd("C:\\Felipe\\Willow_Project\\Willow_Experiments\\Willow_Rockview\\WillowHarvestPaper\\AgriTutorial") ;   # 



###############################################################################################################
#                            Install the packages that are needed                       
###############################################################################################################




# Install the packages that are needed #

# install.packages('minqa', dep=T)

# install.packages('agriTutorial', dep=T)

# install.packages('nlme', dep=T)

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

library(agriTutorial)

library(nlme)

library(RColorBrewer)

library(openxlsx)

library(lattice)

library(devtools)

# library(forestFloor)

# library(rgl)

library(raster)


###############################################################################################################
#
#          Example 4: One qualitative treatment factor with repeated measurements over time
#   
###############################################################################################################


#######  4.1 Section 1  #######



View(sorghum)

##  independent uncorrelated random plots

fm4.1 <- nlme::gls(y ~ factweek * (Replicate + variety), sorghum)
 
print(fm4.1)

fm4.1.ANOVA <- anova(fm4.1)


print(fm4.1.ANOVA)

#  fm4.1.glance <- broom::glance(fm4.1)    # same as summary but more elaborated to be tidy 

summary(fm4.1 )

fm4.1.Variogram <- nlme::Variogram(fm4.1)

plot(fm4.1.Variogram)



#######  4.2 Section 2  #######

## corCompSymm compound symmetry

fm4.2 <- nlme::gls(y ~ factweek * (Replicate + variety),  
                   corr = corCompSymm(form = ~ varweek|factplot), sorghum) ;


print(fm4.2)

summary(fm4.2)

plot(fm4.2)

fm4.2.ANOVA <- anova(fm4.2)  ;


print(fm4.2.ANOVA)

# fm4.2.glance <- broom::glance(fm4.2)  # same as summary but more elaborated to be tidy

fm4.2.Variogram <- nlme::Variogram(fm4.2)

plot(fm4.2.Variogram)

print(fm4.2.Variogram)



#######   4.3 Section 3   #####

## corExp without nugget
fm4.3 <- nlme::gls(y ~ factweek * (Replicate + variety),
                   corr = corExp(form = ~ varweek|factplot), sorghum) ;

print(fm4.3)

summary(fm4.3)

plot(fm4.3)


fm4.3.ANOVA <- anova(fm4.3) ;

print(fm4.3.ANOVA)

##  fm4.3.glance <- broom::glance(fm4.3)  # same as summary but more elaborated to be tidy

fm4.3.Variogram <- nlme::Variogram(fm4.3) ;

print(fm4.3.Variogram)

plot(fm4.3.Variogram)



#######   4.4 Section 4   #####


## corExp with nugget
fm4.4 <- nlme::gls(y ~ factweek * (Replicate + variety),
                   corr = corExp(form = ~ varweek|factplot, nugget = TRUE), sorghum) ;


print(fm4.4)

summary(fm4.4)

plot(fm4.4)

fm4.4.ANOVA <- anova(fm4.4) ;

print(fm4.4.ANOVA)


##   fm4.4.glance <- broom::glance(fm4.4)  # same as summary but more elaborated to be tidy


fm4.4.Variogram <- nlme::Variogram(fm4.4) ;

print(fm4.4.Variogram)

plot(fm4.4.Variogram)
