#
#Coursera #Exploratory Data Analysis # Project2 # date 20July2015
#Project Description: view ReamMe.rd file
#About: Ambient Air Pollution / Fine particulate matter (PM2.5)
#Database (USA): National Emissions Inventory (NEI) from Environmental Protection Agency (EPA)
#Data URL in single zipfile Data for Peer Assessment [29Mb]
#
#Rerefence Assistance:
#https://rpubs.com/geekgirl72/24156
#https://github.com/TomLous/coursera-exploratory-data-analysis-course-project-2
#https://github.com/shahabedinh/Exploratory-Data-Analysis--Project-2
#https://github.com/wayneeseguin/exdata-project2
#
##Stage0
#Preparatory Steps
#Operating System and Environment Specs
#WindowsXP Pentium4 2.8GHz Ram2GB
#R version 3.2.0 Platform: i386-w64-mingw32/i386 (32-bit)
#Rstudio Version 0.99.442
```
ls(); getwd(); dir()
setwd("C:/Documents and Settings/Divekar/R workspace"); dir()
library(base)
library(utils)
library(stats)
library(httr)
library(graphics)
library(grDevices)


library(plyr); library(dplyr)
library(tidyr)
library(lattice)
library(grid)
library(ggplot2)
```
##Stage1
#Download the dataset; unzip the file; review the contents
#URL: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
```
if(!file.exists("./NEI_EDAproject")) {
  dir.create("./NEI_EDAproject")
}else {cat("Directory exist")}

if(!exists(fileURL) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
}else {cat("fileURL already exist in R environment")}

if(!file.exists("./NEI_EDAproject/NEIdataset.zip")){
  download.file(fileURL, destfile= "./NEI_EDAproject/NEIdataset.zip")
}else {cat("NEIdataset.zip exist in folder./NEI_EDAproject")} # Windows not needed to use method="curl"

#Unzip the folder and files
if(!file.exists("./NEI_EDAproject/Source_Classification_Code.rds")){
  unzip(zipfile="./NEI_EDAproject/NEIdataset.zip",exdir="./NEI_EDAproject")
}else {cat("Source_Classification_Code.rds exist in folder./NEI_EDAproject")}

if(!file.exists("./NEI_EDAproject/summarySCC_PM25.rds")){
  unzip(zipfile="./NEI_EDAproject/NEIdataset.zip",exdir="./NEI_EDAproject")
}else {cat("summarySCC_PM25.rds exist in folder./NEI_EDAproject")}


#
#Verification of datafiles being available in the required folder
#PM2.5 Emissions Data:                summarySCC_PM25.rds
#Source Classification Code Table:    Source_Classification_Code.rds
```
list.files(file.path("./NEI_EDAproject"))
```
##Stage2
#Read the files to input the data
#for refernce: DataTable Size is  NEI 64976516obs 6variables.  SCC 11717obs 15variables.
```

#largesize files, will take time to download
NEI <- readRDS("./NEI_EDAproject/summarySCC_PM25.rds")
SCC <- readRDS("./NEI_EDAproject/Source_Classification_Code.rds")


```
##Stage3
#Explore the datastructure
```
nrow(NEI);ncol(NEI); class(NEI); names(NEI)
head(NEI, n=3); tail(NEI, n=3)
table(NEI$year, NEI$type) #takes much time to process
range(NEI$Emissions)
summary(NEI)
#
nrow(SCC);ncol(SCC); class(SCC);names(SCC)
head(SCC, n=3); tail(SCC, n=3)
table(SCC$Data.Category,SCC$SCC.Level.One) #takes much time to process
summary(SCC)
```
##Stage4
#Questions and Answers
#Q1. [use base plotting system]
#There is no need to make scatterplot of all points, so...
#Imp do not run: length(NEI$Pollutant);length(NEI$year); with(NEI, plot(Emissions,year))
#Sum the emission yearwise for given year. Do quick plots on the screen to find the best visual.
```
YearwiseSumEmission <- aggregate(Emissions ~ year, NEI, sum)
with(YearwiseSumEmission, pie(Emissions, labels = year))
with(YearwiseSumEmission, boxplot(Emissions ~ year))
with(YearwiseSumEmission, barplot(height=Emissions, names.arg=year))
plot(YearwiseSumEmission$year,YearwiseSumEmission$Emissions, type ='b')
#choosing the last line plot as it represents the change best                             

