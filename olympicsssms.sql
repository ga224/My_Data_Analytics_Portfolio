Use My_Project;
Select * from athlete_events;
Select * from noc_regions;

/* How many olympics games have been held? */
Select count(distinct Year) as no_of_games from athlete_events;

/* List down all Olympics games held so far. */
Select distinct games from athlete_events
order by games asc;

/* Mention the total no of nations who participated in each olympics game? */
with nations as
(
	Select Year, region 
	from athlete_events a 
	inner join noc_regions b
	On a.NOC = b.NOC
)
Select  Year, count(distinct region)as no_of_nations from nations
Group by Year
Order by 1 asc

/* Which year saw the highest and lowest no of countries participating in olympics */
with nations as
(
	Select Games, region 
	from athlete_events a 
	inner join noc_regions b
	On a.NOC = b.NOC
)

Select Games, count(distinct region) as no_of_countries from nations
Group by Games
order by 2 asc /* To find the highest no. of countries participating, write desc instead of asc */


/* Which nation has participated in all of the olympic games */
  with tot_games as
              (select count(distinct games) as total_games
              from athlete_events),
          countries as
              (select games, region as country
              from athlete_events a
              join noc_regions b
			  ON a.noc = b.noc
              group by games, region),
          countries_participated as
              (select country, count(games) as total_participated_games
			  from countries
              group by country)
      select *
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by 1;

/* Identify the sport which was played in all summer olympics. */
with t1 as
(
	Select count(distinct Games) as No_of_total_games  from athlete_events
	Where Season = 'Summer'
),
t2 as (
	Select Count(distinct Games) as No_of_games, sport from athlete_events
	Where Season = 'Summer'
	Group by Sport
)
Select * from t2 
join t1 
ON t1.No_of_total_games  = t2.No_of_games

/* Which Sports were just played only once in the olympics.*/
Select sport, count(distinct event) as no_of_sports_played from athlete_events
Group by sport
order by no_of_sports_played asc

/* Fetch the total no of sports played in each olympic games.*/


Select Games,Count(Distinct Sport) as total_no_of_sports From athlete_events
Group By Games 
Order By total_no_of_sports Desc

/*Fetch oldest athletes to win a gold medal*/
Select name, age, medal from athlete_events
Where medal = 'Gold'
order by age desc



/* Fetch the top 5 athletes who have won the most gold medals. */
with t1 as(
	Select distinct Name, count (Medal) as no_of_medals From athlete_events
	where medal = 'Gold'
	Group by name
)
Select *, rank() over(order by no_of_medals desc) as Ran_k from t1

/* Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).                              */

with t1 as
	(
	select name, team, count(medal) as total_medals
	from athlete_events
	where medal in ('Gold', 'Silver', 'Bronze')
	group by name, team
	
	)
select *, dense_rank() over(order by total_medals desc) as ran_k 
from t1


/*  Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won. */
with t1 as
(
Select region, count(medal) as no_of_medals
from athlete_events a
inner join noc_regions b
ON a.NOC = b.NOC
where medal in ('gold' , 'silver' , 'bronze')
Group by region
)
Select *, RANK() over(order by no_of_medals desc) as ran_k
from t1


/* List down total gold, silver and bronze medals won by each country. */
Select Region,
Count(Case When Medal='Gold' Then 1 End) AS Gold,
Count(Case When Medal='Silver' Then 1 End) AS Silver,
Count(Case When Medal='Bronze' Then 1 End) AS Bronze
from athlete_events a
Join noc_regions b On a.NOC = b.NOC
Group by Region
Order By Gold Desc,Silver Desc,Bronze Desc

/* List down total gold, silver and bronze medals won by each country corresponding to each olympic games. */
Select Games, Region,
Count(Case When Medal='Gold' Then 1 End) AS Gold,
Count(Case When Medal='Silver' Then 1 End) AS Silver,
Count(Case When Medal='Bronze' Then 1 End) AS Bronze
from athlete_events a
Join noc_regions b On a.NOC = b.NOC
Group by Games, Region
Order By Gold Desc,Silver Desc,Bronze Desc



/* Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games. */
with t1 as
(
Select Games, Region, 
Count(case when medal ='Gold' Then 1 End ) as Gold,
Count(case when medal ='Silver' Then 1 End ) as Silver,
Count(case when medal ='Bronze' Then 1 End ) as Bronze,
Count(case when medal in ('Bronze', 'Gold', 'Silver') Then 1 End ) as total_medals
from athlete_events a
Join noc_regions b On a.NOC = b.NOC
Group by Games, region

)
Select Games, Region, max(Gold) as max_Gold, max(silver) as max_silver, max(bronze) as max_bronze, max(total_medals) as max_medals from t1
Group by Games, Region
order by max_Gold Desc,max_silver Desc,max_bronze Desc, max_medals desc

/* Which countries have never won gold medal but have won silver/bronze medals? */
Select Games, Region,
Count(Case When Medal='Gold' Then 1 End) AS Gold,
Count(Case When Medal='Silver' Then 1 End) AS Silver,
Count(Case When Medal='Bronze' Then 1 End) AS Bronze
from athlete_events a
Join noc_regions b On a.NOC = b.NOC
Group by Games, Region
Order By Gold asc,Silver Desc,Bronze Desc

/* In which Sport/event, India has won highest medals. */
SELECT sport ,count(medal) as total_medals
FROM athlete_events a
JOIN noc_regions b
ON a.noc=b.noc
where medal <> 'NA' And b.NOC = 'IND'
GROUP BY sport 
order BY total_medals desc

/* Break down all olympic games where India won medal for Hockey and how many medals in each olympic games */
Select sport, Games, count(medal) as medals_for_hockey
from athlete_events  a
JOIN noc_regions b
ON a.noc=b.noc
where region = 'India' and sport = 'hockey'
Group by sport, games
Order by 2





