This file is to keep track of our progress and tasks every week.

#Week of Feb 19
## Shipi - Humanizr 
Install.sh working, but classifer not running because of setup issues. 
We have now decided to change direction. 
We will now subset the dataset to number of tweets from college towns. 
This will make the twitter dataset manageable. Currently the dataset is 13.4 GB. 

# Week Feb 26:
## Xiaoran:
* write codes for selecting tweets in the ten college towns that Shipi suggested 
* https://www.citylab.com/equity/2016/09/americas-biggest-college-towns/498755/
## Claire:
* run codes to select the college towns 
(or can just show Xiaoran how to run codes on Penn State Cluster, i.e., running R codes on Terminal)
* based on the selected tweets, write codes for selecting other tweets that came 
		from the same Twitter users (maybe Shipi and So Young can help with this!)
* create code to analyze where people from college towns are going through percentages
* create code to create images to visualize where people are going

# Week March 15:
## Burt's comments:
* What is the population that we want to focus on?
* Why college towns? Why not using the whole dataset?
## Things we may need to discuss:
* Do we still want to keep the college towns direction? 
* If so, we may want to identify the students Twitter users using, for example, 
     the profile information of the users.
	CLAIRE COMMENT- is this data available? Data on users?

* Or do we want to take a step back and look at ALL of the data? 
* We can downsize the data by subsetting the VARIABLES (instead of users). 
* For example, we just need the tweet id, the user id, the location and coordinates of the tweets 
	(and maybe also the followers & friends count, the content of the tweet, 
	the user profile to identify non-human vs. human users).
* For reference: college by enrollment 
	- https://nces.ed.gov/fastfacts/display.asp?id=74
	- http://www.stateuniversity.com/rank/tot_enroll_rank.html
	- https://en.wikipedia.org/wiki/List_of_United_States_university_campuses_by_enrollment
## After discussion during the class break:
* We may be able to stick to the college town data. 
	What we need to do is to provide stronger rationale for doing that.
* We can also peform same prodecure to the big city users. 
	And compare the flow for college towns to that of big cities.
* (also random thoughts by Xiaoran) Maybe we can just conduct analysis on people traveling 
	IN and OUT of the towns and cities. 
	See what the directions of the flow are during holiday season. 
	For example, I'm interested in the question: 
	Do people tend to travel into or out of college towns? 
	When are the in- and out-flow tend to happen (pre- or post-Christmas)? 
	Maybe we will get different answers for the college towns and the big cities.

#Week of Mar19
## Shipi
Found an API, called Botcheck. 
	It is not really checking if the tweet is organization butchecks for tweet being a bot. 
	It returns a probablity of an account being a bot. 
	More info here: https://github.com/marsha5813/botcheck
## So Young:
Received comment from Dr. Pan regarding the rationale for choosing college town. 
Have been documenting studies for the literature review. 
I am still unable to find any study that looked at holiday season travel.
If everyone is willing and if we can develop this further, I think we have a chance at publishing. 
As Xiaoran mentioned about our paper can provide insight into 
	1.understanding in- and out-flows during Christmas season
	2. identifying VFR (visiting friends and relatives) tourists, focusing mostly on college students.
E.g. 
* One paper that looked at holiday migration (but focuesd on urban heat island, examined temperature rather than movement): 
	Zhang, J., Wu, L., Yuan, F., Dou, J., & Miao, S. (2015). Mass human migration and Beijing’s urban heat island during the Chinese New Year holiday. Science bulletin, 60(11), 1038-1041.
* One paper that looked at college student travel: 
	Erdogan, M., & Açikalin, S. (2015). Comparing factors affecting intra and inter-city travel mode choice of university students 1. Tüketici Ve Tüketim Araştırmaları Dergisi = Journal of Consumer and Consumption Research, 7(2), 1-18. 
* Rationale for studying movement initiating from college towns using Twitter data: 
	Fotis, J., Buhalis, D., & Rossides, N. (2012). Social media use and impact during the holiday travel planning process (pp. 13-24). Springer-Verlag.

TASKS TO DO:
* The travel pattern we are looking at could also be categorized VFR:
	Bischoff, E. E., & Koenig‐Lewis, N. (2007). VFR tourism: The importance of university students as hosts. International Journal of Tourism Research, 9(6), 465-484.
	Backer, E. (2008). VFR Travellers–Visiting the destination or visiting the hosts. Asian Journal of Tourism and Hospitality Research, 2(1), 60-70.
	Griffin, T. (2013). Research note: A content analysis of articles on visiting friends and relatives tourism, 1990–2010. Journal of Hospitality Marketing & Management, 22(7), 781-802.
	Seaton, A. V., & Palmer, C. (1997). Understanding VFR tourism behaviour: the first five years of the United Kingdom tourism survey. Tourism management, 18(6), 345-355.
* Reference for segmenting our Twitter users: 
	Becken, S., Simmons, D., & Frampton, C. (2003). Segmenting tourists by their travel pattern for insights into achieving energy efficiency. Journal of Travel Research, 42(1), 48-56.
	Cohen, E. (1974). Who is a tourist?: A conceptual clarification. The sociological review, 22(4), 527-555.
## Xiaoran
* Using Claire's code, run on Cluster to subset tweets from the 10 top big cities.\n
	- Note: The full names of the places in the Twitter dataset are the exact *region* names (e.g., Manhattan, Queens) but not always the *city* names (e.g., New York City). 
		Therefore, the list of the regions, based on the locations of the colleges listed on the website, that I'm extracting are:
		- New York: Brooklyn, Queens, Manhattan, Bronx, and Staten Island
		- Los Angeles: Los Angeles, Westwood, Eagle Rock, Westchester
		- Chicago: Chicago, Evanston
		- Boston: Boston, Cambridge, Medford, Chestnut Hill
		- Philadelphia: Philadelphia, University City, Cecil B. Moore, Radnor Township
		- Miami: Miami, Coral Gables，Boca Raton, University Park
		- Dallas: Dallas, Highland Park, University Park, Richardson, Arlington
		- Washington, DC: Washington, DC, Georgetown, Fairfax, VA
		- San Francisco: San Francisco, Berkeley
		- Houston: Houston
* After figuring out the cutoffs and deleting bot tweets, can start to write codes for selecting in- and out-flows for the two Rdataset.

## Shipi
Added a file 03_botcheck.R in master. 

Input to the function is a twittername without the @ symbol. Some examples I ran are shown below:\n
-botcheck("barackobama") #  #returns 0.64\n
-botcheck("McDonalds")   #0.62\n
-botcheck("BurgerKing") #0.5\n
-botcheck("xiaoransunpsu") #0.32

The value returned is the english score from the json object that the Botometer API returns. A higher value indicates a higher chance of being a bot. 

#week Mar26

## Xiaoran
* Ran the subsetting codes again on Cluster using the entire whole raw Twitter data (the whole 13.4GB file with no broken lines)
* Descriptives of the data are as following:
	- College *towns* tweets:
		- 11786 tweets tagged with any of those college towns
		- 2234 users identified
		- in total 346749 tweets of those users (stored in Rdata)
	- College *cities* tweets:
		- 690466 tweets tagged with any of those college towns
		- 113526 users identified
		- in total 1681450 tweets of those users (stored in Rdata)
