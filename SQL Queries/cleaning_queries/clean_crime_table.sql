USE LondonCrimeAccomodation;

-- Create reference table for London Boroughs
DROP TABLE clean.london_boroughs;

CREATE TABLE clean.london_boroughs (
Borough_Name VARCHAR(100),
Area_Code VARCHAR(100),
);

INSERT INTO clean.london_boroughs VALUES
('Barking and Dagenham', 'E09000002'),
('Barnet', 'E09000003'),
('Bexley', 'E09000004'),
('Brent', 'E09000005'),
('Bromley', 'E09000006'),
('Camden', 'E09000007'),
('Croydon', 'E09000008'),
('Ealing', 'E09000009'),
('Enfield', 'E09000010'),
('Greenwich', 'E09000011'),
('Hackney', 'E09000012'),
('Hammersmith and Fulham', 'E09000013'),
('Haringey', 'E09000014'),
('Harrow', 'E09000015'),
('Havering', 'E09000016'),
('Hillingdon', 'E09000017'),
('Hounslow', 'E09000018'),
('Islington', 'E09000019'),
('Kensington and Chelsea', 'E09000020'),
('Kingston upon Thames', 'E09000021'),
('Lambeth', 'E09000022'),
('Lewisham', 'E09000023'),
('Merton', 'E09000024' ),
('Newham', 'E09000025'),
('Redbridge', 'E09000026'),
('Richmond upon Thames', 'E09000027'),
('Southwark', 'E09000028'),
('Sutton', 'E09000029'),
('Tower Hamlets', 'E09000030'),
('Waltham Forest', 'E09000031'),
('Wandsworth', 'E09000032'),
('Westminster', 'E09000033');

SELECT *
FROM clean.london_boroughs;

-- Check if all 32 boroughs were loaded (count should be 32)
SELECT COUNT(*) AS Borough_Count FROM clean.london_boroughs;

-- See exactly what's being excluded from your crime data
SELECT DISTINCT c.Area_Name
FROM staging.crime c
WHERE Area_Type = 'Borough'
  AND Area_Name NOT IN (SELECT Borough_Name FROM clean.london_boroughs)
ORDER BY Area_Name;

-- Add Borough_Name column to staging.crime
ALTER TABLE staging.crime
ADD Borough_Name VARCHAR(100);

SELECT TOP 5 Borough_SNT, Borough_Name FROM staging.crime;

-- Matching the start of Borough_SNT
UPDATE s
SET s.Borough_Name = lb.Borough_Name
FROM staging.crime s
JOIN clean.london_boroughs lb
ON s.Borough_SNT LIKE lb.Borough_Name + '%';

-- Check how many rows were matched
SELECT COUNT(*) AS Total_Rows, 
COUNT(Borough_Name) AS Matched_Rows, 
COUNT(*) - COUNT(Borough_Name) AS Unmatched_Rows
FROM staging.crime;

-- These Borough names were not matched (Aviation Security, N/K)
SELECT DISTINCT Borough_SNT
FROM staging.crime
WHERE Borough_Name IS NULL
ORDER BY Borough_SNT;

SELECT DISTINCT Borough_Name
FROM staging.crime
WHERE Borough_Name IS NOT NULL
ORDER BY Borough_Name;

SELECT TOP 10 * 
FROM staging.crime

IF OBJECT_ID('clean.crime', 'U') IS NOT NULL
DROP TABLE clean.crime

DROP TABLE clean.crime;

-- create clean.crime table
CREATE TABLE clean.crime (
Month_Year VARCHAR(20),
Area_Name VARCHAR(100),
Area_Type VARCHAR(100),
Borough_SNT VARCHAR(100),
Borough_Name VARCHAR(100),
Area_Code VARCHAR(20),
Crime_Type VARCHAR(100),
Crime_Subtype VARCHAR(100),
Measure VARCHAR(50),
Financial_Year VARCHAR(20),
FY_FYIndex INT,
Count INT, 
Refresh_Date VARCHAR(20));