#Open grpahic device to png; create the plot; close the connection; file is in working directory
```
png('plot1.png')
plot(YearwiseSumEmission$year,YearwiseSumEmission$Emissions,
     type = 'b', pch = 16, lty = 1, lwd =   2, col = "magenta",
     xlab = "Year", ylab = "Emission in Tons",
     main = "Total Emission of PM2.5 by Annual Year in USA")
dev.off(); getwd()
```
#Understanding and Analysis of the plot
#Q1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#
#A1. Yes, there has been a decrease for the period mention.
###
#Q2. [use base plotting system]
#
#Make subset for factor Baltimore City (ie. fips == "24510") of all variables
```
BaltCity <- subset (NEI, fips == "24510")
BaltCityYearlyEmission <- aggregate(Emissions ~ year, BaltCity, sum)
```
#Do quick plots on the screen to find the best visual.
```
with(BaltCityYearlyEmission, pie(Emissions, labels = year))
with(BaltCityYearlyEmission, boxplot(Emissions ~ year))
barplot(height=BaltCityYearlyEmission$Emissions, names.arg=BaltCityYearlyEmission$year)
plot(BaltCityYearlyEmission$year,BaltCityYearlyEmission$Emissions, type ='b')
```
#Open graphic device to png; create the plot; close the connection; file is in working directory
```
png('plot2.png')
plot(BaltCityYearlyEmission$year,BaltCityYearlyEmission$Emissions,
     type = 'b', pch = 16, lty = 2, lwd =   1, col = "blue",
     xlab = "Year", ylab = "Emission in Tons",
     main = "Total Emission of PM2.5 by Annual Year in Baltimore City")
dev.off(); getwd()
```
#Understanding and Analysis of the plot
#Q2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland ( fips == "24510" ) from 1999 to 2008?
#
#A2. Yes, there has been a decrease for the period mention.
###
#Q3. [use ggplot2 plotting system]
#
#Make subset for factor Baltimore City (ie. fips == "24510") of all variables
```
BaltCity <- subset (NEI, fips == "24510")
#nrow(BaltCity);ncol(BaltCity); class(BaltCity); names(BaltCity)
#table(BaltCity$type, BaltCity$year); summary(BaltCity)
BCemissiontype <- aggregate(Emissions ~ year + type, BaltCity , sum)
#nrow(BCemissiontype);ncol(BCemissiontype); class(BCemissiontype); names(BCemissiontype)
#table(BCemissiontype$type, BCemissiontype$year); summary(BCemissiontype)
```
plot3 <-  ggplot(BCemissiontype,
                 aes(year, Emissions, color = type)) +
  geom_line() +
  ggtitle("Emission by Type of PM2.5 by Annual Year in Baltimore City")
