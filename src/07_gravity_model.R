###
### So Young Park
### SODA 501
### Final Project
###
### Created 4/10/18 for gravity model analysis
### 

library(readr)
library(stringr)
library(tidyverse)
library(stringr)
library(xtable)
library(splitstackshape)
library(gravity)

#first load population and income data
#population
population <- read_csv("Box Sync/2018 Spring/SoDA 501/FinalProject/population2016.csv")
head(population) # population is city level 2015 Estimate value
#unlike our Twitter edgelist data, the State names are not abbreviated. Let's change it.
colnames(population)[1] <- "city"
colnames(population)[2] <- "name"
colnames(population)[3] <- "population"

abbrev <- read_csv("Box Sync/2018 Spring/SoDA 501/FinalProject/state_abbrev.csv")
head(abbrev)
population <- full_join(population, abbrev, by = "name") #merge
population$name <- NULL
head(population)
population$city <- str_sub(population$city, 1, str_length(population$city)-5) #remove " city", " town"
population <- population[-c(1),] #remove Alabama

#income
income <- read_csv("Box Sync/2018 Spring/SoDA 501/FinalProject/medianhouseholdincome.csv")
head(income) 
income[, 1:3] <- NULL
colnames(income)[1] <- "county"
colnames(income)[2] <- "income"
#income is county level 2015 median household income. 
#seperate county and state
income <- cSplit(income, "county", "(") #divide into two columns
income$county_2 <- str_sub(income$county_2, 1, str_length(income$county_2)-1) #remove ")"
colnames(income)[2] <- "county"
colnames(income)[3] <- "state"
income$county <- str_sub(income$county, 1, str_length(income$county)-7) #remove " county"
income <- income[-c(1,2),] #remove Alabama and US
#need to match city and county to add income.
city2county <- read_csv("Box Sync/2018 Spring/SoDA 501/FinalProject/zip_codes_states.csv")
head(city2county)
income <- full_join(income, city2county, by = c("county" , "state"), all=TRUE) #merge
head(income) 

#merge income and population
incomePop <- full_join(income, population, by = c("city" , "state"))
head(incomePop)
#Match with edgelist
load("~/Box Sync/2018 Spring/SoDA 501/FinalProject/agg_elist.RData")
edges <- agg_elist
edges <- cSplit(edges, "origin", ",")
edges <- cSplit(edges, "dest", ",")
head(edges)

colnames(edges)[1] <- "volume"
colnames(edges)[2] <- "distance"
colnames(edges)[3] <- "originC"
colnames(edges)[4] <- "stateC"
colnames(edges)[5] <- "destinC"
colnames(edges)[6] <- "stateD"

regressionData <- merge(incomePop, edges, by.x = c("city", "state"),
                        by.y = c("originC", "stateC"), all=TRUE)
regressionData1 <- filter(regressionData, volume!="NA")
regressionData1[,4:7] <- NULL 
colnames(regressionData1)[1] <- "originC"
colnames(regressionData1)[2] <- "stateO"
colnames(regressionData1)[3] <- "incomeO"
colnames(regressionData1)[4] <- "populationO"
regressionData1 <- select(regressionData1, originC, stateO, incomeO, populationO, destinC, stateD)
head(regressionData1)

#add destination information
regressionData2 <- merge(incomePop, regressionData1, by.x = c("city", "state"), 
                         by.y = c("destinC", "stateD"), all=TRUE)
head(regressionData2)
regressionData3 <- filter(regressionData2, originC!="NA")
regressionData3[,4:7] <- NULL 
colnames(regressionData3)[1] <- "destinC"
colnames(regressionData3)[2] <- "stateD"
colnames(regressionData3)[3] <- "incomeD"
colnames(regressionData3)[4] <- "populationD"

regressionData3 <- filter(regressionData3, incomeD!="NA")
head(regressionData3)

#merge with origin data
regressionData4 <- filter(regressionData, volume!="NA")
colnames(regressionData4)[1] <- "originC"
regressionData4[,2:8] <- NULL
regressionData4[,5] <- NULL
head(regressionData4)
head(regressionData3)

regData3 <- distinct(regressionData3)
regData4 <- distinct(regressionData4)

regressionData <- full_join(regData3, regData4, by=c("destinC", "originC"))
regressionData <- filter(regressionData, volume!="NA")
head(regressionData)
glimpse(regressionData) #oops income has $ sign and commas

regressionData$incomeO2 = gsub("\\$|,", "", regressionData$incomeO)
regressionData$incomeD2 = gsub("\\$|,", "", regressionData$incomeD)

regressionData$incomeO <- as.numeric(regressionData$incomeO2)
regressionData$incomeD <- as.numeric(regressionData$incomeD2)

regressionData$incomeO2 <- NULL
regressionData$incomeD2 <- NULL
glimpse(regressionData)

#gravity model
regressionData$lincomeO <- log(regressionData$incomeO) #income and population need to be in the log form
regressionData$lincomeD <- log(regressionData$incomeD)
regressionData$lpopulationO <- log(regressionData$populationO)
regressionData$lpopulationD <- log(regressionData$populationD)

#PPML estimates gravity models in their multiplicative form via Poisson Pseudo Maximum Likelihood.
fit <- PPML(y="volume", dist="distance", x=c("lpopulationO","lpopulationD","lincomeO","lincomeD"),
            vce_robust=TRUE, data=regressionData)
#okay to NA
sum(is.na(regressionData$lpopulationO))
sum(is.na(regressionData$lincomeO))
sum(is.na(regressionData$lpopulationD))
sum(is.na(regressionData$lincomeD))

#how are we gonna solve the NA...
options(digits=4)
summary(fit) # display results
exp(coef(fit))
table <- xtable(fit)

print.xtable(table, type = "html", file = "table1.html", digits = 4)
regressionData$predict <- predict(fit)