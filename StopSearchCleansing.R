library(tidyverse)
library(mosaic)
library(dplyr)
library(tidyr)

#Exploring row data
class(StopSearch)
glimpse(StopSearch)
summary(StopSearch)

#looking in our data
#removing the columns we dont need (outliers)
Stop_Search <- StopSearch[ ,-c(1,3,4,5,6,9,10,15)]
view(Stop_Search)

#finding Na values
TotalNaRows<- colSums(is.na(Stop_Search))
TotalNaRows

#replacing Na values from object of search
Stop_Search$`Object of search`[which(is.na(Stop_Search$`Object of search`))] <- "Unspecified"
rep_oos<- colSums(is.na(Stop_Search))
rep_oos

#replacing Na values from gender
Stop_Search$Gender[which(is.na(Stop_Search$Gender))] <- "Other"
rep_gender<- colSums(is.na(Stop_Search))
rep_gender

#replacing Na values from object of search
Stop_Search$Legislation[which(is.na(Stop_Search$Legislation))] <- "Unspecified"
rep_legis<- colSums(is.na(Stop_Search))
rep_legis


#imputing values in age range Na values
#finding age range distribution without Na
AgeRangePerc <- tally(na.omit(Stop_Search$`Age range`), data = Stop_Search,
                      margins = T, format = "perc")
AgeRangePerc

#assign Na row numbers
AgeNa <-  which(!complete.cases(Stop_Search$`Age range`))
#create new subset for imputing values
Stop_Search.impute <- Stop_Search
#calculated how many Na to assing to each range 
#assigning age range to Na cells
Stop_Search.impute[AgeNa[1:573],3]<- "10-17"
Stop_Search.impute[AgeNa[574:1444],3]<- "18-24"
Stop_Search.impute[AgeNa[1445:2161],3]<- "25-34"
Stop_Search.impute[AgeNa[2162:2850],3]<- "over 34"
Stop_Search.impute[AgeNa[2851:2853],3]<- "under 10"

rep_age<- colSums(is.na(Stop_Search.impute))
rep_age

#after imputing age range values
AgeRangePerc1 <- tally(na.omit(Stop_Search.impute$`Age range`), 
                       data = Stop_Search.impute,margins = T, format = "perc")
AgeRangePerc1

View(Stop_Search.impute)

#enhansing data 

#changing column names for data warehouse
colnames(Stop_Search.impute)[03] <- "Age_Range"
colnames(Stop_Search.impute)[05] <- "Object_of_search"
colnames(Stop_Search.impute)[06] <- "Outcome_of_search"
colnames(Stop_Search.impute)[07] <- "Outcome_of_search_found"


View(Stop_Search.impute)

#transformig data

Stop_Search.transform <- Stop_Search.impute
#adding county column
Stop_Search.transform$County <- "South Yorkshire"

View(Stop_Search.transform)

#split date into year and month column 
Stop_Search.transform$Year <- as.character.Date(Stop_Search.transform$Date,format = "%Y")
Stop_Search.transform$Month <- as.character.Date(format(Stop_Search.transform$Date,format = "%m"))
  
View(Stop_Search.transform)

#remove date column
Stop_Search.transform <- Stop_Search.transform[ , -1]

View(Stop_Search.transform)

#cross validation
glimpse(Stop_Search.transform)

#put columns in preffered order
StopSearchFinal <- Stop_Search.transform[ , c(8,9,7,1,2,3,4,5,6)]

View(StopSearchFinal)


