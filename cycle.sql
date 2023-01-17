
create view dbo.cycle as
with cycle as
(
select [ride_id]
      ,[rideable_type]
      ,[member_casual],
	  cast(started_at as date) as started_date,
	  cast(started_at as date) as ended_date,
	  cast(started_at as time) as started_time,
	  cast(ended_at as time) as ended_time
from Bike
)
select * from cycle;

ALTER view dbo.cycle as
with cycle as
(
select [ride_id]
      ,[rideable_type]
      ,[member_casual],
	  cast(started_at as date) as started_date,
	  cast(started_at as date) as ended_date,
	  left(cast(started_at as time),8) as started_time,
	  left(cast(ended_at as time),8) as ended_time
from Bike
)
select *,datediff(minute,started_time,ended_time) AS ride_length from cycle
where datediff(minute,started_time,ended_time)>0;

--View of the final data
select * from cycle;

--Total number of Rides
select distinct count(ride_id) as Total_Rides from cycle;

--Number of Rides by customer type
select member_casual, count(ride_id) as Total_Rides 
from cycle
group by member_casual;

--Number of rides by each type of bike
select rideable_type,member_casual,count(ride_id) as Total_Rides
from cycle
group by rideable_type,member_casual;  

--Avg ride length of rides 
SELECT AVG(ride_length) AS Average_Ride_Length 
FROM cycle;

--Avg ride length by customer type
SELECT member_casual,AVG(ride_length) AS Average_Ride_Length
FROM cycle
group by member_casual;
            
--Total number of rides of by Month
select datename(mm,started_date) as Month ,count(ride_id) as Total_Rides
from cycle
group by datename(mm,started_date)
order by Total_Rides desc;

--Number of rides of members by Month
select datename(mm,started_date) as Month ,count(ride_id) as Total_Rides
from cycle
where member_casual='member'
group by datename(mm,started_date)
order by Total_Rides desc;

--Number of rides of members by Month
select datename(mm,started_date) as Month ,count(ride_id) as Total_Rides
from cycle
where member_casual='casual'
group by datename(mm,started_date)
order by Total_Rides desc;

--Number of rides by month and season 
Select Distinct DATENAME(mm,started_date) as Month, COUNT(ride_id) as Total_Rides, member_casual,
(Case
	When DATENAME(mm,started_date) like 'January' or
	DATENAME(mm,started_date) like 'February' or 
	DATENAME(mm,started_date) like 'December' 
	then 'Winter'
	When DATENAME(mm,started_date) like 'March' or
	DATENAME(mm,started_date) like 'April' or 
	DATENAME(mm,started_date) like 'May' then 'Spring'
	When DATENAME(mm,started_date) like 'June' or
	DATENAME(mm,started_date) like 'July' or 
	DATENAME(mm,started_date) like 'August' 
	then 'Summer'
	When DATENAME(mm,started_date) like 'September' or
	DATENAME(mm,started_date) like 'October' or 
	DATENAME(mm,started_date) like 'November' 
	then 'Autumn'
end) as season
From cycle
Group by DATENAME(mm,started_date), member_casual,
(Case
	When DATENAME(mm,started_date) like 'January' or
	DATENAME(mm,started_date) like 'February' or 
	DATENAME(mm,started_date) like 'December' 
	then 'Winter'
	When DATENAME(mm,started_date) like 'March' or
	DATENAME(mm,started_date) like 'April' or 
	DATENAME(mm,started_date) like 'May' 
	then 'Spring'
	When DATENAME(mm,started_date) like 'June' or
	DATENAME(mm,started_date) like 'July' or 
	DATENAME(mm,started_date) like 'August' 
	then 'Summer'
	When DATENAME(mm,started_date) like 'September' or
	DATENAME(mm,started_date) like 'October' or 
	DATENAME(mm,started_date) like 'November' then 'Autumn'
end)
order by Total_Rides desc;

--Number of rides of members by Day
select distinct datename(dw,started_date) AS Day, count(ride_id) as Total_Rides
from cycle
where member_casual='member'
group by datename(dw,started_date)
order by Total_Rides desc;

--Number of rides of casuals by Day
select distinct datename(dw,started_date) AS Day, count(ride_id) as Total_Rides
from cycle
where member_casual='casual'
group by datename(dw,started_date)
order by Total_Rides desc;

--Total number of rides by day of week
Select Distinct Datename(dw,started_date) as Day, COUNT(ride_id) as Total_Rides, member_casual,
(Case
	When Cast(started_time as time) >= '06:00:00' and Cast(started_time as time) < '12:00:00' Then 'Morning'
	When Cast(started_time as time) >= '12:00:00' and Cast(started_time as time) < '17:00:00' Then 'Afternoon'
	When Cast(started_time as time) >= '17:00:00' and Cast(started_time as time) < '20:00:00' Then 'Evening'
	Else 'Night'
End) as time_of_day
From cycle
Group by Datename(dw,started_date),member_casual,
(Case
	When Cast(started_time as time) >= '06:00:00' and Cast(started_time as time) < '12:00:00' Then 'Morning'
	When Cast(started_time as time) >= '12:00:00' and Cast(started_time as time) < '17:00:00' Then 'Afternoon'
	When Cast(started_time as time) >= '17:00:00' and Cast(started_time as time) < '20:00:00' Then 'Evening'
	Else 'Night'
End) 
Order by Day;

-- Number of rides: time of the day
Select DATEPART(HOUR, started_time) as Hour, COUNT(ride_id) as Total_rides, member_casual
From cycle
Group by DATEPART(HOUR, started_time), member_casual
Order by Total_rides desc,member_casual desc;

--Number of rides by month and time of the day(Morning, Afternoon, Evening, Night) and avg time
Select Distinct DATENAME(mm,started_date) as month,
(Case
	When Cast(started_time as time) >= '06:00:00' and Cast(started_time as time) < '12:00:00' Then 'Morning'
	When Cast(started_time as time) >= '12:00:00' and Cast(started_time as time) < '17:00:00' Then 'Afternoon'
	When Cast(started_time as time) >= '17:00:00' and Cast(started_time as time) < '20:00:00' Then 'Evening'
	Else 'Night'
End)  as time_of_day, COUNT(ride_id) as Total_Rides,AVG(ride_length) AS Average_Ride_Length,member_casual
From cycle
Group by (Case
	When Cast(started_time as time) >= '06:00:00' and Cast(started_time as time) < '12:00:00' Then 'Morning'
	When Cast(started_time as time) >= '12:00:00' and Cast(started_time as time) < '17:00:00' Then 'Afternoon'
	When Cast(started_time as time) >= '17:00:00' and Cast(started_time as time) < '20:00:00' Then 'Evening'
	Else 'Night'
End), DATENAME(mm,started_date), member_casual
Order by month,Total_Rides desc;

--average ride_length for users by day_of_week
Select datename(dw,started_date) AS Day, AVG(ride_length) AS Average_Ride_Length
From cycle
Group by datename(dw,started_date)
order by Average_Ride_Length desc;

-- Number of rides: time of the day
Select DATEPART(HOUR, started_time) as Hour, COUNT(ride_id) AS Total_Rides, member_casual
From cycle
Group by DATEPART(HOUR, started_time), member_casual
Order by Hour;
