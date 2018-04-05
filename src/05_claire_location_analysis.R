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

# Load data created my Xiaoran
load("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501/project/data/user_locations.Rdata")
source("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501/project/src/00_geo_dist_function.R")


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
user_towns <- user_locations$locations[[90]]

key <- "AIzaSyBx0xrnryLGil3jNbKOkgSTBaHeZGqxLQg"
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

#record the furthest and the largest distance
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
for(j in 411:nrow(user_locations)){
  #j <- 410
  user_towns <- user_locations$locations[[j]]
  
  print(paste(j, "****************************************"))
  
  if(length(user_towns) < 50){
    lonlat3 <- NULL
    for(i in 1:length(user_towns)){
      #i=1
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
    
    #record the furthest and the largest distance
    dist_vec <- dmat3[,coll_ind]
    max_dist <- max(dist_vec) #measured in km
    max_loc <- rownames(dmat3)[which(dmat3[,coll_ind] == max_dist)]
    
    #record coll_town
    coll_loc <- rownames(dmat3)[coll_ind]
    
    #record the sum of the distances, assuming traveling in a line
    dist_vec <- NULL

    for(k in 1:(nrow(dmat3)-1)){
      #k=6
      dist1 <- dmat3[k,k+1]
      dist_vec <- c(dist_vec,dist1)
    }
    dist_trav <- sum(dist_vec)
    
    
    
    new_dat <- c(coll_loc, max_loc, max_dist, dist_trav)
    
    full_dat <- rbind(full_dat, new_dat)
  }
}

#j needs to be up to 2235

#only ?? users have less than 50 locations
nrow(full_dat)
colnames(full_dat) <- c("coll_loc", "max_loc", "max_dist", "dist_trav")
rownames(full_dat) <- c()

#issues with exceeding daily requested number
mean_max <- aggregate(. ~ coll_loc, d[-2], mean)
mean_tot <- aggregate(. ~ coll_loc, d[-1], mean)

common_dest <- count(x, c('coll_loc','max_loc'))