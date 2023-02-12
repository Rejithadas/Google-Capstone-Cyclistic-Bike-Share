CREATE VIEW dbo.cycle AS
WITH cycle AS
(
SELECT [ride_id]
      ,[rideable_type]
      ,[member_casual],
	  CAST(started_at AS DATE) AS started_date,
	  CAST(started_at AS DATE) AS ended_date,
	  CAST(started_at AS TIME) AS started_time,
	  CAST(ended_at AS TIME) AS ended_time
FROM Bike
)
SELECT * FROM cycle;

ALTER VIEW dbo.cycle AS
WITH cycle AS
(
SELECT [ride_id]
      ,[rideable_type]
      ,[member_casual],
	  CAST(started_at AS DATE) AS started_date,
	  CAST(started_at AS DATE) AS ended_date,
	  LEFT(CAST(started_at AS TIME),8) AS started_time,
	  LEFT( CAST(ended_at AS TIME),8) AS ended_time
FROM Bike
)
SELECT *,DATEDIFF(MINUTE,started_time,ended_time) AS ride_length FROM cycle
WHERE DATEDIFF(MINUTE,started_time,ended_time)>0;

--CYCLISTIC BIKE SHARE DATA OVERVIEW

--The view of Final data 
SELECT * FROM cycle;

--Total number of rides
SELECT COUNT(ride_id) FROM cycle;

-- Average ride length
SELECT AVG(ride_length) FROM cycle;

--Total number of rides based on user type
SELECT member_casual,COUNT(ride_id) 
FROM cycle;

--Total number of rides based on bike type
SELECT rideable_type,COUNT(ride_id) AS Total_rides
FROM cycle;

--Total number of rides by weekday
SELECT DATENAME(DW,started_date) AS Week_Day,COUNT(ride_id) AS Total_rides 
FROM cycle
GROUP BY DATENAME(DW,started_date)
ORDER BY Total_rides DESC;

--Total number of rides by month
SELECT DATENAME(MM,started_date) AS Month, COUNT(ride_id) AS Total_rides
FROM cycle 
GROUP BY DATENAME(MM,started_date)
ORDER BY Total_rides DESC;

--Total number of rides by season
SELECT 
(CASE  
	WHEN DATENAME(MM,started_date) LIKE 'January' OR
	DATENAME(MM,started_date) LIKE 'February' OR 
	DATENAME(MM,started_date) LIKE 'December' 
	THEN 'Winter'
	WHEN DATENAME(MM,started_date) LIKE 'March' OR
	DATENAME(MM,started_date) LIKE 'April' OR 
	DATENAME(MM,started_date) LIKE 'May' then 'Spring'
	WHEN DATENAME(MM,started_date) LIKE 'June' OR
	DATENAME(MM,started_date) LIKE 'July' OR 
	DATENAME(MM,started_date) LIKE 'August' 
	then 'Summer'
	WHEN DATENAME(MM,started_date) LIKE 'September' OR
	DATENAME(MM,started_date) LIKE 'October' OR 
	DATENAME(MM,started_date) LIKE 'November' 
	THEN 'Autumn'
END) AS Season, COUNT(ride_id) AS Total_Rides
FROM cycle
GROUP BY 
(CASE  
	WHEN DATENAME(MM,started_date) LIKE 'January' OR
	DATENAME(MM,started_date) LIKE 'February' OR 
	DATENAME(MM,started_date) LIKE 'December' 
	THEN 'Winter'
	WHEN DATENAME(MM,started_date) LIKE 'March' OR
	DATENAME(MM,started_date) LIKE 'April' OR 
	DATENAME(MM,started_date) LIKE 'May' then 'Spring'
	WHEN DATENAME(MM,started_date) LIKE 'June' OR
	DATENAME(MM,started_date) LIKE 'July' OR 
	DATENAME(MM,started_date) LIKE 'August' 
	then 'Summer'
	WHEN DATENAME(MM,started_date) LIKE 'September' OR
	DATENAME(MM,started_date) LIKE 'October' OR 
	DATENAME(MM,started_date) LIKE 'November' 
	THEN 'Autumn'
END)
ORDER BY Total_Rides DESC;

--Total number of rides by time 
SELECT 
(CASE
	WHEN CAST(started_time AS TIME) >= '06:00:00' AND CAST(started_time AS TIME) < '12:00:00' THEN 'Morning'
	WHEN CAST(started_time AS TIME) >= '12:00:00' AND CAST(started_time AS TIME) < '17:00:00' THEN 'Afternoon'
	WHEN CAST(started_time AS TIME) >= '17:00:00' AND CAST(started_time AS TIME) < '20:00:00' THEN 'Evening'
	ELSE 'Night'
END) AS time_of_day,COUNT(ride_id) AS Total_Rides
FROM cycle
GROUP BY 
(CASE
	WHEN CAST(started_time AS TIME) >= '06:00:00' AND CAST(started_time AS TIME) < '12:00:00' THEN 'Morning'
	WHEN CAST(started_time AS TIME) >= '12:00:00' AND CAST(started_time AS TIME) < '17:00:00' THEN 'Afternoon'
	WHEN CAST(started_time AS TIME) >= '17:00:00' AND CAST(started_time AS TIME) < '20:00:00' THEN 'Evening'
	ELSE 'Night'
END)
ORDER BY Total_Rides DESC;

