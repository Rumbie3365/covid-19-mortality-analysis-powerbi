-- COVID-19 Mortality Analysis - SQL Queries for Portfolio Project
-- Use this script after importing Fact_COVID19_Weekly_WHO into your SQL database.

-- 1. Total reported cases and deaths by country
SELECT
    Country,
    WHO_region,
    MAX(Cumulative_cases) AS Total_Cases,
    MAX(Cumulative_deaths) AS Total_Deaths,
    CASE WHEN MAX(Cumulative_cases) > 0
         THEN CAST(MAX(Cumulative_deaths) AS FLOAT) / MAX(Cumulative_cases)
         ELSE 0 END AS Case_Fatality_Rate
FROM Fact_COVID19_Weekly_WHO
GROUP BY Country, WHO_region
ORDER BY Total_Deaths DESC;

-- 2. Weekly global death trend
SELECT
    Date_reported,
    SUM(New_deaths) AS Weekly_New_Deaths,
    SUM(New_cases) AS Weekly_New_Cases
FROM Fact_COVID19_Weekly_WHO
GROUP BY Date_reported
ORDER BY Date_reported;

-- 3. Deaths by WHO region
WITH latest_country AS (
    SELECT f.*
    FROM Fact_COVID19_Weekly_WHO f
    INNER JOIN (
        SELECT Country_code, MAX(Date_reported) AS Latest_Date
        FROM Fact_COVID19_Weekly_WHO
        GROUP BY Country_code
    ) latest
      ON f.Country_code = latest.Country_code
     AND f.Date_reported = latest.Latest_Date
)
SELECT
    WHO_region,
    SUM(Cumulative_cases) AS Total_Cases,
    SUM(Cumulative_deaths) AS Total_Deaths
FROM latest_country
GROUP BY WHO_region
ORDER BY Total_Deaths DESC;

-- 4. Zimbabwe weekly trend
SELECT
    Date_reported,
    New_cases,
    Cumulative_cases,
    New_deaths,
    Cumulative_deaths
FROM Fact_COVID19_Weekly_WHO
WHERE Country = 'Zimbabwe'
ORDER BY Date_reported;

-- 5. Zimbabwe monthly deaths
SELECT
    YearMonth,
    SUM(New_cases) AS Monthly_New_Cases,
    SUM(New_deaths) AS Monthly_New_Deaths
FROM Fact_COVID19_Weekly_WHO
WHERE Country = 'Zimbabwe'
GROUP BY YearMonth
ORDER BY YearMonth;