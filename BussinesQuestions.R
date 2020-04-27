library(sparklyr)
library(dplyr)
spark_install()
sc <- spark_connect(master = "local")

spark_web(sc)

#library to allow spark to do filtering and calculations
library(DBI)
library(tidyr)
library(tidyverse)
library(mosaic)


#Preparing Data for spark instances
Street<-StreetFinal
Street<- copy_to(sc, Street, "Street")

SAS <- StopSearchFinal
SAS<- copy_to(sc, SAS, "SAS")



#Question1

#creating dimension tables
DimTime <-  distinct(Street,Year,Month)
DimTime < copy_to(sc, DimTime, "DimTime")
 
DimLocation <- distinct(Street,County)
DimLocation <- copy_to(sc, DimLocation, "DimLocation")

DimCrime <- distinct(Street,Crime_Type)
DimCrime <- copy_to(sc, DimCrime, "DimCrime")

#creating fact table
FctTotalOfCrime <- tally(Street$Crime_Type~Street$County&Street$Year&Street$Month, data = Street, margins = T, 
                              format = "count")
View(FctTotalOfCrime)

FctTotalOfCrime <- as.data.frame(FctTotalOfCrime,responseName = "freq")

#ordering columns
FctTotalOfCrime <- FctTotalOfCrime[,c(2,3,4,1,5)]

view(FctTotalOfCrime)

#changing column name
colnames(FctTotalOfCrime)[05] <- "TotalNumberOfCrime"
view(FctTotalOfCrime)

FctTotalOfCrime <- copy_to(sc, FctTotalOfCrime, "FctTotalOfCrime")

#Question2

#creating dimension tables
DimLegislation <- distinct(SAS,Legislation)
DimLegislation <- copy_to(sc, DimLegislation, "DimLegislation")

DimObjectFound <-distinct(SAS,Outcome_of_search_found)
DimObjectFound <- copy_to(sc, DimObjectFound, "DimObjectFound")

#creating fact table
FctTotalNumberOfObjectFound <- tally(SAS$Outcome_of_search_found~SAS$County&SAS$Year&SAS$Month&SAS$Legislation, 
                         data = SAS, margins = T, format = "count")
View(FctTotalNumberOfObjectFound)

FctTotalNumberOfObjectFound <- as.data.frame(FctTotalNumberOfObjectFound,responseName = "freq")

#ordering columns
FctTotalNumberOfObjectFound <- FctTotalNumberOfObjectFound[,c(2,3,4,5,1,6)]

view(FctTotalNumberOfObjectFound)

#changing column name
colnames(FctTotalNumberOfObjectFound)[06] <- "TotalNumberOfObjetFound"
view(FctTotalNumberOfObjectFound)

FctTotalNumberOfObjectFound <- copy_to(sc, FctTotalNumberOfObjectFound, "FctTotalNumberOfObjectFound")

#Question3

#creating dimension tables
DimOutcomeOfSearch <- distinct(SAS,Outcome_of_search)
DimOutcomeOfSearch <- copy_to(sc, DimOutcomeOfSearch, "DimOutcomeOfSearch")

DimAgeRange <- distinct(SAS,Age_Range)
DimAgeRange <- copy_to(sc, DimAgeRange, "DimAgeRange")

DimObjectOfSearch <- distinct(SAS, Object_of_search)
DimObjectOfSearch <- copy_to(sc, DimObjectOfSearch, "DimObjectOfSearch")

#creating fact table
FctTotalNumberOfCrimePerAgeRange <- tally(SAS$Age_Range~SAS$County&SAS$Year&SAS$Month&SAS$Object_of_search&SAS$Outcome_of_search, 
                                    data = SAS, margins = T, format = "count")
View(FctTotalNumberOfCrimePerAgeRange)

FctTotalNumberOfCrimePerAgeRange <- as.data.frame(FctTotalNumberOfCrimePerAgeRange,responseName = "freq")

#ordering columns
FctTotalNumberOfCrimePerAgeRange <- FctTotalNumberOfCrimePerAgeRange[,c(2,3,4,5,6,1,7)]

view(FctTotalNumberOfCrimePerAgeRange)

#changing column name
colnames(FctTotalNumberOfCrimePerAgeRange)[07] <- "TotalNumberOfCrimePerAgeRange"
view(FctTotalNumberOfCrimePerAgeRange)
FctTotalNumberOfCrimePerAgeRange <- copy_to(sc, FctTotalNumberOfCrimePerAgeRange, "FctTotalNumberOfCrimePerAgeRange")

#Question4

#creating dimension tables
DimGender <- distinct(SAS, Gender)
DimGender <- copy_to(sc, DimGender, "DimGender")

#creating fact table
FctTotalNumberOfCrimePerGender <- tally(SAS$Gender~SAS$County&SAS$Year&SAS$Month&SAS$Object_of_search&SAS$Age_Range, 
                                        data = SAS, margins = T, format = "count")
View(FctTotalNumberOfCrimePerGender)

FctTotalNumberOfCrimePerGender <- as.data.frame(FctTotalNumberOfCrimePerGender, responseName = "freq")


#ordering columns
FctTotalNumberOfCrimePerGender <- FctTotalNumberOfCrimePerGender[,c(2,3,4,5,6,1,7)]

view(FctTotalNumberOfCrimePerGender)

#changing column name
colnames(FctTotalNumberOfCrimePerGender)[07] <- "TotalNumberOfCrimePerGender"
view(FctTotalNumberOfCrimePerGender)
FctTotalNumberOfCrimePerGender <- copy_to(sc, FctTotalNumberOfCrimePerGender, "FctTotalNumberOfCrimePerGender")

#Question5

Street1 <- Street[Street$Crime_Type=="Drugs",]
view(Street1)

#creating dimension tables
DimPlaces <-  distinct(Street1,Longitude,Latitude,Location,LSOA_Name)
DimPlaces <- copy_to(sc, DimPlaces, "DimPlaces")

#creating fact table

FctTotalOfCrimePerLocation <- tally(Street1$Location~Street1$County&Street1$Year&Street1$Month, 
                                     data = Street1, margins = T, format = "count")
View(FctTotalOfCrimePerLocation)

FctTotalOfCrimePerLocation <- as.data.frame(FctTotalOfCrimePerLocation, responseName = "freq")

#ordering columns

FctTotalOfCrimePerLocation <- FctTotalOfCrimePerLocation[,c(2,3,4,1,5)]
view(FctTotalOfCrimePerLocation)


#changing column name
 
colnames(FctTotalOfCrimePerLocation)[05] <- "TotalNumberOfCrimePerLocation"
view(FctTotalOfCrimePerLocation)

FctTotalOfCrimePerLocation <- copy_to(sc, FctTotalOfCrimePerLocation, "FctTotalOfCrimePerLocation")






