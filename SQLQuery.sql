 ---Creating a database containing Cyclistic Bike share monthly rides from 2022-03 to 2023:02
Create Database Bike_Trips

---Confirming spreadsheets were uploaded successfully by quering a few of them.
Select *
FRom Bike_Trips.dbo.[2022-03_tripdata]

---Monthly rides exists in different tables ranging from March, 2022 to February, 2023, to continue i need
---to combine all monthly tables into one table using SELECT INTO and UNION ALL.

SELECT * INTO Bike_Trips.dbo.[cyclistic_bike_trips] 
FROM 
(SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type 
FROM Bike_Trips.dbo.[2022-03_tripdata]
UNION ALL
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-04_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM  Bike_Trips.dbo.[2022-05_tripdata] 
UNION ALL
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-06_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-07_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-08_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-09_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-10_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-11_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2022-12_tripdata]
UNION ALL
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2023-01_tripdata]
UNION ALL 
SELECT ride_id, bike_type, started_at, ended_at, ride_length, day_of_week, start_station_name, end_station_name, user_type
FROM Bike_Trips.dbo.[2023-02_tripdata]
) AS rides

--Confirming the new table contains all rows from the individual table.
SELECT DISTINCT COUNT (*) AS Total 
FROM Bike_Trips.dbo.[cyclistic_bike_trips] 


--Creating a new table with more variables added using CASE statament to help with analysis. I left out ride_length since i cant average it.

SELECT * INTO Bike_Trips.dbo.[new_cyclistic_trips]
FROM 
(SELECT ride_id,
bike_type,
user_type,
started_at, 
ended_at,
day_of_week, 
DATEPART("HOUR", started_at) AS hour,  
DATEDIFF(MINUTE, started_at,ended_at) AS ride_duration,

CASE 
    WHEN MONTH(Started_at) = 1 THEN 'January'
	WHEN MONTH(Started_at) = 2 THEN 'February'
	WHEN MONTH(Started_at) = 3 THEN 'March'
	WHEN MONTH(Started_at) = 4 THEN 'April'
	WHEN MONTH(Started_at) = 5 THEN 'May'
	WHEN MONTH(Started_at) = 6 THEN 'June'
	WHEN MONTH(Started_at) = 7 THEN 'July'
	WHEN MONTH(Started_at) = 8 THEN 'August'
	WHEN MONTH(Started_at) = 9 THEN 'September'
	WHEN MONTH(Started_at) = 10 THEN 'October'
	WHEN MONTH(Started_at) = 11 THEN 'November'
	WHEN MONTH(Started_at) = 12 THEN 'December'
END AS month,
    
CASE
   WHEN(day_of_week) = 1 THEN 'Sunday'
   WHEN(day_of_week) = 2 THEN 'Monday'
   WHEN(day_of_week) = 3 THEN 'Tuesday'
   WHEN(day_of_week) = 4 THEN 'Wednesday'
   WHEN(day_of_week) = 5 THEN 'Thursday'
   WHEN(day_of_week) = 6 THEN 'Friday'
   WHEN(day_of_week) = 7 THEN 'Saturday'
   END AS day,
CASE 
     WHEN Month(started_at) IN (12,1,2) THEN 'Winter'
	 WHEN Month(started_at) IN (3,4,5) THEN 'Spring'
	 WHEN Month(started_at) IN (6,7,8) THEN 'Summer'
	 WHEN Month(started_at) IN (9,10,11) THEN  'Autumn'
	 END AS season,
CASE 
    WHEN DATEPART("HOUR", started_at) IN (0,1,2,3,4,5) THEN 'Early Morning'
	WHEN DATEPART("HOUR", started_at) IN (6,7,8,9,10,11) THEN 'Morning'
	WHEN DATEPART("HOUR", started_at) IN (12,13,14,15,16) THEN 'Afternoon'
	WHEN DATEPART("HOUR", started_at) IN (17,18,19,20,21,22,23) THEN 'Evening'
	END AS time_of_day
FROM Bike_Trips.dbo.[cyclistic_bike_trips]
) AS rides

--Confirm creation of a new table.
SELECT *
FROM Bike_Trips.dbo.[new_cyclistic_trips]
ORDER By started_at ASC

