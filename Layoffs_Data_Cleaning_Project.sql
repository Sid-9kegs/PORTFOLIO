############################################ LAYOFFS DATA CLEANING PROJECT  #############################################

-- Exploring the Data employee_demographicslayoffs_staging2layoffs_staging2layoffs_staging

SELECT *
FROM layoffs ;

-- Create a working table 

CREATE TABLE layoffs_staging 
LIKE layoffs;

SELECT *
FROM  layoffs_staging
;

-- Populating the working table with data 

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT *
FROM  layoffs_staging
;

##### REMOVING DUPLICATES ######

-- Examining Unique enteries 

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging ;

-- making a CTE

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging 
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Inspecting the data

SELECT *
FROM layoffs_staging
WHERE company  = 'Oda' ;

-- we see that these values arent duplicate, the parition by requires more colounm names

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging 

)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- deleting duplicate rows

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- INSERTING VALUES INTO NEW TABLE

INSERT INTO layoffs_staging2
 SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging 
;

DELETE
FROM layoffs_staging2
WHERE row_num>1
;

-- checking again for individual comapnies
SELECT *
FROM layoffs_staging2
WHERE company = 'Casper';

########### STANDERDIZING DATA ###############

SELECT * 
FROM layoffs_staging2 ;

SELECT DISTINCT company,  TRIM(company)
FROM layoffs_staging2;

-- making changes in the working table 

UPDATE layoffs_staging2
SET company = TRIM(company)
;

-- location cloumn 

SELECT * 
FROM layoffs_staging2 ;

SELECT DISTINCT location 
FROM layoffs_staging2
ORDER BY 1;

-- INDUSTRY column 

SELECT DISTINCT industry
FROM layoffs_staging2
order by 1;

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
order by 1;

UPDATE layoffs_staging2
SET industry  = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- checking 

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- COUNTRY column 

SELECT DISTINCT *
FROM layoffs_staging2;

SELECT DISTINCT country 
FROM layoffs_staging2 
order by 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2 
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%' ;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1 ;

-- FIXING DATE format and type 

SELECT DISTINCT *
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date`  = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE ;

################## WORKING WITH NULL AND EMPTY DATA ######################

SELECT COUNT(company)
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL
AND funds_raised_millions IS NULL ;

-- Populating nulls and empty spaces in columns 
SELECT *
FROM layoffs_staging2
WHERE industry is NULL OR industry =  '';

SELECT *
FROM layoffs_staging2
WHERE company  = 'Airbnb';

-- setting empty fields  to null 

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry  = '';

-- populating from where the enteries werent null 

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company  = t2. company 
WHERE t1.industry is NULL AND t2.industry IS NOT NULL ;

-- POPULATING THE COLUMNS 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company =  t2.company 
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company  =  'Airbnb';

-- Getting rid of rows where both percentage laid off and total laid off are null 

DELETE 
FROM layoffs_staging2
WHERE 
total_laid_off IS NULL AND percentage_laid_off IS NULL ;

-- GETTING RID OF THE ROW _NUM column 

ALTER TABLE layoffs_staging2
DROP COLUMN 	row_num ;

-- THE CLEANED AND STANDERTIZED DATA IS AS FOLLOWS: 

SELECT *
FROM layoffs_staging2;

## All of the above part has been uploaded to GITHUB

























