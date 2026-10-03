select top 10 * from evcharge
select avg(demand) from evcharge

-- Q.1 1. Identify the busiest charging locations
-- Hint --  Which locations have the highest number of charging sessions?
select location ,
count(*) as total_session 
from evcharge 
group by location 
order by 2 desc


-- Q.2  2 — Highest average charging demand
select location,round(avg(demand),2)as avg_demand 
from evcharge 
group by location 
order by 2 desc

-- Q.3. Identify high-value charging locations
-- Hint - Find locations that have above-average total demand AND above-average 
-- session volume. These are locations with both strong usage and strong demand.
-- int
/* int --Show me each charging location, its session count, and average demand.
Keep only locations that have more sessions than the average location AND higher 
average demand than the overall average. Finally, show the busiest qualifying locations first.
*/

with location_summary as(
select location,count(*) as total_session ,avg(demand) as avg_demand
from evcharge 
group by location
),
overall_summary as(
select avg(total_session) as avg_session , (select avg(demand) from evcharge) as overall_avg_demand
from location_summary 
)
select l.location ,
l.total_session ,
ROUND(l.avg_demand, 2) as avg_demand 
from location_summary l 
cross join overall_summary o 
where l.total_session > o.avg_session
and l.avg_demand > o.overall_avg_demand 
order by l.total_session desc



-- Q.2. Find underperforming locations

-- Hint - Identify locations with high session volume but below-average demand per session.

with location_summary as(
select location,count(*) as total_session, avg(demand) as avg_demand
from evcharge 
group by location 
),
 summary_location as (
select avg(total_session) as avg_sessions,(select avg(demand) from evcharge) as overall_avg
from location_summary 
)
select l.location ,
l.total_session,
round(l.avg_demand,2) as avg_demand
from location_summary l
cross join summary_location s
where l.total_session > s.avg_sessions
and l.avg_demand < s.overall_avg 
group by l.total_session;




-- Q.3 — High-Demand, Low-Usage Chargers ⚡
--- Find chargers that have above-average demand but fewer sessions than the average charger.

with location_summary as(
select charger_id , location ,count(*) as total_session ,avg(demand) as avg_demand
from evcharge 
group by charger_id,location 
),
second_summary as (
select avg(total_session)as avg_session ,
(select avg(demand) 
from evcharge ) as overall_avg_demand
from location_summary 
)
select top 10 ls.charger_id,
ls.location,ls.total_session ,
round(ls.avg_demand,2)
from location_summary ls 
cross join second_summary ss 
where ls.avg_demand > ss.overall_avg_demand 
and ls.total_session < ss.avg_session 
order by ls.charger_id desc



-- Q.4 --4 — Busiest Charger in Each Location ⚡
--  For each charging location, find the single charger that handled the highest number of charging sessions.

with charger_summary as (
select top 10 charger_id , location ,
count(*) as total_session,avg(demand) as avg_demand,
sum(demand) as total_demand 
from evcharge 
group by charger_id ,location
),
ranked_charger as (
select charger_id ,location , total_demand ,
total_session, avg_demand ,
row_number ( ) over ( partition by location 
order by total_session desc) as charger_rank
from charger_summary 
)
select charger_id, location,
total_session,
round(total_demand,2)as total_demand , 
round(avg_demand,2),avg_demand
from ranked_charger 
where charger_rank = 1 
order by total_session desc ;



--Q.5 - Top 3 Chargers in Each Location ⚡
-- Hint - Find the top 3 busiest chargers in every location based on the number of charging sessions.

with charger_summary as ( 
select charger_id, location ,
count(*) as total_session ,
sum(demand) as sum_demand,
avg(demand) as avg_demand
from evcharge 
group by charger_id,location
),
ranked_summary as( 
select charger_id ,
location ,
total_session ,
sum_demand,
avg_demand ,
rank() over(partition by location order by total_session desc ) as overall_review 
from charger_summary 
) 
select charger_id ,location , total_session ,
round(avg_demand,2) as avg_demand ,
round(sum_demand,2) as sum_demand ,
overall_review 
from ranked_summary
where overall_review  < 3 
order by location ,overall_review 