--Total rides taken from March,2022 to February, 2023.
SELECT 
DISTINCT COUNT(*) AS total_rides
FROM Bike_Trips.dbo.[new_cyclistic_trips]
WHERE ride_id IS NOT NULL 

--Total rides by the two catergories of Cyclistic user types. 
SELECT
user_type,
COUNT(*) AS total_rides
FROM Bike_Trips.dbo.new_cyclistic_trips 
GROUP BY user_type 
   

--Distribution of rides according to bike types.
SELECT 
user_type,
bike_type,
COUNT(bike_type) AS bikes
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY user_type, bike_type 
ORDER BY bikes DESC

--Total rides by season
SELECT 
season,
COUNT(season) AS total_rides
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY season
ORDER BY COUNT(season) DESC 

--Total rides by users across the four seasons
SELECT 
user_type,
season,
COUNT(season) AS total_rides
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY user_type, season 
ORDER BY user_type, season 


--Total bike rides by Month
SELECT
month(started_at) AS month_numb,
month,
user_type,
COUNT(month) AS total_rides
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY month, month(started_at), user_type
ORDER BY month(started_at) ASC


--Total bike rides per day
SELECT 
day_of_week,
day,
user_type,
COUNT(day) AS total 
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY day_of_week, day, user_type 
ORDER BY day_of_week 

--Distribution of rides by hour
SELECT 
hour,
user_type,
COUNT(hour) AS rides_per_hour
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY hour, user_type 
ORDER BY hour ASC 


--Total rides by time of the day 
SELECT 
time_of_day,
user_type,
COUNT(time_of_day) AS rides_per_hour
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY time_of_day, user_type 
ORDER BY CASE when time_of_day = 'Early Morning' THEN 1
              WHEN time_of_day =  'Morning' THEN 2
			  WHEN time_of_day =  'Afternoon' THEN 3
              ELSE 4
END ASC


--Average ride duration 
SELECT 
CAST(AVG(CAST(ride_duration AS DECIMAL(10,2))) AS DEcimal(10,2)) AS avg_ride_duration_mins
FROM Bike_Trips.dbo.[new_cyclistic_trips]


--Average ride duration by day
SELECT 
day_of_week,
day,
user_type,
CASE
WHEN (day) IN ('Friday', 'Saturday', 'Sunday') THEN 'Weekend'
WHEN (day) IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday') THEN 'Weekday'
END AS week,
CAST(AVG(CAST(ride_duration AS DECIMAL(10,2))) AS DEcimal(10,2)) AS avg_ride_duration_mins
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY day_of_week, day, user_type 
ORDER BY day_of_week ASC 


--Average ride duration by month
SELECT 
month(started_at) AS month_numb,
month,
season,
user_type,
CAST(AVG(CAST(ride_duration AS DECIMAL(10,2))) AS DEcimal(10,2)) AS avg_ride_duration_mins
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY month, month(started_at), season, user_type
ORDER BY month(started_at) ASC


--Average ride duration by user type. 
SELECT 
CAST(AVG(CAST(ride_duration AS DECIMAL(10,2))) AS DEcimal(10,2)) AS member_avg_ride_duration_mins
FROM Bike_Trips.dbo.[new_cyclistic_trips]
WHERE user_type = 'member'
(SELECT 
CAST(AVG(CAST(ride_duration AS DECIMAL(10,2))) AS DEcimal(10,2)) AS casual_avg_ride_duration_mins
FROM Bike_Trips.dbo.[new_cyclistic_trips]
WHERE user_type = 'casual')


--Average ride duration by time of the day. 
SELECT
time_of_day,
user_type,
CAST(AVG(CAST(ride_duration AS DECIMAL(10,2))) AS DEcimal(10,2)) AS avg_ride_duration_mins
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY time_of_day, user_type
ORDER BY CASE when time_of_day = 'Early Morning' THEN 1
              WHEN time_of_day =  'Morning' THEN 2
			  WHEN time_of_day =  'Afternoon' THEN 3
              ELSE 4
END ASC


--Average ride duration by bike type.
SELECT
bike_type,
user_type,
CAST(AVG(CAST(ride_duration AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_ride_duration_mins
FROM Bike_Trips.dbo.[new_cyclistic_trips]
GROUP BY bike_type, user_type  
ORDER BY bike_type 



