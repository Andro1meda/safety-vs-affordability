--==========================================
-- Create Views for Tableau
--==========================================
USE LondonCrimeAccomodation;

CREATE SCHEMA analysis;

--=================
-- View 1
--=================

CREATE VIEW [analysis].[Affordability of 1-2 Bed Properties per Borough] AS
SELECT 
    rbp.Area_Name AS Borough,
    ROUND(rbp.Rental_Price_One_Bed, 0) AS Avg_1Bed_Rent, 
    ROUND(rbp.Rental_Price_Two_Bed, 0) AS Avg_2Bed_Rent,
    ROUND((rbp.Rental_Price_One_Bed + rbp.Rental_Price_Two_Bed) /2, 0) AS Avg_Combined_Rent,
    ROUND(CAST(rbp.Rental_Price_One_Bed + rbp.Rental_Price_Two_Bed AS DECIMAL(10,2)) / 2 / p.Population_2024 * 1000, 2) AS Rent_Per_1000_Residents
FROM clean.rent_by_property_jun_2025 rbp
JOIN clean.london_population p ON rbp.Area_Name = p.Borough;

GO 

--==================
-- View 2
--===================

CREATE VIEW [analysis].[Total Crimes per Borough] AS
SELECT
    c.Borough_Name AS Borough,
    SUM(c.Count) AS Total_Crimes,
    p.Population_2024,
    c.Area_Code AS GSS,
    ROUND(CAST(SUM(c.Count) AS DECIMAL(10,2)) / p.Population_2024 * 1000,2) AS Crimes_per_1000
FROM clean.crime c
JOIN clean.london_population p ON c.Borough_Name = p.Borough
GROUP BY c.Borough_Name, p.Population_2024, c.Area_Code;

GO

--======================
-- View 3
--=======================
CREATE VIEW [analysis].[Crime Types by Affordability] AS
WITH Affordability AS (
    SELECT 
        Area_Name,
        ROUND((Rental_Price_One_Bed + Rental_Price_Two_Bed) / 2.0, 0) AS Avg_Rent,
        CASE 
            WHEN (Rental_Price_One_Bed + Rental_Price_Two_Bed) / 2.0 < 1600 
                THEN 'Affordable'
            WHEN (Rental_Price_One_Bed + Rental_Price_Two_Bed)/ 2.0 BETWEEN 1600 AND 2200 
                THEN 'Mid-range'
            ELSE 'Expensive'
        END AS Affordability_Level
    FROM clean.rent_by_property_jun_2025),

CrimeAgg AS (
    SELECT
        af.Affordability_Level,
        c.Crime_Type,
        SUM(CAST(c.Count AS BIGINT)) AS Total_Crimes,
        SUM(DISTINCT p.Population_2024) AS Total_Population
    FROM clean.crime c
    JOIN Affordability af ON c.Borough_Name = af.Area_Name
    JOIN clean.london_population p ON c.Borough_Name = p.Borough
    GROUP BY af.Affordability_Level, c.Crime_Type)

SELECT
    Affordability_Level,
    Crime_Type,
    Total_Crimes,
    ROUND(Total_Crimes * 1000.0 
          / Total_Population, 2) AS Crimes_Per_1000
FROM CrimeAgg

GO


--=================
-- View 4
--=================
CREATE VIEW [analysis].[Safety and Affordability Across Boroughs] AS 
WITH Rent_Rank AS (
    SELECT 
        Area_Name,
        ROUND((Rental_Price_One_Bed + Rental_Price_Two_Bed) / 2.0, 0) AS Avg_Rent,
        RANK() OVER (ORDER BY (Rental_Price_One_Bed + Rental_Price_Two_Bed) / 2.0 ASC) AS Affordability_Rank
    FROM clean.rent_by_property_jun_2025
    WHERE Rental_Price_One_Bed IS NOT NULL AND Rental_Price_Two_Bed IS NOT NULL
),

Crime_Rank AS (
    SELECT 
        Borough_Name,
        SUM(CAST(Count AS BIGINT)) AS Total_Crimes,
        RANK() OVER (ORDER BY SUM(CAST(Count AS BIGINT)) ASC) AS Safety_Rank
FROM clean.crime
GROUP BY Borough_Name
),

PopJoin AS (
    SELECT
        r.Area_Name AS Borough,
        r.Avg_Rent,
        c.Total_Crimes,
        p.Population_2024,
        ROUND(c.Total_Crimes * 1000.0 / p.Population_2024, 2) AS Crimes_per_1000,
        r.Affordability_Rank,
        c.Safety_Rank,
        r.Affordability_Rank + c.Safety_Rank AS Composite_Score
    FROM Rent_Rank r
    JOIN Crime_Rank c ON r.Area_Name = c.Borough_Name
    JOIN clean.london_population p ON r.Area_Name = p.Borough)

SELECT
    Borough,
    Avg_Rent,
    Crimes_per_1000,
    Affordability_Rank,
    Safety_Rank,
    Composite_Score
FROM PopJoin

GO 
--=====================
-- View 5
--=====================
CREATE VIEW [analysis].[Rental Prices Trend Over Time per Borough] AS 
SELECT
    Area_Name AS Borough,
    Time_period,
    Rental_Price AS Monthly_Rent,
    LAG(Rental_Price,12) OVER (PARTITION BY Area_Name
                                ORDER BY Time_period) AS Annual_Change
FROM clean.rent_monthly_all
WHERE Area_Name IN (SELECT Borough_Name FROM clean.london_boroughs)
AND Rental_Price IS NOT NULL

GO
