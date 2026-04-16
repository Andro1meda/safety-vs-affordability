USE LondonCrimeAccomodation;

--==============================================
--Create raw table for monthly London avg rent
--==============================================

CREATE TABLE raw.rent_monthly_all(
Time_period VARCHAR(255),
Area_Code VARCHAR(255),
Area_Name VARCHAR(255),
Region_or_Country_Name VARCHAR(255),
Annual_Change VARCHAR(255),
Rental_Price VARCHAR(255));

--============================================================
--Create raw table for rent by property type in month of June
--============================================================

CREATE TABLE raw.rent_by_property_jun_2025(
Area_Code VARCHAR(255),
Area_Name VARCHAR(255),
Rental_Price_One_Bed VARCHAR(255),
Rental_Price_Two_Bed VARCHAR(255),
Rental_Price_Three_Bed VARCHAR(255),
Rental_Price_Four_or_More_Bed VARCHAR(255),
Rental_Price VARCHAR(255));

--========================================
--moving dbo created table into raw table
--========================================
/*
INSERT INTO raw.rent_monthly_all 
SELECT * 
FROM dbo.London_Rent$
*/

-- remove dbo table
-- DROP TABLE dbo.London_Rent$

--check to see if data is in the tables
SELECT TOP 10 *
FROM raw.rent_monthly_all

SELECT TOP 10 *
FROM raw.rent_by_property_jun_2025