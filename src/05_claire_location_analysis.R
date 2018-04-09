###
### Claire Kelling
### SODA 501
### Final Project
###
### Created 3/29/18 for analysis of locations of Twitter users.
### 

library(ggmap)
library(XML)
library(geosphere)
library(geonames)
library(Imap)
library(googleway)
library(xtable)

# Load data created my Xiaoran
load("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501_project/data/user_locations.Rdata")
source("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501_project/src/00_geo_dist_function.R")
load("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501_project/data/user_locations_finalcleaned.Rdata")

#I will use the subsetted data here
user_locations <- user_locations_c2

#consists of username, location (list), and coords (list)
# the coords are all of the unique locations
class(user_locations)
class(user_locations$coords)

########
# we want to find the furthest distance between any two points
########

#first, we want to record which location(s) is in the college town (an index)
towns<-c("Ithaca, NY", "State College, PA", "Bloomington, IN", "Lawrence,
         KS", "Blacksburg, VA", "College Station, TX", "Columbia, MO",
         "Champaign, IL", "Ann Arbor, MI", "Gainesville, FL")
user_towns <- user_locations$locations[[21]]
# look at user 20 for the problem with "Florida, USA"

key <- "AIzaSyBx0xrnryLGil3jNbKOkgSTBaHeZGqxLQg"
key2 <- "AIzaSyAtI-X5J7uMMqVDQwpKUqLqVJDQ2GBZ1kQ"
lonlat3 <- NULL
for(i in 1:length(user_towns)){
  lonlat2 <- google_geocode(address = user_towns[i], key = key)
  lonlat2 <- lonlat2$results$geometry$location
  print(i)
  #Sys.sleep(3)
  lonlat3 <- rbind(lonlat3, lonlat2)
}

#geocodeQueryCheck()

#record indice that is college town
coll_ind <- which(user_towns %in% towns)

# Now, I will create a distance matrix
#need to get matrix in correct format
df.cities <- data.frame(name = user_towns,
                         lat  = lonlat3$lat,
                         lon  = lonlat3$lng)
#this is in km (units)
dmat3 <- round(GeoDistanceInMetresMatrix(df.cities) / 1000)

#record the furthest and the largest distance from the college town
dist_vec <- dmat3[,coll_ind]
max_dist <- max(dist_vec) #measured in km
max_loc <- rownames(dmat3)[which(dmat3[,coll_ind] == max_dist)]
new_dat <- c(max_loc, max_dist)


rm(list = coll_ind, i, dist_vec, max_dist, max_loc, new_dat,
             user_towns, df.cities, dmat3, lonlat2, lonlat3)

###
### Now I will operationalize for the full dataset
###
full_dat <- NULL
for(j in 25:nrow(user_locations)){
  #j <- 24
  user_towns <- user_locations$locations[[j]]
  
  #remove NA's
  user_towns <- user_towns[!is.na(user_towns)]
  num_loc <- length(user_towns)
  print(paste(j, "****************************************"))
  
  if(length(user_towns) < 50){
    lonlat3 <- NULL
    for(i in 1:length(user_towns)){
      #i=8
      lonlat2 <- google_geocode(address = user_towns[i], key = key2)
      lonlat2 <- lonlat2$results$geometry$location
      print(i)
      Sys.sleep(runif(1,1,3))
      lonlat3 <- rbind(lonlat3, lonlat2)
    }
    
    #geocodeQueryCheck()
    
    #record indice that is college town
    coll_ind <- which(user_towns %in% towns)
    
    # Now, I will create a distance matrix
    #need to get matrix in correct format
    df.cities <- data.frame(name = user_towns,
                            lat  = lonlat3$lat,
                            lon  = lonlat3$lng)
    #this is in km (units)
    dmat3 <- round(GeoDistanceInMetresMatrix(df.cities) / 1000)
    
    #record the furthest and the largest distance
    dist_vec <- dmat3[,coll_ind]
    max_dist <- max(dist_vec) #measured in km
    max_loc <- rownames(dmat3)[which(dmat3[,coll_ind] == max_dist)]
    
    #record coll_town
    coll_loc <- rownames(dmat3)[coll_ind]
    
    #record the sum of the distances, assuming traveling in a line
    dist_vec <- NULL
    
    if(nrow(dmat3) > 1){
      for(k in 1:(nrow(dmat3)-1)){
        #k=6
        dist1 <- dmat3[k,k+1]
        dist_vec <- c(dist_vec,dist1)
      }
      dist_trav <- sum(dist_vec)
    }else{
      dist_trav <- 0
    }
    
    new_dat <- c(coll_loc, num_loc, max_loc, max_dist, dist_trav)
    
    full_dat <- rbind(full_dat, new_dat)
  }
}