--Q.6 - High-Value Repeat Users ⚡
--   Find users who have completed more charging sessions than the average user and whose total demand is also higher than the average user's total demand.

with user_summary as(
select user_id,
count(*) as total_session ,
avg(demand) as avg_demand,
sum(demand) as sum_demand 
from evcharge
group by user_id
) ,
repeat_summary as( 
select avg(total_session) as avg_session ,
avg(sum_demand) as avg_total_demand
from user_summary 
)
select top 10 us.user_id, us.total_session,
round(rs.avg_total_demand,2) ,
round(us.avg_demand,2),round(us.sum_demand,2)
from user_summary us
cross join repeat_summary rs
where us.total_session > rs.avg_session 
and  us.sum_demand > rs.avg_total_demand
order by us.sum_demand desc ;



--Q.7  -- Users Above Average Demand ⚡
 --- Find users whose total charging demand is higher than the average total demand across all users.

 with user_demand_summary as (
 select user_id,count(*) as total_session ,
 avg(demand) as avg_demand ,
 sum(demand) as sum_demand 
 from evcharge 
 group by user_id 
 ),
 second_summary as(
 select avg(total_session) as avg_session ,
 avg(sum_demand) as avg_total_session 
 from user_demand_summary 
 )
 select top 10 user_id, total_session,round(sum_demand,2) ,round(avg_demand,2)
 from user_demand_summary ud
 cross join second_summary ss
 where ud.total_session > ss.avg_session 
 and ud.sum_demand > ss.avg_total_session 
 order by total_session desc



 --Q.8 -Rank Users by Total Charging Demand
---   Rank all users based on their total charging demand.

with user_demand_summary as (
select user_id ,
count(*) as total_session ,
sum(demand) as sum_demand ,
avg(demand) as avg_demand 
from evcharge 
group by user_id 
),
ranked_user_summary as ( 
select user_id, total_session,sum_demand ,avg_demand 
rank() over( partition by user_id order by sum_demand desc)as Ranked_user
from user_demand_summary 
)
select user_id , total_session ,round(sum_demand,2),
round(avg_demand,2),Ranked_user 
from user_demand_summary 
order by Ranked_user desc ;



--Q.9 - Peak Demand Charging Hours ⚡
-- Identify the top 10 hours of the day with the highest average charging demand.
-- Hint:
-- Extract the hour from the charging timestamp.
-- Calculate the total charging sessions and average demand for each hour.
-- Display the top 10 hours with the highest average demand.

select top 10 location,
start_hour as charging_hour ,
count(*) as total_session ,
round(avg(demand),2) as avg_demand 
from evcharge
group by start_hour,location
order by avg_demand desc ;


--- Q.10 — High-Demand Location-Hour Combinations
-- Only consider location-hour combinations with at least 10 sessions.

SELECT TOP 10
    Location,
    Start_Hour,
    COUNT(*) AS total_sessions,
    ROUND(AVG(Demand), 2) AS avg_demand
FROM evcharge
GROUP BY Location, Start_Hour
HAVING COUNT(*) >= 10
ORDER BY avg_demand DESC;


-- Q.11 -- Classify Charging Sessions by Demand
--- Categorize charging sessions into High, Medium, and Low demand.

select 
case 
    when demand >= 40 then 'High Demand'
    when demand >= 20 then 'Medium Demand' 
    else 'Low Demand'
    end as deand_category,
    count(*) as total_session
from evcharge 
group by 
    case 
        when demand >= 40 then 'High Demand'
        when demand >= 20 then 'Medium Demand'
        else 'Low Demand'
        end
order by total_session asc ;


    -- CTES claues Second_fromat

with demand_summary as (
select 
    case 
        when demand >=40 then 'High Demand'
        when demand >=20 then 'Medium Demand'
        else 'Low Demand' 
        end as demand_category
        from evcharge
)
select demand_category ,count(*) as total_session 
from demand_summary 
group by demand_category
order by total_session ;


--Q12 — Month-over-Month Demand Growth 📈
-- For each month, calculate total charging demand and compare it with the 
-- previous month's demand. Also calculate the percentage growth or decline.