plot3 #plot on scree for visual
png('plot3.png')
plot3
dev.off(); getwd()
```
#Understanding and Analysis of the plot
#Q3.Typewise Emission for Baltimore City, Maryland ( fips == "24510" ) from 1999 to 2008?
#
#A3.Point type has seen increase in emission over the period 1999 to 2008
#Non-Road, Non-Point, On-Road types have seen decrease in emission over the period 1999 to 2008
###
#Q4. [use any plotting system]
#
#Look in SCC datatable, for coal combustion-related sources; extract the corresponding rows.
#Match this output with NEI dataset, with SCC-column as Index
#Sum Emission Data by year and plot
```
```
##Method1: Does not work for me!
#NEISCC <- merge(NEI, SCC, "SCC") # Error: cannot allocate vector of size 64.0 Mb
#coalMatches  <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
#subsetNEISCC <- NEISCC[coalMatches, ]
```
##Method2:
cc <- grep("coal",SCC$EI.Sector,value=T,ignore.case=T)
SCCcoalcomb <- subset(SCC, EI.Sector %in% cc, select=SCC)
NEIcoalcomb <- subset(NEI, NEI$SCC %in% SCCcoalcomb$SCC)
NEIcoalYearType1 <- aggregate(Emissions ~ year + type, NEIcoalcomb , sum)
```
plot4b <-  ggplot(NEIcoalYearType1 , aes(year, Emissions/10^6, color = type))+
  geom_line()+
  stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", colour = "magenta", geom="line")+
  xlab("Year")+
  ylab("Emission in million Tons")+
  ggtitle("Total Annual Emission of PM2.5 from Coal Combustion in USA")
plot4b
png('plot4b.png')
plot4b
dev.off(); getwd()
```
##Method3: # includes some additional extracts word 'coal' mentioned in other columns of NEI 
```
SCCcoal <- subset(SCC, EI.Sector %in% c("Fuel Comb - Comm/Instutional - Coal", "Fuel Comb - Electric Generation - Coal", "Fuel Comb - Industrial Boilers, ICEs - Coal"))
SCCcoal1 <- subset(SCC, grepl("Comb", Short.Name) & grepl("Coal", Short.Name))
nrow(SCCcoal); nrow(SCCcoal1)
#dif1 <- setdiff(SCCcoal$SCC, SCCcoal1$SCC); length(dif1) # missing values between the datasets 
#dif2 <- setdiff(SCCcoal1$SCC, SCCcoal$SCC); length(dif2) # missing values between the datasets
finalCodes <- union(SCCcoal$SCC, SCCcoal1$SCC)
NEIcoal <- subset(NEI, SCC %in% finalCodes)
NEIcoalYearType <- aggregate(Emissions ~ year + type, NEIcoal , sum)
```
#
#Plotting the Coal-Combustion by Year for Total Emissions and by each Source Type
```
plot4a <-  ggplot(NEIcoalYearType, aes(year, Emissions/10^6, color = type))+
  geom_line()+
  stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", colour = "magenta", geom="line")+
  xlab("Year")+
  ylab("Emission in million Tons")+
  ggtitle("Total Annual Emission of PM2.5 from Coal Combustion in USA")
plot4a
png('plot4a.png')
plot4a
dev.off(); getwd()
```
#
#Understanding and Analysis of the plot
#Q4.Across United States, how have emissions from coal combustion-related sources changed from 1999-2008?
#
#A4.Yes there has been a Overall reduction in emissions over the period mentioned.Significant is a steep fall for 2005-2008+
#from Point sources. Also, Sources of non-Point emmissions have shown an increase and then a decreace+
#Point source quantity forms a large proportion of the total emission; contribution from non-pint is relatively much less.
```
###
#Q5. [Baltimore City, fips == "24510"]
#
#Find the heads for Motor Vehicles from SCC
```
VehicleHeads <- unique(grep("Vehicle", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
VehicleSource <- subset(SCC, EI.Sector %in% VehicleHeads, select=SCC)
```
#then extract data from NEI; filter for Baltimore 
NEIvehicle <- subset(NEI, NEI$SCC %in% VehicleSource$SCC)
NEIvehicleBC <- subset (NEIvehicle, fips == "24510")
```
#Summate Emission yearwise; and also by type, just for refernce as it is redundant
VhBCemmisionYear <- aggregate(Emissions ~ year + type, NEIvehicleBC, sum)
```
#Plot the chart; # legend has been removed as it is redundant
plot5 <-  ggplot(VhBCemmisionYear, aes(year, Emissions, color = type))+
  theme(legend.position="none")+
  geom_line()+
  xlab("Year")+
  ylab("Emission in Tons")+
  ggtitle("Total Annual Emission of PM2.5 from Vehicles in Baltimore")
plot5
png('plot5.png')
plot5
dev.off(); getwd()
#Understanding and Analysis of the plot
#Q5.How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
#
#A5.There is only On-Road type of emission from Motor vehicle, and nil from any other source type.+
#There is drastic fall from1999-2002 and then a lower rate of decrease continues
###
#Q6. [BaltimoreCity, fips == "24510" and LosAngelesCounty fips == "06037"]
#
#Find the heads for Motor Vehicles from SCC
```
VehicleHeads <- unique(grep("Vehicle", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
VehicleSource <- subset(SCC, EI.Sector %in% VehicleHeads, select=SCC)
```
#Extract data from NEI for Motor Vehicle pollutionfor USA
NEIvehicle <- subset(NEI, NEI$SCC %in% VehicleSource$SCC)
#filter for Baltimore;Summate Emission yearwise;
NEIvehicleBC <- subset (NEIvehicle, fips == "24510")
VhBCemissionYear <- aggregate(Emissions ~ year, NEIvehicleBC, sum)
VhBCemissionYear$Region <- "BaltimoreCity"
#filter for LosAngelesCounty;Summate Emission yearwise;
NEIvehicleLA <- subset (NEIvehicle, fips == "06037")
VhLAemissionYear <- aggregate(Emissions ~ year, NEIvehicleLA, sum)
VhLAemissionYear$Region <- "LosAngelesCounty"
```
#Combine the data from both Baltimire and LA.
BCLAvehicleEmissionYear <- rbind(VhBCemissionYear,VhLAemissionYear)
BCLAvehicleEmissionYear[,'Emissions'] = round(BCLAvehicleEmissionYear[,'Emissions'])
```
#Plot the chart; # legend has been removed as it is redundant
plot6 <-  ggplot(BCLAvehicleEmissionYear , aes(year, Emissions, color = Region))+
  geom_text(aes(label=Emissions,hjust=0.35, vjust=-0.1, size=8))+
  geom_line()+
  xlab("Year")+
  ylab("Emission in Tons")+
  ggtitle("Total Annual Emission of PM2.5 from Vehicles")
  
plot6


png('plot6.png')
plot6
dev.off(); getwd()

#Understanding and Analysis of the plot
#Q6.Compare emissions from motor vehicle sources in Baltimore City with emissions from +
#motor vehicle sources in Los Angeles County, California (fips == 06037).+
#Which city has seen greater changes over time in motor vehicle emissions?
#
#A6.The Emissions from LA are much higher (atleast8x) that Baltimore every year.
#The Emission for Baltimore has decreased over the period 1999-2008
#The Emission for LA has shown sharp increase 1999-2005, then sharply decreased for 2005-2008
#While LA has shown a large fluctuation of vehicle emissions, for 1999-2008 there is minimal absolute change
#Baltimore has seen a greater change in absolute and %proportion, for 1999-2008.
###