-- insert all columns, filtering out to boroughs and offences and no null values
INSERT INTO clean.crime
SELECT
TRIM(Month_Year),
TRIM(Area_Name),
TRIM(Area_Type),
TRIM(Borough_SNT),
TRIM(Borough_Name),
TRIM(Area_Code),
TRIM(Crime_Type),
TRIM(Crime_Subtype),
TRIM(Measure),
TRIM(Financial_Year),
TRY_CAST(FY_FYIndex AS INT),
TRY_CAST(Count AS INT), 
TRIM(Refresh_Date)
FROM staging.crime
WHERE Measure = 'Offences' AND Area_Type = 'Borough'
AND TRY_CAST([Count] AS INT) IS NOT NULL
AND Borough_Name IS NOT NULL;

-- check columns
SELECT COUNT(*) FROM clean.crime 
WHERE FY_FYIndex IS NULL;

SELECT DISTINCT Measure FROM clean.crime;

SELECT * FROM clean.crime;

-- remove column with null values 
ALTER TABLE clean.crime
DROP COLUMN FY_FYIndex;


-- Check distinct crime_types 
SELECT DISTINCT Crime_Type
FROM clean.crime
ORDER BY Crime_Type;

-- Change format for crime_types
UPDATE clean.crime
SET Crime_Type = LOWER(Crime_Type);

-- Check distinct crime_subtypes
SELECT DISTINCT Crime_Subtype
FROM clean.crime
ORDER BY Crime_Subtype;

-- Change format for crime_types
UPDATE clean.crime
SET Crime_Subtype = LOWER(Crime_Subtype);

-- Check Month_Year format is consistent
SELECT DISTINCT Month_Year 
FROM clean.crime
ORDER BY Month_Year;

-- Check Financial Year format 
SELECT DISTINCT Financial_Year 
FROM clean.crime
ORDER BY Financial_Year;

-- Check refresh_date
SELECT DISTINCT Refresh_Date
FROM clean.crime;

-- Dropping redundant columns 
ALTER TABLE clean.crime
DROP COLUMN Measure;

ALTER TABLE clean.crime
DROP COLUMN Borough_SNT;

ALTER TABLE clean.crime
DROP COLUMN Refresh_Date;

ALTER TABLE clean.crime
DROP COLUMN Area_Type;

SELECT TOP 10 * FROM clean.crime;

-- check duplicate rows
SELECT Month_Year, Borough_Name, Crime_Type, Crime_Subtype, Financial_Year, Count, 
COUNT(*) AS Duplicate_Count
FROM clean.crime
GROUP BY Month_Year, Borough_Name, Crime_Type, Crime_Subtype, Financial_Year, Count
HAVING COUNT(*) > 1;

-- how many duplicate rows exist in total
WITH Duplicates AS (
SELECT *, ROW_NUMBER() OVER (
PARTITION BY Month_Year, Borough_Name, Crime_Type, Crime_Subtype, Financial_Year, Count
ORDER BY (SELECT NULL)
) AS Row_Num
FROM clean.crime
)
SELECT COUNT(*) AS Duplicate_Rows
FROM Duplicates
WHERE Row_Num > 1;

-- Look at the actual raw source rows side by side
-- to see if there's any distinguishing column
SELECT 
Month_Year,
Borough_Name,
Crime_Type,
Crime_Subtype,
Financial_Year,
Count,
Area_Code
FROM clean.crime
WHERE Month_Year = '01/01/2022'
AND Borough_Name = 'Barking and Dagenham'
AND Crime_Type = 'arson and criminal damage'
AND Crime_Subtype = 'arson'
AND Count = 1
ORDER BY Area_Code;

-- check the staging table to see original rows
SELECT *
FROM staging.crime
WHERE Borough_SNT   LIKE 'Barking and Dagenham%'
AND Month_Year    = '01/01/2022'
AND Crime_Type    = 'arson and criminal damage'
AND Crime_Subtype = 'arson'
AND [Count]       = '1'
AND Measure       = 'Offences';

-- matching boroughs to borough-level area codes
SELECT 
c.*,
lb.Area_Code
FROM clean.crime c
LEFT JOIN clean.london_boroughs lb
ON c.Borough_Name = lb.Borough_Name;

-- change table permanently
UPDATE c
SET c.Area_Code = lb.Area_Code
FROM clean.crime c
JOIN clean.london_boroughs lb
    ON c.Borough_Name = lb.Borough_Name;

SELECT TOP 10 *
FROM clean.crime;