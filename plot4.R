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
#Q4. Instructions: [use any plotting system]
```
#Look in SCC datatable, for coal combustion-related sources; extract the corresponding rows.
#Match this output with NEI dataset, with SCC-column as Index
#Sum Emission Data by year and plot
```
#Search EI.Sector column for fields containing the word coal
#Note: search for Coal-Combustion sources is NOT made complex by further search in other columns
cc <- grep("coal",SCC$EI.Sector,value=T,ignore.case=T)
#Subset SCC database by row, for all the columns variables; for fields with coal
SCCcoalcomb <- subset(SCC, EI.Sector %in% cc, select=SCC)
#Note: SCC is a Data.table and also a Header Column name
#Note: SCC by column name is the identity variable that links the NEI and SCC databases
```
#Subset NEI by the the identification index, which results in all Coal related emissions
NEIcoalcomb <- subset(NEI, NEI$SCC %in% SCCcoalcomb$SCC)
#Sum the Emission by both Year and Type(source)
NEIcoalYearType <- aggregate(Emissions ~ year + type, NEIcoalcomb , sum)
```
#Preparing the Graphical Plot
#plots to default graphic device / monitor
plot4 <-  ggplot(NEIcoalYearType , aes(year, Emissions/10^6, color = type))+
  geom_line()+
  stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", colour = "black", aes(shape="total"), geom="line")+
  geom_line(aes(size="total", shape = NA))+
  xlab("Year")+
  ylab("Emission in million Tons")+
  ggtitle("Total Annual Emission of PM2.5 from Coal Combustion in USA")
plot4 #plot on screen for visual
#Open graphic device to png; create the plot; close the connection
png('plot4.png')
plot4
dev.off(); getwd()#file is in working directory
```
#Q4.Across United States, how have emissions from coal+
#combustion-related sources changed from 1999-2008?
#
#A4.Yes there has been a Overall reduction in emissions over the period mentioned.
#Significant is a steep fall for 2005-2008 #from Point sources.
#Also, Sources of non-Point emmissions have shown an increase and then a decreace.
#Point source quantity forms a large proportion of the total emission; contribution from non-pint is relatively much less.
###




#below lines are only for reference
#**********#

##Method2: # includes some additional extracts word 'coal' mentioned in other columns of NEI
```
SCCcoal2a <- subset(SCC, EI.Sector %in% c("Fuel Comb - Comm/Instutional - Coal", "Fuel Comb - Electric Generation - Coal", "Fuel Comb - Industrial Boilers, ICEs - Coal"))
SCCcoal2b <- subset(SCC, grepl("Comb", Short.Name) & grepl("Coal", Short.Name))
nrow(SCCcoal2a); nrow(SCCcoal2b)
#dif1 <- setdiff(SCCcoal2a$SCC, SCCcoal2b$SCC); length(dif1) # missing values between the datasets
#dif2 <- setdiff(SCCcoal2b$SCC, SCCcoal2a$SCC); length(dif2) # missing values between the datasets
finalCodes2 <- union(SCCcoal2a$SCC, SCCcoal2b$SCC)
NEIcoal2 <- subset(NEI, SCC %in% finalCodes2)
NEIcoalYearType2 <- aggregate(Emissions ~ year + type, NEIcoal2 , sum)
```
plot4a <-  ggplot(NEIcoalYearType, aes(year, Emissions/10^6, color = type))+
  geom_line()+
  stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", colour = "black", aes(shape="total"), geom="line")+
  geom_line(aes(size="total", shape = NA))+
  xlab("Year")+
  ylab("Emission in million Tons")+
  ggtitle("Total Annual Emission of PM2.5 from Coal Combustion in USA")
plot4a
```

#**********#


```
##Method3: Does not work for me!
#NEISCC <- merge(NEI, SCC, "SCC") # Error: cannot allocate vector of size 64.0 Mb
#coalMatches  <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
#subsetNEISCC <- NEISCC[coalMatches, ]
```

#**********#