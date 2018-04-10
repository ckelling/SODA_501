###
### Claire Kelling
### SODA 501
### Final Project
###
### Created 4/9/18 for complication of edgelist
### 

library(ggmap)
library(XML)
library(geosphere)
library(geonames)
library(Imap)
library(googleway)
library(xtable)
library(dplyr)

source("~/Documents/GitHub/Travel_Patterns_SODA_501/src/00_geo_dist_function.R")
load("~/Box Sync/2018 Spring/SoDA 501/FinalProject/user_locations_finalcleaned.Rdata")
#I will use the subsetted data here
user_locations <- user_locations_c2


#
# Desired dataframe output: city 1, city 2, number of users, distance
#

towns<-c("Ithaca, NY", "State College, PA", "Bloomington, IN", "Lawrence,
         KS", "Blacksburg, VA", "College Station, TX", "Columbia, MO",
         "Champaign, IL", "Ann Arbor, MI", "Gainesville, FL")

#creating for loop to go through the dataset
edge_list <- NULL

for(j in 332:nrow(user_locations)){
  #j <- 2
  user_towns <- user_locations$locations[[j]]
  
  #remove NA's
  user_towns <- user_towns[!is.na(user_towns)]
  print(paste(j, "****************************************"))
  
  if(length(user_towns)>1){
    for(i in 1:(length(user_towns)-1)){
      #i <- 1
      new_edge <- c(user_towns[i], user_towns[i+1])
      edge_list <- rbind(edge_list, new_edge)
      print(i)
    }
  }
}

edge_list <- as.data.frame(edge_list)
rownames(edge_list) <- c()
colnames(edge_list) <- c("origin", "dest")

#aggregate it to get a count
agg_elist <- edge_list %>% group_by(origin, dest) %>% tally()
agg_elist <- as.data.frame(agg_elist)
agg_elist$origin <- as.character(agg_elist$origin)
agg_elist$dest <- as.character(agg_elist$dest)

#now, to find the location between the two cities
agg_elist$dist <- rep(NA,nrow(agg_elist))
key <- "AIzaSyBLGSr0BCTW2xhyAPwE123XE58eQup1Feg"

for(i in 1:nrow(agg_elist)){
  towns <- agg_elist[i,1:2]
  lonlat1 <- google_geocode(address = towns[1,1], key = key)
  lonlat1 <- lonlat1$results$geometry$location
  
  Sys.sleep(runif(1,1,3))
  
  lonlat2 <- google_geocode(address = towns[1,2], key = key)
  lonlat2 <- lonlat2$results$geometry$location
  
  lonlat3 <- rbind(lonlat1,lonlat2)
  
  names <- c(towns[1,1], towns[1,2])
  
  print(i)
    
  df.cities <- data.frame(name = names,
                            lat  = lonlat3$lat,
                            lon  = lonlat3$lng)
  
  dmat3 <- round(GeoDistanceInMetresMatrix(df.cities) / 1000)
  
  dist_vec <- dmat3[,1]
  dist <- dist_vec[2]
  
  agg_elist$dist[i] <- dist
  
}

#line 333, 358, 717, 995, 1018, 1273, 1305, 1355, 1366, 1406, 1554, 1572, 1573, 1823 had HTTP error 500. 
#Hence, filled in manaully.
agg_elist$dist[333] <- 44
agg_elist$dist[358] <- 242
agg_elist$dist[717] <- 2370
agg_elist$dist[995] <- 195
agg_elist$dist[1018] <- 1429
agg_elist$dist[1273] <- 1627
agg_elist$dist[1305] <- 28
agg_elist$dist[1355] <- 753
agg_elist$dist[1356] <- 465
agg_elist$dist[1406] <- 1112
agg_elist$dist[1554] <- 370
agg_elist$dist[1572] <- 2319
agg_elist$dist[1573] <- 540
agg_elist$dist[1823] <- 85

save(agg_elist, file = "~/Box Sync/2018 Spring/SoDA 501/FinalProject/agg_elist.RData") 

