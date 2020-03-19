# Felipe Montes
# Program to match Willow row plant census data to GPS track coordinates
# V :2013-05-02

#set working Directory

#setwd("C:/Users/frm10/Desktop/Willow Census R")

setwd("G:/Willow Census R")

#read plant data from the excell CVS file

Plant.data<-read.csv('Data_Plants2.csv',header=T,as.is=T,colClasses=c('numeric','character'))

#convert time and date to appropriate format for manipulation

Plant.data$Date_time<-as.POSIXct(strptime(Plant.data$Time.Stamp,format='%m/%d/%Y %H:%M:%S'))

# Select only necesary columns
Plant<-Plant.data[,c('Date_time','No.plants..Rows.')]

#read data from the GPS file

GPS.data<-read.csv('Current Track_ 03 MAY 2013 09_15.csv',skip=42,header=T,as.is=T)

#convert time and date to appropriate format for manipulation

GPS.data$Date<-substr(GPS.data$time,1,10)

#the date in the GPS data appears to be 4 hours later that what it appears in local time, probably due to Universal time setting
#therefore needs to be changed by 4 hours

Hours<-as.numeric(substr(GPS.data$time,12,13))-4
Min.sec<-substr(GPS.data$time,14,19)

#the format for time has to be '00' hours, therefore hours needs to be corrected

Hours.c<-substr(as.character(Hours+1000),3,4)

Time.c<-paste(Hours.c,Min.sec,sep='')

#Corrected Date and time put together 

GPS.data$Date_time<-as.POSIXct(strptime(paste(GPS.data$Date,Time.c),format='%Y-%m-%d %H:%M:%S'),tz='')

#Select only necesary columns
GPS<-GPS.data[,c('Date_time','lat','lon')]

Census<-merge(GPS,Plant,by='Date_time',all=T)
Census.o<-Census[,order(c('Date_time','lat','lon','No.plants..Rows.'))]

# create a variable to update the No.Plants.rows variable
Census.o$Plants[1]<-'a'

# Set the fist value of the No.plants..Rows. to a recognizable value 'a'
#Census.o$No.plants..Rows.[1]<-'a'

#in this census, the first value of No.plants..Rows. is '1' a legitimate value therefore it is not changed
Census.o$No.plants..Rows.[1]<-Census.o$Plants[1]<-1

  for (i in 2:dim(Census.o)[1]) {
      if (is.na(Census.o$No.plants..Rows.[i]))  Census.o$Plants[i]<-Census.o$Plants[i-1]
      else  Census.o$Plants[i]<-Census.o$No.plants..Rows.[i] 
  }

#extract only points in the GPS.data data frame to match the gps points in the map

Final.data<-Census.o[match(GPS.data$Date_time,Census.o$Date_time ),]


#Export the data to added to the GPS file
 write.csv(Final.data,file='Final.data_part2.csv')