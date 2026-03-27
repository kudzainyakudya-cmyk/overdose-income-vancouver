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
