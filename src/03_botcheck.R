
#Title: Botcheck function 
#Date: March 22
#Author: Shipi Kankane 

#Using Marshas wrapper on Botometer API developed by OSoMe (Observations on Social Media lab)

install.packages("devtools")
library(devtools)
install_github("marsha5813/botcheck")
library(botcheck)

# Load dependencies
library(httr)
library(xml2) 
library(RJSONIO)

#Provide Mashape Key from https://market.mashape.com/OSoMe/botometer/
Mashape_key = "JY2kfb6O2EmshtBFeg4gEwwIlpyyp12VR2Djsni9rPG5gw9AZj"

#Use Twitter app key and token info
consumer_key = "Ms2GJtHg2EIZR4YMgs6l6CKpd" #(twitter app soda 501)
consumer_secret = "BA5s9W45UIzVSQh1EHP1pXQh4WZNMhTU5m9RcfKsfpvlBcEELq"
access_token = "965664562421870593-C3PvWtr1AtwaV0sVwhCgBbJZrgsuicE"
access_secret = "VHDy686aa3Qn5Y2pLY4NUHBr8uzzEoHIbomyaDSnm3MTP"

#myapp = oauth_app("soda591", key=consumer_key, secret=consumer_secret)
#sig = sign_oauth1.0(myapp, token=access_token, token_secret=access_secret)

myapp1 = oauth_app("soda501", key=consumer_key, secret=consumer_secret)
sig1 = sign_oauth1.0(myapp1, token=access_token, token_secret=access_secret)

#Enter Twitter ID without @ symbol to the botcheck function. This takes an everage of about 10sec to execute each time. 

botcheck("barackobama") #  #returns 0.64
botcheck("McDonalds")   #0.62
botcheck("BurgerKing") #0.5
botcheck("xiaoransunpsu") #0.32

#The value returned is the english score from the json object that the Botometer API returns. A higher value indicates a higher chance of being a bot. 

load("coll_town_users.Rdata")
View(coll_town_users)
class(coll_town_users)[1]
coll_town_users[2]
num.coll.town.users=length(coll_town_users)
prob.bot = vector(mode = "numeric",length = num.coll.town.users)

for(i in 2101:2235){
    if(is.null(botcheck(coll_town_users[i]))){
        prob.bot[i] = -10
    }
    else{
        prob.bot[i] = botcheck(coll_town_users[i])
    }
}
