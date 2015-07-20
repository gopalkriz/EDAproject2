```
#Coursera #Exploratory Data Analysis # Project2 # date 20July2015
#About Project: view ReamMe.rd file for the entire Project  Description
#Overview: Graphical Analysis of Ambient Air Pollution / Fine particulate matter (PM2.5)
#Database (USA): National Emissions Inventory (NEI) from Environmental Protection Agency (EPA)
#Data URL in single zipfile Data for Peer Assessment [29Mb]
```
##Stage0
#Operating System and Environment Specs
#WindowsXP Pentium4 2.8GHz Ram2GB
#R version 3.2.0 Platform: i386-w64-mingw32/i386 (32-bit)
#Rstudio Version 0.99.442
```
#Preparatory step
ls(); getwd(); dir()
setwd("C:/Documents and Settings/Divekar/R workspace"); dir()
library(base)
library(utils)
library(stats)
library(httr)
library(graphics)
library(grDevices)
library(ggplot2)
```
##Stage1: getting the files
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
```
#Verification of datafiles being available in the required folder
list.files(file.path("./NEI_EDAproject"))
#PM2.5 Emissions Data:                summarySCC_PM25.rds
#Source Classification Code Table:    Source_Classification_Code.rds
```
##Stage2: getting data
#Read the files to input the data
#for refernce: DataTable Size is  NEI 64976516obs 6variables.  SCC 11717obs 15variables.
```
NEI <- readRDS("./NEI_EDAproject/summarySCC_PM25.rds") #largesize, will take time to download
SCC <- readRDS("./NEI_EDAproject/Source_Classification_Code.rds")
```
##Stage3: understanding the data structure
```
nrow(NEI);ncol(NEI); class(NEI); names(NEI)
head(NEI, n=3); tail(NEI, n=3)
#table(NEI$year, NEI$type) #takes much time to process
range(NEI$Emissions); summary(NEI)
#
nrow(SCC);ncol(SCC); class(SCC);names(SCC)
head(SCC, n=3); tail(SCC, n=3);summary(SCC)
#table(SCC$Data.Category,SCC$SCC.Level.One) #takes much time to process
```
##Stage4
#Q5.Instructions: [Baltimore City, fips == "24510"]
```
#Search EI.Sector column for fields containing the word Vehicle
VehicleHeads <- unique(grep("Vehicle", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
#Subset SCC database by row, for all the columns variables; for fields with vehicles
VehicleSource <- subset(SCC, EI.Sector %in% VehicleHeads, select=SCC)
#Note: SCC by column name is the identity variable that links the NEI and SCC databases
```
#Extract data from NEI for Motor Vehicle pollutionfor USA
NEIvehicle <- subset(NEI, NEI$SCC %in% VehicleSource$SCC)
#Filter the Vehicle related Emissions specifically for BaltimoreCity 
NEIvehicleBC <- subset (NEIvehicle, fips == "24510")
```
#Summate Emission yearwise; and also by type, just for refernce as it is redundant
VhBCemmisionYear <- aggregate(Emissions ~ year + type, NEIvehicleBC, sum)
```
#Preparing the Graphical Plot#plots to default graphic device / monitor
#Note: # legend has been removed as it is redundant
plot5 <-  ggplot(VhBCemmisionYear, aes(year, Emissions, color = type))+
  theme(legend.position="none")+
  geom_line()+
  xlab("Year")+
  ylab("Emission in Tons")+
  ggtitle("Total Annual Emission of PM2.5 from Vehicles in Baltimore")
plot5 #plot on scree for visual
#Open graphic device to png; create the plot; close the connection
png('plot5.png')
plot5
dev.off(); getwd() #file is in the working directory
```
#Q5.How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
#
#A5.There is only On-Road type of emission from Motor vehicle, and nil from any other source type.+
#There is drastic fall from1999-2002 and then a lower rate of decrease continues
###