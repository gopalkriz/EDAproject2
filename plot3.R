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
#Q3. Instructions: [use ggplot2 plotting system]
```
#Make subset for factor Baltimore City (ie. fips == "24510") of all variables
BaltCityNEI <- subset (NEI, fips == "24510")
#Below two lines are used for preliminery undestanding of the dataset
#nrow(BaltCity);ncol(BaltCity); class(BaltCity); names(BaltCity)
#table(BaltCity$type, BaltCity$year); summary(BaltCity)
#Sum the Emission by Year and Type(source)
BCemissiontype <- aggregate(Emissions ~ year + type, BaltCityNEI, sum)
#Below two lines are used for preliminery undestanding of the dataset
#nrow(BCemissiontype);ncol(BCemissiontype); class(BCemissiontype); names(BCemissiontype)
#table(BCemissiontype$type, BCemissiontype$year); summary(BCemissiontype)
```
#Preparing the Graphical Plot
#plots to default graphic device / monitor
plot3 <-  ggplot(BCemissiontype,
                 aes(year, Emissions, color = type)) +
  geom_line() +
  ggtitle("Emission by Type of PM2.5 by Annual Year in Baltimore City")
plot3 #plot on scree for visual
#Open graphic device to png; create the plot; close the connection
png('plot3.png')
plot3 
dev.off(); getwd()# file is in working directory
```
#Understanding and Analysis of the plot
#Q3.Type-wise Emission for Baltimore City, Maryland ( fips == "24510" ) from 1999 to 2008?
#
#A3.Point type has seen increase in emission over the period 1999 to 2008
#Non-Road, Non-Point, On-Road types have seen decrease in emission over the period 1999 to 2008
#Point source have seen an increase in emission over the period 1999 to 2008
#the rate and magnitude of change has variation for each Type as visible from the plot 
###