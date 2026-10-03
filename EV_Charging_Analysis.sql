create  database EV_Charging
go
use EV_Charging

select * from EVcharge ;

select count(*) as Totsl 
from evcharge ;

select top 10 * from evcharge




--1 — Get our first project KPIs
select count(*) as Total ,
count(distinct user_id) asunique_userid , 
count(distinct charger_id) as unique_chargerid,
sum(demand), avg(demand), avg(duration) 
from evcharge




--2 — Demand by Location
select location , count(distinct user_id)as total ,
round(avg(demand),2)as avg_demand,
round(sum(demand),2)as sum_demand,
round(avg(duration),2) as avg_duration
from evcharge 
group by location 
order by location



--3 — Charger Type Analysis
select charger_type_label ,count(*) as Total_session ,count(distinct user_id) as total_userid ,count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge 
group by charger_type_label
order by Total_session



--4 — Charging Demand by Hour
select start_hour ,count(*) as Total_session ,count(distinct user_id) as total_userid ,count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge 
group by start_hour
order by Total_session



--5 — Peak vs Off-Peak
select peak_offpeak ,count(*) as Total_session ,count(distinct user_id) as total_userid ,count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge 
group by peak_offpeak
order by Total_session



--6 — Demand by Day of Week
select day_of_week ,count(*) as Total_session ,count(distinct user_id) as total_userid ,count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge 
group by day_of_week
order by Total_session

--7 — Monthly Charging Trend
select month ,count(*) as Total_session ,count(distinct user_id) as total_userid ,count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge 
group by month
order by Total_session



--Your monthly analysis
select year, month(start_datetime) as Month_number , month ,
count(*) as total_session ,
count(distinct user_id) as total_userid ,
count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand ,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration 
from evcharge 
group by year , month(start_datetime) ,month 
order by year,Month_number



--8 — Top Charging Locations
select location , count(*) as total_session ,
count(distinct user_id) as total_userid ,
count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand ,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge 
group by location 
order by location ;



-- Top 5 Highest Location
select top 5 location , count(*) as total_session ,
count(distinct user_id) as total_userid ,
count(distinct charger_id) as total_chargerid ,
round(sum(demand),2) as sum_demand ,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge 
group by location 
order by 2 desc ;


--10 — Filtering with WHERE using the peak_offpeak columns
select location ,peak_offpeak, count(*) as total_session ,
round(sum(demand),2) as sum_demand ,
round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration 
from evcharge 
where peak_offpeak = 'peak' 
group by location ,peak_offpeak
order  by location



-- 11 — Which locations have high average demand?
select top 5 location , count(*) as total_session , 
sum(demand) as sum_demand,
avg(demand) as avg_demand ,
avg(duration) as avg_duration
from evcharge 
group by location 
order by location desc

select location , round(avg(demand),2) as avg_demand 
from evcharge 
group by location 
having avg(demand) > 20



--12 — High-demand sessions
select count(*) as total_session, round(avg(demand),2) as avg_demand ,
round(avg(duration),2) as avg_duration
from evcharge  
where demand > 30




--13 - High-demand sessions by charger type
select charger_type,count(*) as total_session , round(avg(demand),2) as avg_demand , 
round(sum(demand),2) as sum_demand , round(avg(duration),2) as avg_duration
from evcharge 
where demand > 30 
group by charger_type 
order by total_session desc




--14 - analyze which locations have the highest number of high-demand sessions:
select location , count(*) as total_session , avg(demand) as avg_demand , avg(duration) as avg_duration 
from evcharge 
where demand > 30 
group by location
order by location desc




--15 - highest-demand individual chargers
select top 10 charger_id ,location ,
count(*) as total_session,
round(sum(demand),2) as total_demand,
round(avg(demand),2) as avg_demand ,
round(sum(duration),2) as sum_duration 
from evcharge 
group by charger_id , location 
order by 3 desc



SELECT TOP (10)
    Charger_id,
    Location,
    COUNT(*) AS Total_Sessions,
    ROUND(SUM(Demand), 2) AS Total_Demand,
    ROUND(AVG(Demand), 2) AS Avg_Demand
FROM evcharge
GROUP BY
    Charger_id,
    Location
ORDER BY Total_Sessions DESC;


--Q.16 - 




