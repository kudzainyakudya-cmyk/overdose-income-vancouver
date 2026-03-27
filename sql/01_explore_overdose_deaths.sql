-- Overdose & Income in Vancouver
-- Query 1: All data ordered by year
SELECT *
FROM overdose_deaths
ORDER BY year ASC;

-- Query 2: Year over year change in deaths
SELECT 
    year,
    deaths,
    deaths - LAG(deaths) OVER (ORDER BY year) AS change_from_previous_year
FROM overdose_deaths
ORDER BY year ASC;

-- Query 3: Worst year on record
SELECT year, deaths
FROM overdose_deaths
WHERE deaths = (SELECT MAX(deaths) FROM overdose_deaths);

-- Query 4: Percentage change year over year
SELECT 
    year,
    deaths,
    LAG(deaths) OVER (ORDER BY year) AS previous_year,
    ROUND(
        (deaths - LAG(deaths) OVER (ORDER BY year)) * 100.0 / 
        LAG(deaths) OVER (ORDER BY year), 1
    ) AS pct_change
FROM overdose_deaths
ORDER BY year ASC;

-- Query 5: Cumulative deaths since 2014
SELECT 
    year,
    deaths,
    SUM(deaths) OVER (ORDER BY year) AS cumulative_deaths
FROM overdose_deaths
ORDER BY year ASC;

SELECT 
    CASE 
        WHEN year BETWEEN 2014 AND 2018 THEN '2014-2018'
        WHEN year BETWEEN 2019 AND 2024 THEN '2019-2024'
    END AS period,
    COUNT(year) AS num_years,
    SUM(deaths) AS total_deaths,
    ROUND(AVG(CAST(deaths AS FLOAT)), 1) AS avg_deaths_per_year
FROM overdose_deaths
GROUP BY 
    CASE 
        WHEN year BETWEEN 2014 AND 2018 THEN '2014-2018'
        WHEN year BETWEEN 2019 AND 2024 THEN '2019-2024'
    END
ORDER BY period ASC;