--Total number of rides by time of day
Select DATEPART(HOUR, started_time) as Hour, COUNT(ride_id) AS Total_Rides
From cycle
Group by DATEPART(HOUR, started_time)
Order by Total_Rides DESC;

-- CASUAL RIDERS DATA ANALYSIS 

--Total number of rides by bike type of casual riders
SELECT rideable_type,COUNT(ride_id) AS Total_Rides
FROM cycle
WHERE member_casual='casual'
GROUP BY rideable_type
ORDER BY Total_Rides DESC;

--Total number of rides by weekday of casual riders
SELECT DATENAME(DW,started_date) AS Week_Day,COUNT(ride_id) AS Total_rides 
FROM cycle
WHERE member_casual='casual'
GROUP BY DATENAME(DW,started_date)
ORDER BY Total_rides DESC;

--Total number of rides by month of casual riders
SELECT DATENAME(MM,started_date) AS Month, COUNT(ride_id) AS Total_rides
FROM cycle 
WHERE member_casual='casual'
GROUP BY DATENAME(MM,started_date)
ORDER BY Total_rides DESC;

--Total number of rides by season of casual riders
SELECT 
(CASE  
	WHEN DATENAME(MM,started_date) LIKE 'January' OR
	DATENAME(MM,started_date) LIKE 'February' OR 
	DATENAME(MM,started_date) LIKE 'December' 
	THEN 'Winter'
	WHEN DATENAME(MM,started_date) LIKE 'March' OR
	DATENAME(MM,started_date) LIKE 'April' OR 
	DATENAME(MM,started_date) LIKE 'May' then 'Spring'
	WHEN DATENAME(MM,started_date) LIKE 'June' OR
	DATENAME(MM,started_date) LIKE 'July' OR 
	DATENAME(MM,started_date) LIKE 'August' 
	then 'Summer'
	WHEN DATENAME(MM,started_date) LIKE 'September' OR
	DATENAME(MM,started_date) LIKE 'October' OR 
	DATENAME(MM,started_date) LIKE 'November' 
	THEN 'Autumn'
END) AS Season, COUNT(ride_id) AS Total_Rides
FROM cycle
WHERE member_casual='casual'
GROUP BY 
(CASE  
	WHEN DATENAME(MM,started_date) LIKE 'January' OR
	DATENAME(MM,started_date) LIKE 'February' OR 
	DATENAME(MM,started_date) LIKE 'December' 
	THEN 'Winter'
	WHEN DATENAME(MM,started_date) LIKE 'March' OR
	DATENAME(MM,started_date) LIKE 'April' OR 
	DATENAME(MM,started_date) LIKE 'May' then 'Spring'
	WHEN DATENAME(MM,started_date) LIKE 'June' OR
	DATENAME(MM,started_date) LIKE 'July' OR 
	DATENAME(MM,started_date) LIKE 'August' 
	then 'Summer'
	WHEN DATENAME(MM,started_date) LIKE 'September' OR
	DATENAME(MM,started_date) LIKE 'October' OR 
	DATENAME(MM,started_date) LIKE 'November' 
	THEN 'Autumn'
END)
ORDER BY Total_Rides DESC;

--Total number of rides by time of day of casual riders
SELECT 
(CASE
	WHEN CAST(started_time AS TIME) >= '06:00:00' AND CAST(started_time AS TIME) < '12:00:00' THEN 'Morning'
	WHEN CAST(started_time AS TIME) >= '12:00:00' AND CAST(started_time AS TIME) < '17:00:00' THEN 'Afternoon'
	WHEN CAST(started_time AS TIME) >= '17:00:00' AND CAST(started_time AS TIME) < '20:00:00' THEN 'Evening'
	ELSE 'Night'
END) AS time_of_day,COUNT(ride_id) AS Total_Rides
FROM cycle
WHERE member_casual='casual'
GROUP BY 
(CASE
	WHEN CAST(started_time AS TIME) >= '06:00:00' AND CAST(started_time AS TIME) < '12:00:00' THEN 'Morning'
	WHEN CAST(started_time AS TIME) >= '12:00:00' AND CAST(started_time AS TIME) < '17:00:00' THEN 'Afternoon'
	WHEN CAST(started_time AS TIME) >= '17:00:00' AND CAST(started_time AS TIME) < '20:00:00' THEN 'Evening'
	ELSE 'Night'
END)
ORDER BY Total_Rides DESC;

