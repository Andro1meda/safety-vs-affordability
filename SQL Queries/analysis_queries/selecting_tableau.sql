--=============================
-- SELECTING
--============================

USE LondonCrimeAccomodation;

-- RQ1 - view 1
SELECT *
FROM [analysis].[Affordability of 1-2 Bed Properties per Borough]
ORDER BY Avg_Combined_Rent ASC;


-- RQ2 - view 2
SELECT *
FROM [analysis].[Total Crimes per Borough]
ORDER BY Crimes_per_1000 ASC;

-- RQ3 - view 3
SELECT *
FROM [analysis].[Crime Types by Affordability]
ORDER BY Affordability_Level, Total_Crimes DESC;

-- RQ4 - view 4
SELECT * 
FROM [analysis].[Safety and Affordability Across Boroughs]
ORDER BY Composite_Score ASC;

-- RQ5 - view 5
SELECT * 
FROM [analysis].[Rental Prices Trend Over Time per Borough]
ORDER BY Borough, Time_period;

