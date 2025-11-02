################################################# EXPLORATORY DATA ANALYSIS #############################


SELECT *
FROM layoffs_staging2;

-- looking at maximum and minimum layoffs and percentage 

SELECT MAX(total_laid_off), MIN(total_laid_off),MAX(percentage_laid_off),MIN(percentage_laid_off)
FROM layoffs_staging2;

-- seeing companies that laid off all their staff

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

## These companies completely went under

-- Industries with the most layoffs 

SELECT industry ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
ORDER BY 2 DESC;

## Consumer and retail  industry had the most layoff,
## consistent with the fact that the world was in lockdowns during 
## those time periods .

-- countries most impacted by layoffs 

SELECT country,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC ;

## United States and India most affected
## consistent with population size and size of economy
## ## Netherland and Sweden are surprising entries. 

-- dates on which most layoffs took place 

SELECT (`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY (`date`)
ORDER BY 1 DESC;

-- Years which had the most layoffs

SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 	YEAR(`date`)
ORDER BY 1 DESC;

## highest number of layoffs in the years 2022
## But this data is only till the 3rd month of 2023
## we extrapolate that until something drastic happens 
## 2023 would be highest layoff year.

-- Seeing at what stages did companies have the highest layoffs.

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

## The highest layoffs come from post - ipo big companies, the next is Acquisitions also caused loss of jobs.


--  total of layoffs by months

SELECT SUBSTR(`date`,6,2) AS `month` ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `month` 
ORDER BY 2 DESC;

## most layoffs took place in January 

-- seeing a total of layoffs by month and years

SELECT SUBSTR(`date`,1,7) `month` ,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `month` 
ORDER BY 1 ASC; 

 -- Getting a rolling total 
 
 WITH rolling_total AS
 (SELECT SUBSTR(`date`,1,7) `month` ,SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) IS NOT NULL
GROUP BY `month` 
ORDER BY 1 ASC
)
SELECT `month`,total_off,SUM(total_off) OVER(ORDER BY `month`) AS roll_total
FROM rolling_total
;

## 2020 had total of 80998 layoffs
## 2021 only had about 16000 layoffs: good year
## 2022 had the most




-- seeing companies with the most layoffs 

SELECT company ,SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

## We see the big tech companies had the most layoffs 

-- seeing how many people companies let go each year

SELECT company , YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`)
ORDER BY company ASC;

-- Seeing companies with most layoffs each year

SELECT company , YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`)
ORDER BY 3 DESC;

-- Ranking them 

WITH company_year(company,years,total_laid_off) AS 
(SELECT company , YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`)
ORDER BY 3 DESC
)
SELECT *, DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL 
ORDER BY ranking ASC;

-- FILTERING TO SEE ONLY TOP 5 RANKS 

WITH company_year(company,years,total_laid_off) AS 
(SELECT company , YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`)
ORDER BY 3 DESC
), company_year_rank AS (
SELECT *, DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL 
ORDER BY ranking ASC)
SELECT * 
FROM company_year_rank
WHERE ranking <= 5;

## In 2020 uber let the most people go
## In 2021 Bytedance 
## In 2022 Meta 
## In 2023 Google

 


