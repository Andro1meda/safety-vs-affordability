# Safety vs. Affordability: A London UK Borough Perspective

## Project Overview

This project analyses the relationship between housing affordability and safety across London boroughs. It explored how these factors influence decision-making by highlighting the trade-offs between property costs and crime levels. The goal is to support more informed, data-driven housing choices.

## Objectives
This projects had 5 main questions that needed answering:
- Which boroughs are the most affordable for renting 1-2 bed accom?
- How does overall crime rate compare across boroughs?
- What types of crime are most common in affordable vs expensive areas?
- Which boroughs offer the best balance of safety and affordability?
- How have rental prices trended over time per borough?

## Dashboard
🔗 [View Interactive Dashboard (Tableau Public):](https://public.tableau.com/app/profile/andrea.mosqueda.jolly/viz/SafetyCrimeandHousingAffordabilityProject/Dashboard1?publish=yes)

<img width="1040" height="795" alt="image" src="https://github.com/user-attachments/assets/b503fc3a-3316-42c9-bb19-79198bc30b61" />

<img width="1080" height="788" alt="image" src="https://github.com/user-attachments/assets/f0a98e39-fff0-44df-a38c-c31e9f699b6c" />


## Tools & Technologies
- Tableau - Data visusalisation and dashboard creation
- SQL - Data cleaning, preparation and analysis
- GitHub - Project documentation

## Data Sources
_Please see folder "Original Sources"_

- UK crime data: London DataStore (MPS Monthly Crime Dashboard Data)
- Rental data by borough: UK Office of National Statistics (Price Index of Private Rents (PIPR) from the Office for National Statistics)
- London Borough Population UK Office of National Statistics (Population estimates for England and Wales: mid-2024

## Methodology  
- Cleaned and prepared housing and crime datasets
- Aggregated data at borough level
- Calculated:
  - Average rent (1-bed, 2-bed, combined)
  - Total crime rates per 1000 residents
  - Composite scores based on Affordability and Safety scores
- Built comparative visualisation in Tableau:
  - Bar chart (affordability)
  - Dot plot (rent comparison by property size)
  - Map (crime distribution)
  - Scatterplot (Safety and Affordability rank)
  - Line graph (rent over time)
- Designed dashboards with filters for borough-level exploration and safety and affordability filters

## Key Insights

### Affordability:
- The average combined rent showed the top 3 expensive boroughs as: Westminster, Kensigton and Chelsea and Camden. Where as the top 3 most affordable boroughs were: Bexley, Havering and Sutton were the most affordable boroughs.
- The results were the same for when comparing rent by property size:
  - The most affordable boroughs were: Havering, Bexley, Sutton
- However, the more expensive boroughs when comparing rent by property size:
  - Westminster
  - Kensington and Chelsea
  - Islington

### Crime Rate:
- The boroughs showing the highest crime rate per 1000 residents were: Westminster, Camden and Kensington and Chelsea.
- The boroughs showing the lowest crime rate per 1000 residents were: Richmond upon Thames, Harrow and Sutton.

### Crimes based on Affordable vs. Expensive boroughs:
- The most common crimes in affordable boroughs were: Miscalleneous crime and Violent crime.
- The most common crime in expensive areas was found to be theft.

### Safe vs. Affordable:
- The boroughs which found to have the best balance of safety and affordability were:
  - Sutton
  - Bexley
  - Havering
  - Harrow
  - Barking and Dagenham

### Rental Prices over Time:
- Rental prices in each borough remained stable with a slight increase across the years.
- There was a large spike of rental prices for each borough from 2022 peaking at 2024.
- After 2024 rent prices dropped significantly until 2025.

## Limitations
- Crime data may not have captured all incidents
- Rent average may mask within-borough variation
- Analysis is limited to available datasets and timeframes

## Future Improvements
- Include transport accessibility such as communting times
- Include transport crimes
- Include sub-Types of crime
- Incorporate income data for deeper affordability insights
