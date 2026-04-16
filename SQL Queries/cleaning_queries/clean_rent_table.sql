USE LondonCrimeAccomodation;

-- ===========================
-- rent_by_property_jun_2025
-- ============================

SELECT *
FROM raw.rent_by_property_jun_2025;

-- check which area_names are not in the borough reference list
SELECT DISTINCT Area_Name AS Non_Borough_Values
FROM raw.rent_by_property_jun_2025
WHERE TRIM(Area_Name) NOT IN (SELECT Borough_Name FROM clean.london_boroughs)
ORDER BY Area_Name;

-- Check for null values
SELECT 
COUNT(*) AS Total_Rows, 
SUM(CASE WHEN Rental_Price_One_Bed IS NULL THEN 1 ELSE 0 END) AS NULL_1BED,
SUM(CASE WHEN Rental_Price_Two_Bed IS NULL THEN 1 ELSE 0 END) AS NULL_2BED,
SUM(CASE WHEN Rental_Price_Three_Bed IS NULL THEN 1 ELSE 0 END) AS NULL_3BED,
SUM(CASE WHEN Rental_Price_Four_or_More_Bed IS NULL THEN 1 ELSE 0 END) AS NULL_4BED,
SUM(CASE WHEN Rental_Price IS NULL THEN 1 ELSE 0 END) AS Null_Overall
FROM raw.rent_by_property_jun_2025;

-- create clean rent of jun 2025 table 
CREATE TABLE clean.rent_by_property_jun_2025 (
Area_Code VARCHAR(100),
Area_Name VARCHAR(100),
Rental_Price_One_Bed INT,
Rental_Price_Two_Bed INT,
Rental_Price_Three_Bed INT,
Rental_Price_Four_or_More_Bed INT,
Rental_Price INT);

INSERT INTO clean.rent_by_property_jun_2025
SELECT
TRIM(Area_Code),
TRIM(Area_Name),
TRIM(Rental_Price_One_Bed),
TRIM(Rental_Price_Two_Bed),
TRIM(Rental_Price_Three_Bed),
TRIM(Rental_Price_Four_or_More_Bed),
TRIM(Rental_Price)
FROM raw.rent_by_property_jun_2025;

SELECT *
FROM clean.rent_by_property_jun_2025;

-- ==========================
-- rent_monthly_all
--==========================


SELECT * 
FROM raw.rent_monthly_all;

-- How many rows and distinct boroughs
SELECT COUNT(*) AS Total_Rows FROM raw.rent_monthly_all;
SELECT COUNT(DISTINCT Area_Name) AS Borough_Count FROM raw.rent_monthly_all;

-- Check which area names arent in the borough reference list 
SELECT DISTINCT Area_Name AS Non_Borough_Values
FROM raw.rent_monthly_all
WHERE TRIM(Area_Name) NOT IN 
(SELECT Borough_Name FROM clean.london_boroughs)
ORDER BY Area_Name;

-- Check time_period format

SELECT DISTINCT Time_period
FROM raw.rent_monthly_all
ORDER BY Time_period;

-- Check for null values

SELECT *
FROM raw.rent_monthly_all;

SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN Rental_Price IS NULL THEN 1 ELSE 0 END) AS Null_Price,
SUM(CASE WHEN Annual_Change IS NULL THEN 1 ELSE 0 END) AS Null_change,
SUM(CASE WHEN Time_Period IS NULL THEN 1 ELSE 0 END) AS Null_time
FROM raw.rent_monthly_all;

-- Create clean rental_all table

CREATE TABLE clean.rent_monthly_all (
Time_period DATETIME,
Area_Code VARCHAR(100),
Area_Name VARCHAR(100),
Region_or_Country_Name VARCHAR(100),
Annual_Change VARCHAR(100),
Rental_Price INT);

INSERT INTO clean.rent_monthly_all
SELECT 
TRIM(Time_period),
TRIM(Area_Code),
TRIM(Area_Name),
TRIM(Region_or_Country_Name),
TRIM(Annual_Change),
TRIM(Rental_Price)
FROM raw.rent_monthly_all;

SELECT *
FROM clean.rent_monthly_all;

-- dropping redundant columns

ALTER TABLE clean.rent_monthly_all
DROP COLUMN Annual_Change;