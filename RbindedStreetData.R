library(sparklyr)
library(dplyr)
library(ggplot2)
library(readxl)
sc <- spark_connect(master = "spark://HOST:PORT")
connection_is_open(sc)
#importing street data
X2017_12 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-12.xlsx")
X2017_11 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-11.xlsx")
X2017_10 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-10.xlsx")
X2017_09 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-09.xlsx")
X2017_08 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-08.xlsx")
X2017_07 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-07.xlsx")
X2017_06 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-06.xlsx")
X2017_05 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-05.xlsx")
X2017_04 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-04.xlsx")
X2017_03 <- read_excel("C:/Users/M1291/Desktop/ADMP/StreetData/2017-03.xlsx")


StreetData <- (X2020_01)
View(StreetData)
#binding the rest of 2017 Datasets to StreetData

StreetData <- rbind(StreetData,X2017_03)
StreetData <- rbind(StreetData,X2017_04)
StreetData <- rbind(StreetData,X2017_05)
StreetData <- rbind(StreetData,X2017_06)
StreetData <- rbind(StreetData,X2017_07)
StreetData <- rbind(StreetData,X2017_08)
StreetData <- rbind(StreetData,X2017_09)
StreetData <- rbind(StreetData,X2017_10)
StreetData <- rbind(StreetData,X2017_11)
StreetData <- rbind(StreetData,X2017_12)

View(StreetData)
#what class is street data
class(StreetData)

#what are the dimensions
dim(StreetData)

#names of columns
names(StreetData)

#understand internal structure
str (StreetData)

#in a tidy (dplyr) format
glimpse (StreetData)

#summary of each column
summary (StreetData)

#changing column names
names(StreetData)[11]<- "AreaName"
#Dateformat
StreetData$Month <-as.Date(StreetData$Month, origin = "1899-12-30")

#identify N/A's with completed cases function
complete.cases(StreetData)
