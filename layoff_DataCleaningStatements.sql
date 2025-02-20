-- Data Cleaning

SELECT *
FROM layoffs
;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging
;

INSERT layoffs_staging
SELECT *
FROM layoffs
;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging 
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1 	
;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper'
;

CREATE TABLE `layoffs_staging2` (
  `company` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `location` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `industry` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `date` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `stage` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `country` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging 
;

DELETE
FROM layoffs_staging2
WHERE row_num > 1
;

SELECT *
FROM layoffs_staging2
;

-- Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET company = TRIM(company)
;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1
;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1
;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1
;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE COUNTRY LIKE 'United States%'
;

SELECT `date`
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` IS NOT NULL AND `date` != ''
;

UPDATE layoffs_staging2
SET `date` = NULL
WHERE `date` = '';

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND (percentage_laid_off = '' OR percentage_laid_off IS NULL)
;

SELECT *
FROM layoffs_staging2
WHERE industry = '' OR industry IS NULL
;

SELECT company, 
industry
FROM layoffs_staging2
WHERE company = 'Airbnb'
;

SELECT * 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company AND
   t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '') AND
      (t2.industry IS NOT NULL AND t2.industry != '')
;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company AND
   t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '') AND
      (t2.industry IS NOT NULL AND t2.industry != '')
;

SELECT * 
FROM layoffs_staging2
WHERE (total_laid_off IS NULL  OR total_laid_off = '')
AND (percentage_laid_off = '' OR percentage_laid_off IS NULL)
;

SELECT * 
FROM layoffs_staging2
;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

DELETE 
FROM layoffs_staging2
WHERE (total_laid_off IS NULL  OR total_laid_off = '')
AND (percentage_laid_off = '' OR percentage_laid_off IS NULL)
;