with monthly_summary as (
select year(start_datetime) as charging_year,
month(start_datetime) as charging_month ,
sum(demand) as total_demand
from evcharge
group by year(start_datetime),month(start_datetime) 
),
monthly_demand_summary as(
    select DATEFROMPARTS (charging_year ,
        charging_month , 1 ) as month_date ,total_demand
from monthly_summary 
),
demand_growth as ( 
    select month_date , total_demand ,
            LAG(total_demand) OVER ( 
    order by month_date )as previous_month_demand
  from monthly_demand_summary 
)
select month_date,
round(total_demand,2) as total_demand ,
round(previous_month_demand,2) as month_date,
round(
    ( total_demand - previous_month_demand )
    / nullif(previous_month_demand,0 ) *100 ,2 )as mom_growth_percentage

    from demand_growth 
    

  -- Q13 — Find the fastest-growing month
  -- Which month had the highest positive month-over-month demand growth?
  
  with monthly_summary as(
  select year(start_datetime) as charging_year ,
  month(start_datetime) as charging_month ,
  sum(demand) as total_demand
  from evcharge
  group by year(start_datetime),month(start_datetime)
  -- order by charging_month
  ),
  monthly_demand_summary as ( 
  select 
  DATEFROMPARTS( charging_year , charging_month ,1 ) as month_date ,
  total_demand 
  from monthly_summary 
  ),
  demand_growth as (

  select month_date , 
    total_demand ,
        LAG(total_demand) OVER
             ( order by month_date) as previous_month_demand
  from monthly_demand_summary 
  ),
  growth_summary as (

  select month_date,total_demand,previous_month_demand ,
  round(
        ( total_demand - previous_month_demand) 
        / nullif(previous_month_demand , 0) *100 ,
        2)

                     /* Current = 71,741.55
                    Previous = 64,933.48

                    (71,741.55 - 64,933.48)
                    ------------------------ × 100
                           64,933.48

                    = 10.48%  */

        as mom_growth_percentage 
  from demand_growth 
  )

  select top 1 month_date,
  round(total_demand ,2) as total_demand ,
  round(previous_month_demand,2) as previous_month_demand ,
  mom_growth_percentage 
  from growth_summary 
  where mom_growth_percentage > 0
  order by mom_growth_percentage desc ;



  --Q.14 - Peak-hour demand contribution
  ---       What percentage of total demand occurs during peak hours?

  with peak_summary as (
  select peak_offpeak , 
    count(*) as total_session ,
    sum(demand) as total_demand
    from evcharge 
    group by peak_offpeak
 ),
 overall_summary as (
 select sum(demand) as overall_total_demand
 from evcharge
 )
 select p.peak_offpeak ,
       p.total_session,
       round( p.total_demand, 2) as Total_demand,
       round( p.total_demand * 100.0 / o.overall_total_demand
        ,2 ) as demand_percentage 
 from peak_summary p
 cross join overall_summary o


-- Q17: Charger Type Contribution
    --  What percentage of total sessions and total demand comes from each charger type?

    select charger_type_label,
        count(*) as total_session,
        round(sum(demand),2) as total_demand ,
        round( count(*) *100.0 / 
            ( select count(*) from evcharge) ,2) session_percentage ,
        round(sum ( demand ) *100.0 /
            (select sum(demand) from evcharge ),2 ) as demand_percentage
    from evcharge 
    group by charger_type_label 


--Q.Location Contribution to Total Demand
--  What percentage of overall charging demand comes from each location?

    select location ,
        count(*) as total_session ,
        round(sum(demand),2) total_demand ,

        round(sum(demand) * 100.0 /
            (select sum(demand) from evcharge ),2) as demand_percentage 

    from evcharge 
    group by location




--Q19: Day × Hour Charging Activity
  --   Which day and hour combinations have the highest number of charging sessions?

  select top 20 day_of_week ,
        start_hour,count(*) as total_session ,
        round(sum(demand),2) as total_demand 
  from evcharge 
  group by day_of_week,start_hour

  --- Revenue — add it as Estimated Revenue
  select sum(demand) as total_demand ,
  round(sum(demand) * 15 ,2) as estimated_revenue
  from evcharge 


