-- Data Cleaning 

-- Create a copy of the original dataset
CREATE TABLE trip_data_cleaned_staging
LIKE `2024-divvy-tripdata`
;

INSERT INTO trip_data_cleaned_staging
SELECT * 
FROM `2024-divvy-tripdata`
;

-- 2. Convert datetime columns from text to actual DATETIME format
UPDATE  trip_data_cleaned_staging
SET started_at = STR_TO_DATE(SUBSTRING_INDEX(started_at, '.', 1), '%Y-%m-%d %H:%i:%s'),
	ended_at = STR_TO_DATE(SUBSTRING_INDEX(ended_at, '.', 1), '%Y-%m-%d %H:%i:%s')
;

ALTER TABLE trip_data_cleaned_staging
MODIFY COLUMN started_at DATETIME,
MODIFY COLUMN ended_at DATETIME
;				

-- 3. Remove rows where there are NULL or empty values in critical columns
DELETE FROM trip_data_cleaned_staging
WHERE started_at IS NULL OR	
	  ended_at IS NULL OR 
      start_station_name IS NULL OR 
	  end_station_name IS NULL OR
      member_casual IS NULL
;

-- 4. Remove duplicates
CREATE TABLE trip_data_2024_cleaned (
  `ride_id` text,
  `rideable_type` text,
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `start_station_name` text,
  `start_station_id` text,
  `end_station_name` text,
  `end_station_id` text,
  `start_lat` double DEFAULT NULL,
  `start_lng` double DEFAULT NULL,
  `end_lat` double DEFAULT NULL,
  `end_lng` double DEFAULT NULL,
  `member_casual` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO trip_data_2024_cleaned
SELECT 
	  ride_id,
	  rideable_type,
	  started_at,
	  ended_at,
	  start_station_name,
	  start_station_id,
	  end_station_name,
	  end_station_id,
	  start_lat,
	  start_lng,
	  end_lat,
	  end_lng,
	  member_casual
FROM (SELECT *,
			ROW_NUMBER() OVER(
				PARTITION BY ride_id, rideable_type,
							started_at, ended_at, 
                            start_station_name, end_station_name,
							member_casual
				) AS row_num
		FROM trip_data_cleaned_staging
) AS ranked_data
WHERE row_num = 1
;

-- 5. Handle unrealistic ride durations (e.g., negative or zero durations)
DELETE FROM trip_data_2024_cleaned
WHERE TIMESTAMPDIFF(MINUTE, started_at, ended_at) <= 0
;

-- 6. Fill NULL or empty values in non-critical columns (e.g., station names) with a placeholder
UPDATE trip_data_2024_cleaned
SET start_station_name = 'Unknown'
WHERE start_station_name = '' 
;

UPDATE trip_data_2024_cleaned
SET end_station_name = 'Unknown'
WHERE end_station_name = '' 
;

-- 7. Ensure latitudes and longitudes are valid (replace with NULL for any invalid data)
UPDATE trip_data_2024_cleaned
SET
    start_lat = CASE
                  WHEN start_lat IS NOT NULL AND (start_lat < -90 OR start_lat > 90) THEN NULL
                  ELSE start_lat
                END,
    start_lng = CASE
                  WHEN start_lng IS NOT NULL AND (start_lng < -180 OR start_lng > 180) THEN NULL
                  ELSE start_lng
                END,
    end_lat = CASE
                WHEN end_lat IS NOT NULL AND (end_lat < -90 OR end_lat > 90) THEN NULL
                ELSE end_lat
              END,
    end_lng = CASE
                WHEN end_lng IS NOT NULL AND (end_lng < -180 OR end_lng > 180) THEN NULL
                ELSE end_lng
              END
;

-- 8. Check and verify the data is cleaned
SELECT COUNT(*) AS total_rows_cleaned
FROM trip_data_2024_cleaned;

-- 9. (Optional) Check that data types for all columns are correct
DESCRIBE trip_data_2024_cleaned;


