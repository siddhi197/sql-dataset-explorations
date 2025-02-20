-- Data Exploration : Understand the structure and characteristics of the dataset

-- 1. Describe the structure of the dataset
DESCRIBE `2024-divvy-tripdata`
;

-- 2. Preview the first few rows of the dataset
SELECT * 
FROM `2024-divvy-tripdata`
LIMIT 5
;

-- 3. Total number of records in the dataset
SELECT 
	COUNT(*) AS Total_rows
FROM `2024-divvy-tripdata`
;
-- 730289 total rows found.

-- 4. Check for NULL values in each column
SELECT 
    COUNT(ride_id) AS valid_ride_id,
    COUNT(rideable_type) AS valid_rideable_type,
    COUNT(started_at) AS valid_started_at,
    COUNT(ended_at) AS valid_ended_at,
    COUNT(start_station_name) AS valid_start_station_name,
    COUNT(start_station_id) AS valid_start_station_id,
    COUNT(end_station_name) AS valid_end_station_name,
    COUNT(end_station_id) AS valid_end_station_id,
    COUNT(start_lat) AS valid_start_lat,
    COUNT(start_lng) AS valid_start_lng,
    COUNT(end_lat) AS valid_end_lat,
    COUNT(end_lng) AS valid_end_lng,
    COUNT(member_casual) AS valid_member_casual
FROM `2024-divvy-tripdata`
;
-- Result indicates that all columns have non-NULL values as the counts of each column match the total number of rows (730,289).

-- 5. Check for empty values specifically in the text fields
SELECT 
    COUNT(CASE WHEN ride_id IS NULL OR ride_id = '' THEN 1 END) AS missing_ride_id,
    COUNT(CASE WHEN rideable_type IS NULL OR rideable_type = '' THEN 1 END) AS missing_rideable_type,
    COUNT(CASE WHEN started_at IS NULL OR started_at = '' THEN 1 END) AS missing_started_at,
    COUNT(CASE WHEN ended_at IS NULL OR ended_at = '' THEN 1 END) AS missing_ended_at,
    COUNT(CASE WHEN start_station_name IS NULL OR start_station_name = '' THEN 1 END) AS missing_start_station_name,
    COUNT(CASE WHEN end_station_name IS NULL OR end_station_name = '' THEN 1 END) AS missing_end_station_name,
    COUNT(CASE WHEN member_casual IS  NULL OR member_casual = '' THEN 1 END) AS missing_member_casual
FROM `2024-divvy-tripdata`
;
-- Missing data analysis: 110,831 missing start station names, 120,639 missing end station names, 
-- no missing values for ride_id, rideable_type, started_at, ended_at, and member_casual.


-- 6. Check for distinct values in categorical fields (e.g., rideable_type, member_casual)
SELECT 
	DISTINCT rideable_type
FROM `2024-divvy-tripdata`
;
-- there are three types of bikes: classic_bike, electric_bike and electric_scooter 

SELECT 
	DISTINCT member_casual 
FROM `2024-divvy-tripdata`
;
-- There are only two categories: 'member' and 'casual'

-- 7. Check the distribution of ride duration (e.g., difference between started_at and ended_at)
SELECT 
	MIN(STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s')) AS min_started_at,
	MAX(STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s')) AS max_ended_at,
	AVG(TIMESTAMPDIFF(MINUTE, STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s'), STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s'))) AS avg_ride_duration_minutes
FROM `2024-divvy-tripdata`
;
-- The earliest ride started at '2024-01-01 00:00:53' 
-- The latest ride ended at '2024-12-31 23:59:28' 
-- The average ride duration is 13.64 minutes across all trips in the dataset.

-- 8. Check if there are any rides with unrealistic durations (e.g., negative or zero durations)
SELECT 
	COUNT(*)
FROM `2024-divvy-tripdata`
WHERE 
	TIMESTAMPDIFF(MINUTE, STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s'), STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s')) <= 0
;
-- A total of 19,687 records have unrealistic ride durations, where the difference between start and end times is less than or equal to 0 minutes.

-- 9. Distribution of start and end station names
SELECT 
	start_station_name,
	COUNT(*) AS count_rides_per_start_station,
     -- Get the total rides by counting all rows with either valid start_station_name or valid start_station_id
    (SELECT COUNT(*) 
     FROM `2024-divvy-tripdata`
     WHERE (start_station_name != '' AND start_station_name IS NOT NULL) 
        OR (start_station_id != '' AND start_station_id IS NOT NULL)
    ) AS total_rides,
    -- Count where start_station_name is empty, but start_station_id exists
    COUNT(CASE WHEN start_station_name = '' AND start_station_id IS NOT NULL AND start_station_id != '' THEN 1 END) AS start_station_id_exists
FROM `2024-divvy-tripdata`
WHERE 
	start_station_name != '' AND start_station_name IS NOT NULL -- Exclude empty or NULL start_station_name in the main query
GROUP BY start_station_name
ORDER BY count_rides_per_start_station DESC
;
-- The total number of rides (619,458) is derived from all rows where either start_station_name or start_station_id is non-empty.
-- No records were found where start_station_name is blank or NULL, but a valid start_station_id exists.

SELECT 
	end_station_name,
	COUNT(*) AS count_rides_per_end_station,
     -- Get the total rides by counting all rows with either valid end_station_name or valid end_station_id
    (SELECT COUNT(*) 
     FROM `2024-divvy-tripdata`
     WHERE (end_station_name != '' AND end_station_name IS NOT NULL) 
        OR (end_station_id != '' AND end_station_id IS NOT NULL)
    ) AS total_rides,
    -- Count where start_station_name is empty, but start_station_id exists
    COUNT(CASE WHEN end_station_name = '' AND end_station_id IS NOT NULL AND end_station_id != '' THEN 1 END) AS end_station_id_exists
FROM `2024-divvy-tripdata`
WHERE 
	end_station_name != '' AND end_station_name IS NOT NULL -- Exclude empty or NULL start_station_name in the main query
GROUP BY end_station_name
ORDER BY count_rides_per_end_station DESC
;
-- The total number of rides (609,650) is derived from all rows where either end_station_name or end_station_id is non-empty.
-- No records were found where end_station_name is blank or NULL, but a valid end_station_id exists.

-- 10. Explore geographical data (lat/lng) to check for missing or extreme values
SELECT *
FROM `2024-divvy-tripdata`
WHERE 
	start_lat IS NULL OR start_lat = '' OR 
    end_lat IS NULL OR end_lat = '' OR 
    start_lng IS NULL OR start_lng = '' OR 
    end_lng IS NULL OR end_lng = ''
;
-- This query checks for any rows with NULL or empty values in the geographical fields: start_lat, start_lng, end_lat, and end_lng.
-- However, based on the results, there are **no records** with empty or NULL values in any of these latitude or longitude fields.

-- 11. Distribution of rides per Month 
SELECT 
	MONTHNAME(STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s')) AS month_started,
	COUNT(*) AS trip_count
FROM `2024-divvy-tripdata`
GROUP BY MONTHNAME(STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s')), MONTH(STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s'))
ORDER BY MONTH(STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s'))
;

-- 12. Inverstigate any duplicate values
WITH duplicate_CTE AS 
(
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY ride_id,
					 rideable_type, 
                     STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s'), 
                     STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s'),
					 member_casual
	) AS row_num
FROM `2024-divvy-tripdata`
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1
;
-- Found 2 duplicate rows in the dataset with ride_ids: '7BC67FD33887B3CB' and 'D2D1637EEDB9BA15'.

