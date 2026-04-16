USE LondonCrimeAccomodation;
--====================
-- borough population 2024
--====================

SELECT *
FROM dbo.London_Population$

CREATE TABLE raw.london_population (
Borough VARCHAR(100),
Population_2024 INT);

INSERT INTO raw.london_population
SELECT 
TRIM(Borough),
Population_2024
FROM dbo.London_Population$;

SELECT *
FROM raw.london_population;

-- check if the boroughs match reference list
SELECT DISTINCT Borough AS Non_Borough_Values
FROM raw.london_population
WHERE TRIM(Borough) NOT IN (SELECT Borough_Name FROM clean.london_boroughs)
ORDER BY Borough;

-- create clean table 

CREATE TABLE clean.london_population (
Borough VARCHAR(100),
Population_2024 INT);

INSERT INTO clean.london_population
SELECT 
TRIM(Borough),
Population_2024
FROM raw.london_population;

-- check if the boroughs match reference list
SELECT DISTINCT Borough AS Non_Borough_Values
FROM clean.london_population
WHERE Borough NOT IN (SELECT Borough_Name FROM clean.london_boroughs)
ORDER BY Borough;


-- fix spelling of Westminster 
UPDATE clean.london_population
SET Borough = 'Westminster'
WHERE Borough = 'Westminister';

-- remove total row
DELETE FROM clean.london_population
WHERE Borough = 'Total';

SELECT *
FROM clean.london_population

SELECT Borough, LEN(Borough) AS Name_Length
FROM clean.london_population
WHERE Borough LIKE '%Barking%';

SELECT Borough_Name, LEN(Borough_Name) AS Name_Length
FROM clean.london_boroughs
WHERE Borough_Name LIKE '%Barking%';

-- Compare character by character using ASCII values
SELECT 
    UNICODE(SUBSTRING(Borough, 1, 1))  AS Char1,
    UNICODE(SUBSTRING(Borough, 5, 1))  AS Char5,
    UNICODE(SUBSTRING(Borough, 12, 1)) AS Char12
FROM clean.london_population
WHERE Borough LIKE '%Barking%'

UNION ALL

SELECT 
    UNICODE(SUBSTRING(Borough_Name, 1, 1)),
    UNICODE(SUBSTRING(Borough_Name, 5, 1)),
    UNICODE(SUBSTRING(Borough_Name, 12, 1))
FROM clean.london_boroughs
WHERE Borough_Name LIKE '%Barking%';

UPDATE clean.london_population
SET Borough = 'Barking and Dagenham'
WHERE Borough LIKE '%Barking%';
