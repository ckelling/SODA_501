###
### So Young Park
### SODA 501
### Final Project
###
### Created 4/10/18 for gravity model analysis
### 

#Still needs more work done!

library(readr)
library(stringr)
library(tidyverse)
library(stringr)
library(xtable)
library(splitstackshape)

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
colnames(edges)[4] <- "state"
colnames(edges)[5] <- "destinC"
colnames(edges)[6] <- "state"

regressionData <- full_join(incomePop, edges, by.x = "city", by.y = "originC", all=TRUE)
regressionData <- full_join(incomePop, edges, by.x = "city", by.y = "destinC", all=TRUE)

#gravity model
fit <- glm(n ~ distance+population+income, 
            data = regressionData, family = poisson(link = "log"))

options(digits=4)
summary(fit) # display results
exp(coef(fit))
table <- xtable(fit)

print.xtable(table, type = "html", file = "table1.html", digits = 4)
regressionData$predict <- predict(fit)