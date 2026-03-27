-- Overdose & Income in Vancouver
-- Query 1: All neighbourhoods ordered by income (lowest to highest)
SELECT *
FROM neighbourhood_income
ORDER BY median_income_2015 ASC;

-- Query 2: Neighbourhoods by income category with Vancouver overdose context
SELECT 
    n.neighbourhood,
    n.median_income_2015,
    CASE 
        WHEN n.median_income_2015 < 27000 THEN 'Low Income'
        WHEN n.median_income_2015 BETWEEN 27000 AND 35000 THEN 'Middle Income'
        ELSE 'Higher Income'
    END AS income_category,
    SUM(o.deaths) AS total_overdose_deaths_vancouver,
    ROUND(AVG(CAST(o.deaths AS FLOAT)), 1) AS avg_annual_deaths
FROM neighbourhood_income n
CROSS JOIN overdose_deaths o
WHERE o.city = 'Vancouver'
GROUP BY n.neighbourhood, n.median_income_2015
ORDER BY n.median_income_2015 ASC;