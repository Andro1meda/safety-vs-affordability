-- Cleaning Crime Data 
USE LondonCrimeAccomodation;

SELECT * 
FROM raw.crime;

--===================================
-- create staging schema for cleaning
--===================================
/* CREATE SCHEMA staging;

SELECT *
INTO staging.crime
FROM raw.crime */

--=======================
-- STEPS: 
-- Standardise data 
-- Null values
-- Remove any columns
--============================

--=========================
-- explore the data 
--============================

SELECT TOP 10 * 
FROM staging.crime; 

SELECT DISTINCT Area_Type
FROM staging.crime;

SELECT DISTINCT Measure
FROM staging.crime;

SELECT
Crime_Type,
Crime_Subtype,
Measure
FROM staging.crime
WHERE Measure NOT IN ('Offences','Positive Outcomes');
--=======================
-- Filter by Borough
--========================
SELECT *
FROM staging.crime
WHERE Area_Type = 'Borough';


--============================
-- Filter by Offences
--=============================
SELECT * 
FROM staging.crime
WHERE Measure = 'Offences';


sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'max server memory', 4096; --Memory in MB
GO
RECONFIGURE;
GO

SELECT DISTINCT Area_Name FROM staging.crime;