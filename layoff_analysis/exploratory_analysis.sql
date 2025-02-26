-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2
;

SELECT 
	MAX(total_laid_off)
FROM layoffs_staging2
;

-- Looking at Percentage to see how big these layoffs were
SELECT 
	MAX(total_laid_off),
	MAX(percentage_laid_off)
FROM layoffs_staging2
;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funds_raised_millions we can see how big some of these companies were
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
;

-- Companies with the biggest single Layoff
SELECT 
	company, 
    MAX(total_laid_off) AS largest_layoff
FROM layoffs_staging2
GROUP BY company
ORDER BY largest_layoff DESC
LIMIT 5;

-- Companies with the most Total Layoffs
SELECT 
	company,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10
;

-- by location
SELECT 
	location,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 10
;

-- this is by Country, total in the past 3 years or in the dataset
SELECT 
	country,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC
;

-- by year 
SELECT 
	YEAR(`date`),
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1
;

-- by industry 
SELECT 
	industry,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC
;

-- by stage
SELECT 
	stage,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC
;

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. 
WITH company_year AS
(
SELECT 
	company,
    YEAR(`date`) AS years,
	SUM(total_laid_off) AS total_layoffs,
    ROW_NUMBER() OVER(PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC) AS row_num
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, YEAR(`date`)
)
SELECT *
FROM company_year
WHERE row_num <= 3
;

-- Rolling Total of Layoffs Per Month
WITH date_cte AS 
(
SELECT 
	SUBSTRING(`date`, 1, 7) AS dates,
	SUM(total_laid_off) AS total_lay_offs
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY dates
ORDER BY dates, total_lay_offs DESC
)
SELECT 
	dates,
    total_lay_offs,
    SUM(total_lay_offs) OVER(ORDER BY dates) AS rolling_total_layoffs
FROM date_cte
;
