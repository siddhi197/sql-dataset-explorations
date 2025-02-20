-- Step 1: Segment the Data by Rider Type (Annual Members vs. Casual Riders)
-- We will examine the behavior of annual members and casual riders separately.

-- 1.1. Get the total number of rides for each rider type
SELECT
	member_casual,
	COUNT(*) AS total_trips
FROM trip_data_2024_cleaned
GROUP BY member_casual
;

-- 1.2. Compare the average ride duration for each rider type
SELECT 
	member_casual,
    AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)) AS avg_ride_duration_minutes
FROM trip_data_2024_cleaned
GROUP BY member_casual
;

-- Step 2: Analyze the Usage Patterns by Day of the Week for Each Rider Type
-- This will help us identify if there is any pattern in the day of the week when annual members and casual riders use bikes.

-- 2.1. Compare the number of rides for each day of the week by rider type
SELECT 
    member_casual,
    DAYNAME(started_at) AS day_of_week,
    COUNT(*) AS total_rides
FROM trip_data_2024_cleaned
GROUP BY member_casual, day_of_week
ORDER BY member_casual, 
         FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
;

-- Step 3: Compare Ride Frequency by Month for Each Rider Type
-- This will help understand how usage changes throughout the year.

-- 3.1. Get the total rides per month for each rider type
SELECT 
	member_casual,
    MONTHNAME(started_at) AS trip_month,
    COUNT(*)
FROM trip_data_2024_cleaned
GROUP BY member_casual, trip_month, MONTH(started_at)
ORDER BY member_casual, 
		MONTH(started_at)
;

-- Step 4: Analyze Popular Stations for Each Member Type
-- This will give insight into which stations are popular among each group of riders.

-- 4.1. Get the top 10 starting stations for each rider type
WITH popular_start_station_cte AS
(
SELECT 
	member_casual,
    start_station_name,
    COUNT(*) AS total_trips,
    ROW_NUMBER() OVER(PARTITION BY member_casual ORDER BY COUNT(*) DESC) AS row_num
FROM trip_data_2024_cleaned
WHERE start_station_name != 'Unknown'
GROUP BY member_casual, start_station_name
)
SELECT *
FROM popular_start_station_cte
WHERE row_num <= 10
;

-- 4.2. Get the top 10 ending stations for each rider type
WITH popular_end_station_cte AS
(
SELECT 
	member_casual,
    end_station_name,
    COUNT(*) AS total_trips,
    ROW_NUMBER() OVER(PARTITION BY member_casual ORDER BY COUNT(*) DESC) AS row_num
FROM trip_data_2024_cleaned
WHERE end_station_name != 'Unknown'
GROUP BY member_casual, end_station_name
)
SELECT *
FROM popular_end_station_cte
WHERE row_num <= 10
;


-- Step 5: Compare Ride Duration and Frequency for Weekdays vs. Weekends
-- We hypothesize that casual riders may use bikes more on weekends, while annual members may use them more on weekdays.

-- 5.1. Calculate the average ride duration for weekdays vs. weekends for each rider type
SELECT 
	member_casual,
	CASE WHEN DAYOFWEEK(started_at) IN (1, 7) THEN 'Weekend'
		 ELSE 'Weekday'
	END AS day_type,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)), 0) AS avg_duration_minutes
FROM trip_data_2024_cleaned
GROUP BY member_casual, day_type
;

-- 5.2. Calculate the number of rides for weekdays vs. weekends for each rider type
SELECT 
    member_casual,
    CASE 
        WHEN DAYOFWEEK(started_at) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_rides
FROM trip_data_2024_cleaned
GROUP BY member_casual, day_type
;

-- Step 6: Identify Any Seasonal Patterns
-- Investigating if casual riders have a different usage pattern in different seasons compared to annual members.

-- 6.1. Compare the number of rides in different seasons (Spring, Summer, Fall, Winter) for each rider type
SELECT 
	member_casual,
    CASE 
		WHEN MONTH(started_at) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(started_at) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(started_at) IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
    END AS season,
    COUNT(*) AS total_rides
FROM trip_data_2024_cleaned
GROUP BY member_casual, season
ORDER BY member_casual, 
		 FIELD(season, 'Spring', 'Summer', 'Fall', 'Winter')
;

-- Step 7: Compare Ride Distance

-- 7.1. Calculate the average ride distance for each rider type
SELECT 
	member_casual,
	AVG(
		ST_Distance(
            ST_SRID(POINT(start_lng, start_lat), 4326),
            ST_SRID(POINT(end_lng, end_lat), 4326)
        ) / 1000
    ) AS avg_distance_km
FROM trip_data_2024_cleaned
GROUP BY member_casual
;

-- Step 8: Review Overall Bike Usage Trends Between Annual Members and Casual Riders
-- This will give a summary of the differences observed throughout the analysis.

-- 8.1. Summary of key findings
SELECT 
    member_casual,
    COUNT(*) AS total_rides,
    AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)) AS avg_ride_duration_minutes,
    AVG( 
		ST_Distance(
            ST_SRID(POINT(start_lng, start_lat), 4326),
            ST_SRID(POINT(end_lng, end_lat), 4326)
        ) / 1000
    ) AS avg_distance_km
FROM trip_data_2024_cleaned
GROUP BY member_casual
;






