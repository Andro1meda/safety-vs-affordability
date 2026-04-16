--==================
--Create Crime Table
--===================

CREATE TABLE raw.crime (
    Month_Year       VARCHAR(255),
    Area_Type        VARCHAR(255),
    Borough_SNT      VARCHAR(255),
    Area_Name        VARCHAR(255),
    Area_Code        VARCHAR(255),
    Crime_Type       VARCHAR(255),
    Crime_Subtype    VARCHAR(255),
    Measure          VARCHAR(255),
    Financial_Year   VARCHAR(255),
    FY_FYIndex       VARCHAR(255),
    Count            VARCHAR(255),
    Refresh_Date     VARCHAR(255));

-- allow importing
/*
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE
*/

BULK INSERT raw.crime
FROM 'C:\Original Data\M1045_MonthlyCrimeDashboard_KnifeCrimeData.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK,
MAXERRORS = 0);

BULK INSERT raw.crime
FROM 'C:\Original Data\M1045_MonthlyCrimeDashboard_OtherCrimeData.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK,
MAXERRORS = 0);


BULK INSERT raw.crime
FROM 'C:\Original Data\M1045_MonthlyCrimeDashboard_TNOCrimeData.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK,
MAXERRORS = 0);