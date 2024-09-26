SELECT * FROM universe.athlete_events;

# How many olympics games have been held?
select count(distinct Games) from athlete_events;


# List down all Olympics games held so far?
select distinct games from athlete_events;


# Mention the total no of nations who participated in each olympics game?
select games,count(distinct NOC) as no_of_nations from athlete_events
group by games;


# Which year saw the highest and lowest no of countries participating in olympics?
#....For highest..........
SELECT Year, COUNT(DISTINCT NOC) AS no_of_countries
FROM athlete_events
GROUP BY Year
ORDER BY no_of_countries DESC
LIMIT 1;

#...........For Lowest..........
SELECT Year, COUNT(DISTINCT NOC) AS no_of_countries
FROM athlete_events
GROUP BY Year
ORDER BY no_of_countries ASC
LIMIT 1;


# Which nation has participated in all of the olympic games?
SELECT NOC
FROM athlete_events
GROUP BY NOC
HAVING COUNT(DISTINCT games) = (SELECT COUNT(DISTINCT games) FROM athlete_events);


# Identify the sport which was played in all summer olympics.
SELECT sport
FROM athlete_events
WHERE season = 'Summer'
GROUP BY sport
HAVING COUNT(DISTINCT games) = (
    SELECT COUNT(DISTINCT games)
    FROM athlete_events
    WHERE season = 'Summer'
    );


# Which Sports were just played only once in the olympics?
select sport,count(Sport) as Played from athlete_events
group by Sport
order by count(Sport) asc
limit 1;

#Another way of query
select min(sport) from athlete_events
limit 1;

#Another way of query
select sport from athlete_events
group by Sport
having count(distinct sport)=1
limit 1;


# Fetch the total no of sports played in each olympic games.
select Games, count(distinct Sport) as No_of_Sports_Played from athlete_events
group by Games;


# Fetch details of the oldest athletes to win a gold medal.
SELECT *FROM athlete_events
WHERE medal = 'Gold'
order by age desc
limit 1;


# Fetch the top 5 athletes who have won the most gold medals.
select Name, count(medal) from athlete_events
where medal = 'Gold'
group by Name
order by count(Medal) desc
limit 5;


# Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
select Name, count(medal) from athlete_events
where medal in ('Gold','Silver','Bronze')
group by Name
order by count(Medal) desc
limit 5;


# Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
select NOC,Team,count(Medal) as Medal_Count from athlete_events
where Medal in ('Gold','Silver','Bronze')
group by NOC,Team
order by count(Medal) desc
limit 5;


# List down total gold, silver and broze medals won by each country.
select NOC,Team,
	count(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS total_gold_medals,
    count(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS total_silver_medals,
    count(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS total_bronze_medals
from athlete_events
where medal in ('Gold','Silver','Bronze') 
group by NOC,Team
order by total_gold_medals desc,total_silver_medals desc, total_bronze_medals desc;


# List down total gold, silver and broze medals won by each country corresponding to each olympic games.
select NOC,Team,Games,
	count(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS total_gold_medals,
    count(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS total_silver_medals,
    count(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS total_bronze_medals
from athlete_events
where medal in ('Gold','Silver','Bronze')
group by NOC,Team,Games
order by 
          total_gold_medals desc,
          total_silver_medals desc, 
          total_bronze_medals desc;


# Identify which country won the most gold, most silver and most bronze medals in each olympic games.
select athlete_events.NOC,noc_regions.region,athlete_events.games,
                 count('Gold') as Gold_Medals,
			     count('Silver') as Silver_Medals,
                 count('Bronze') as Bronze_medals from athlete_events 
Left join noc_regions on athlete_events.NOC=noc_regions.NOC
where medal not in ('NA')
group by athlete_events.NOC,noc_regions.region,athlete_events.games
order by count('Gold') desc, 
	     count('Silver') desc, 
         count('Bronze') desc
         limit 1;


# Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
select athlete_events.NOC,noc_regions.region,athlete_events.games,
                 count('Gold') as Gold_Medals,
			     count('Silver') as Silver_Medals,
                 count('Bronze') as Bronze_medals,
                 count(medal in ('Gold','Silver','Bronze')) as Total_Medals from athlete_events 
Left join noc_regions on athlete_events.NOC=noc_regions.NOC
where medal not in ('NA')
group by athlete_events.NOC,noc_regions.region,athlete_events.games
order by count('Gold') desc, 
	     count('Silver') desc, 
         count('Bronze') desc,
         count(medal in ('Gold','Silver','Bronze')) desc
         limit 1;
         
         
# Which countries have never won gold medal but have won silver/bronze medals?
WITH CountriesWithGold AS (
    SELECT DISTINCT NOC 
    FROM athlete_events
    WHERE medal = 'Gold'
),
CountriesWithNoGold AS (
    SELECT NOC, Team, COUNT(medal) AS Total_Medals
    FROM athlete_events
    WHERE medal IN ('Silver', 'Bronze')
    AND NOC NOT IN (SELECT NOC FROM CountriesWithGold)
    GROUP BY NOC, Team
)
SELECT * 
FROM CountriesWithNoGold
ORDER BY Total_Medals DESC;


# In which Sport/event, India has won highest medals.
SELECT Sport,COUNT(medal) AS Total_Medals
FROM athlete_events
WHERE NOC = 'IND' 
    AND medal != 'NA'
GROUP BY Sport
ORDER BY Total_Medals DESC
LIMIT 1;


# Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
SELECT Games, COUNT(DISTINCT Medal) AS Total_Medals
FROM athlete_events
WHERE Team = 'India' 
    AND Sport = 'Hockey'
    AND Medal != 'NA'
GROUP BY Games
ORDER BY Games desc;


# Display the first 3 records from the customer table whose first name starts with ‘b’
select * from athlete_events
where Name like 'b%'
limit 3;


# Find all customers whose first name ends with "a"
select * from athlete_events
where Name like '%a';


# Display the list of first 4 cities which start and end with ‘a’
select City from athlete_events
where City like 'a%a';


# Find all customers whose first name have "NI" in any position
select * from athlete_events
where name like '%NI%';


# Find all customers whose first name have "r" in the third position
select * from athlete_events
where name like '__r%';


# Find all customers whose first name starts with "d" and are at least 5 characters in length
select * from athlete_events
where name like 'd_%';


# Find names of customers whose first name starts with "L" and ends with "A"
select * from athlete_events
where name like 'L%A';