--Total number of rides by time of casual riders
Select DATEPART(HOUR, started_time) as Hour, COUNT(ride_id) AS Total_Rides
From cycle
WHERE member_casual='casual'
Group by DATEPART(HOUR, started_time)
Order by Total_Rides DESC;

--MEMBER RIDERS DATA ANALYSIS 

--Total number of rides by bike type of member riders
SELECT rideable_type,COUNT(ride_id) AS Total_Rides
FROM cycle
WHERE member_casual='member'
GROUP BY rideable_type
ORDER BY Total_Rides;

--Total number of rides by weekday of member riders
SELECT DATENAME(DW,started_date) AS Week_Day,COUNT(ride_id) AS Total_rides 
FROM cycle
WHERE member_casual='member'
GROUP BY DATENAME(DW,started_date)
ORDER BY Total_rides DESC;

--Total number of rides by month of member riders
SELECT DATENAME(MM,started_date) AS Month, COUNT(ride_id) AS Total_rides
FROM cycle 
WHERE member_casual='member'
GROUP BY DATENAME(MM,started_date)
ORDER BY Total_rides DESC;

--Total number of rides by season of member riders
SELECT 
(CASE  
	WHEN DATENAME(MM,started_date) LIKE 'January' OR
	DATENAME(MM,started_date) LIKE 'February' OR 
	DATENAME(MM,started_date) LIKE 'December' 
	THEN 'Winter'
	WHEN DATENAME(MM,started_date) LIKE 'March' OR
	DATENAME(MM,started_date) LIKE 'April' OR 
	DATENAME(MM,started_date) LIKE 'May' then 'Spring'
	WHEN DATENAME(MM,started_date) LIKE 'June' OR
	DATENAME(MM,started_date) LIKE 'July' OR 
	DATENAME(MM,started_date) LIKE 'August' 
	then 'Summer'
	WHEN DATENAME(MM,started_date) LIKE 'September' OR
	DATENAME(MM,started_date) LIKE 'October' OR 
	DATENAME(MM,started_date) LIKE 'November' 
	THEN 'Autumn'
END) AS Season, COUNT(ride_id) AS Total_Rides
FROM cycle
WHERE member_casual='member'
GROUP BY 
(CASE  
	WHEN DATENAME(MM,started_date) LIKE 'January' OR
	DATENAME(MM,started_date) LIKE 'February' OR 
	DATENAME(MM,started_date) LIKE 'December' 
	THEN 'Winter'
	WHEN DATENAME(MM,started_date) LIKE 'March' OR
	DATENAME(MM,started_date) LIKE 'April' OR 
	DATENAME(MM,started_date) LIKE 'May' then 'Spring'
	WHEN DATENAME(MM,started_date) LIKE 'June' OR
	DATENAME(MM,started_date) LIKE 'July' OR 
	DATENAME(MM,started_date) LIKE 'August' 
	then 'Summer'
	WHEN DATENAME(MM,started_date) LIKE 'September' OR
	DATENAME(MM,started_date) LIKE 'October' OR 
	DATENAME(MM,started_date) LIKE 'November' 
	THEN 'Autumn'
END)
ORDER BY Total_Rides DESC;

--Total number of rides by timeof day  of member riders
SELECT 
(CASE
	WHEN CAST(started_time AS TIME) >= '06:00:00' AND CAST(started_time AS TIME) < '12:00:00' THEN 'Morning'
	WHEN CAST(started_time AS TIME) >= '12:00:00' AND CAST(started_time AS TIME) < '17:00:00' THEN 'Afternoon'
	WHEN CAST(started_time AS TIME) >= '17:00:00' AND CAST(started_time AS TIME) < '20:00:00' THEN 'Evening'
	ELSE 'Night'
END) AS time_of_day,COUNT(ride_id) AS Total_Rides
FROM cycle
WHERE member_casual='member'
GROUP BY 
(CASE
	WHEN CAST(started_time AS TIME) >= '06:00:00' AND CAST(started_time AS TIME) < '12:00:00' THEN 'Morning'
	WHEN CAST(started_time AS TIME) >= '12:00:00' AND CAST(started_time AS TIME) < '17:00:00' THEN 'Afternoon'
	WHEN CAST(started_time AS TIME) >= '17:00:00' AND CAST(started_time AS TIME) < '20:00:00' THEN 'Evening'
	ELSE 'Night'
END)
ORDER BY Total_Rides DESC;

--Total number of rides by time of member riders
Select DATEPART(HOUR, started_time) as Hour, COUNT(ride_id) AS Total_Rides
From cycle
WHERE member_casual='member'
Group by DATEPART(HOUR, started_time)
Order by Total_Rides DESC;

