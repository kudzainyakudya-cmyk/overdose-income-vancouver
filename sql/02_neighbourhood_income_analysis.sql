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

-- Query 3: Neighbourhood vulnerability ranking by income
SELECT 
    neighbourhood,
    median_income_2015,
    RANK() OVER (ORDER BY median_income_2015 ASC) AS vulnerability_rank,
    CASE 
        WHEN median_income_2015 < 27000 THEN 'High Risk'
        WHEN median_income_2015 BETWEEN 27000 AND 35000 THEN 'Moderate Risk'
        ELSE 'Lower Risk'
    END AS risk_category
FROM neighbourhood_income
ORDER BY vulnerability_rank ASC;

-- Query 4: Income gap between Vancouver's wealthiest and most vulnerable neighbourhoods
SELECT 
    MAX(median_income_2015) AS highest_income_neighbourhood,
    MIN(median_income_2015) AS lowest_income_neighbourhood,
    MAX(median_income_2015) - MIN(median_income_2015) AS income_gap,
    ROUND(CAST(MAX(median_income_2015) AS FLOAT) / MIN(median_income_2015), 1) AS income_ratio,
    (SELECT neighbourhood FROM neighbourhood_income WHERE median_income_2015 = MAX(n.median_income_2015)) AS richest,
    (SELECT neighbourhood FROM neighbourhood_income WHERE median_income_2015 = MIN(n.median_income_2015)) AS poorest
FROM neighbourhood_income n;
