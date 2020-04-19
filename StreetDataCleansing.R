library(tidyverse)
library(mosaic)
library(dplyr)
library(tidyr)

#Exploring row data
class(StreetData)
glimpse(StreetData)
summary(StreetData)

Street_Data <- StreetData

#looking for duplication
duplicate_Street_CrimeID <- Street_Data[duplicated(Street_Data[,1]),]
nrow(duplicate_Street_CrimeID)
view(duplicate_Street_CrimeID)

#finding Na values
TotalNaRows_S<- colSums(is.na(Street_Data))
TotalNaRows_S

#looking in our data
#removing the columns we dont need (outliers)
Street_Data <- Street_Data[ ,c(2,3,5,6,7,9,10)]
view(Street_Data)

#finding Na values
TotalNaRows_S<- colSums(is.na(Street_Data))
TotalNaRows_S

Street_Data.impute <- Street_Data

#replacing Na values from longitude, latitude, LSOA name
Street_Data.impute$Longitude[which(is.na(Street_Data.impute$Longitude))] <- 0
rep_long<- colSums(is.na(Street_Data.impute))
rep_long

Street_Data.impute$Latitude[which(is.na(Street_Data.impute$Latitude))] <- 0
rep_lat<- colSums(is.na(Street_Data.impute))
rep_lat

Street_Data.impute$`LSOA name`[which(is.na(Street_Data.impute$`LSOA name`))] <- "Unspecified"
rep_lsoa<- colSums(is.na(Street_Data.impute))
rep_lsoa

#enhansing and transforming data 

Street_Data.transform <- Street_Data.impute
#adding new column for county (location)
Street_Data.transform$County <- "South Yorkshire"

View(Street_Data.transform)

#split date into year and month column 
Street_Data.transform <- separate(Street_Data.transform, col = Month, into = c("Year","Month"), sep = "-")

View(Street_Data.transform)

#changing column names for data warehouse
colnames(Street_Data.transform)[07] <- "LSOA_Name"
colnames(Street_Data.transform)[08] <- "Crime_Type"

view(Street_Data.transform)

#cross validation
glimpse(Street_Data.transform)

#put columns in preffered order
StreetFinal <- Street_Data.transform[ , c(9,1,2,4,5,6,7,8)]

View(StreetFinal)



