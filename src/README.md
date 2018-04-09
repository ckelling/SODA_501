# SODA_501 Project src

Below there is a brief description of all of the code files found in this folder.

## 00_geo_dist_function.R
This file includes a function to measure distance between two lat/lon points.
From the following website: https://eurekastatistics.com/calculating-a-distance-matrix-for-geographic-points-using-r/

## 01_loading_and_subsetting.R
This file does the following tasks:
* reads in the whole raw dataset (4.8 million tweets, 13.4GB) on ICS cluster
* from the raw dataset, selects Twitter users who have had any tweet(s) geo-tagged with any of the 10 colleg towns ( https://www.citylab.com/equity/2016/09/americas-biggest-college-towns/498755/)
* subsets the dataset by selecting all the tweets of the Twitter users selected above

## 02_data_exploration.R
This file does the following tasks:
* reads in data for college town users
* records all locations of tweets
* creates a plot comparing college towns and where the users are tweeting

## 03_botcheck.R

## 04_user_location_analysis.R
This file does the following tasks:
* selects unique different locations of each user and save the data
* cleans bots (botcheck output>.59) and users who have traveled to more than 25 unique locations
* computes descriptivs of each college town by aggregating the users
* describes for each college town, the places (towns/cities and states) other than the specific town that users traveled to (or from)

## 05_claire_location_analysis.R
This file does the following tasks:
* reads in data for college town users
* records all locations of tweets
* records the furthest distance traveled, in km
* for all users, it records the largest travel and the sum of all distances traveled
* records the indice of the college town 
* also creates image comparing the relative frequency of trip progress vs the total number of locations vs the college town