#j needs to be up to 1518
#full_dat_final <- NULL
full_dat_final <- rbind(full_dat_final, full_dat) #done up to 24

#got up to j as 74
full_dat2 <- full_dat


nrow(full_dat2)
full_dat2 <- as.data.frame(full_dat2)
colnames(full_dat2) <- c("coll_loc", "num_loc", "max_loc", "max_dist", "dist_trav")
rownames(full_dat2) <- c()
full_dat2$max_dist <- as.numeric(as.character(full_dat2$max_dist))
full_dat2$dist_trav <- as.numeric(as.character(full_dat2$dist_trav))


#issues with exceeding daily requested number

#create aggregated statistics, by college towns
mean_max <- aggregate(. ~ coll_loc, full_dat2[-2], mean)
xtable(mean_max)

common_dest <- full_dat2 %>% group_by(coll_loc,max_loc) %>% tally() %>% filter(n>1)
xtable(common_dest)


##
## Now, I would just like to record the indice of the college town,
##  and the total number of unique locations.
##
full_dat <- NULL
for(j in 25:nrow(user_locations)){
  #j <- 24
  user_towns <- user_locations$locations[[j]]
  
  #remove NA's
  user_towns <- user_towns[!is.na(user_towns)]
  num_loc <- length(user_towns)
  print(paste(j, "****************************************"))
  
  if(length(user_towns) < 50){
    lonlat3 <- NULL
    for(i in 1:length(user_towns)){
      #i=8
      lonlat2 <- google_geocode(address = user_towns[i], key = key2)
      lonlat2 <- lonlat2$results$geometry$location
      print(i)
      Sys.sleep(runif(1,1,3))
      lonlat3 <- rbind(lonlat3, lonlat2)
    }
    
    #geocodeQueryCheck()
    
    #record indice that is college town
    coll_ind <- which(user_towns %in% towns)
    
    # Now, I will create a distance matrix
    #need to get matrix in correct format
    df.cities <- data.frame(name = user_towns,
                            lat  = lonlat3$lat,
                            lon  = lonlat3$lng)
    #this is in km (units)
    dmat3 <- round(GeoDistanceInMetresMatrix(df.cities) / 1000)
    
    #record the furthest and the largest distance
    dist_vec <- dmat3[,coll_ind]
    max_dist <- max(dist_vec) #measured in km
    max_loc <- rownames(dmat3)[which(dmat3[,coll_ind] == max_dist)]
    
    #record coll_town
    coll_loc <- rownames(dmat3)[coll_ind]
    
    #record the sum of the distances, assuming traveling in a line
    dist_vec <- NULL
    
    if(nrow(dmat3) > 1){
      for(k in 1:(nrow(dmat3)-1)){
        #k=6
        dist1 <- dmat3[k,k+1]
        dist_vec <- c(dist_vec,dist1)
      }
      dist_trav <- sum(dist_vec)
    }else{
      dist_trav <- 0
    }
    
    new_dat <- c(coll_loc, num_loc, max_loc, max_dist, dist_trav)
    
    full_dat <- rbind(full_dat, new_dat)
  }
}

