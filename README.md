# Cyclistic Bike-Share Data Analysis

## Project Overview
This project analyzes the usage patterns of Cyclistic, a bike-share company based in Chicago. The goal is to provide insights into customer behavior, compare casual riders and annual members, and offer strategic recommendations to improve user engagement and revenue.

## Dataset
The data used for this analysis is publicly available through [Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html)). It includes trip details such as ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, end_lat, end_lng, start_station_name, start_station_id, end_station_name, and member_casual. The dataset has been cleaned and prepared for analysis.

## Tools Used
- **Programming Languages:** R
- **Libraries:** tidyverse, lubridate, ggplot2, dplyr
- **Data Cleaning/Transformation/Analysis/Visualization:** RStudio
- **Report:** R Markdown

## Key Findings
- Casual riders have significantly longer ride durations (25.93 minutes on average) compared to annual members (12.99 minutes). Casual riders primarily use the service for leisure or sightseeing, whereas members rely on it for short, frequent commutes.  

- Electric bikes are the most frequently used ride type** (2,869,398 rides), followed by classic bikes (2,722,302 rides). Electric scooters have the lowest usage (137,612 rides). The popularity of electric bikes suggests a preference for faster and less physically demanding rides.  

- Ride usage peaks between May and September** (warmer months) and significantly drops between November and February (colder months). Casual riders are more weather-dependent, using the service primarily for recreational purposes.  

- Afternoon (12 PM – 5 PM) has the highest ride volume across both casual riders and members. Members maintain a more balanced ride pattern throughout the day, suggesting work commutes play a significant role.  
The **top stations used by both casual riders and members** include:  
  - **Streeter Dr & Grand Ave** (Most popular start & end station)  
  - **DuSable Lake Shore Dr & Monroe St**  
  - **Kingsbury St & Kinzie St**  
  - **Michigan Ave & Oak St**  
  - **Millennium Park**  
- These locations are close to key business districts and tourist attractions.
- 
## Recommendations
- **Targeted Marketing Strategies for Membership Conversion:** Develop membership promotions for casual riders during peak months (May – September).  Introduce trial memberships or tiered plans (e.g., weekly or monthly passes).  
- **Seasonal Campaigns to Retain Ridership in Winter:** Offer winter discounts and incentives to encourage casual riders. Introduce heated or weather-protected docking stations.  
- **Incentivizing Morning and Evening Rides:** Offer discounts or loyalty rewards for morning and evening rides. Partner with coffee shops or co-working spaces for morning ride incentives.  
- **Optimized Bike Fleet and Docking Stations:** Expand bike availability, particularly electric bikes, in high-demand locations.  Introduce smart rebalancing technology to ensure an even distribution of bikes.  
- **Enhancing Digital Media and Customer Engagement:**  Leverage social media ads, influencer marketing, and referral programs.  Use mobile app notifications to suggest memberships to frequent casual users.

## Repository Structure
```
|-- scripts/             # R scripts for data processing
|-- reports/             # Summary reports and insights
|-- visualisations/      # contains visualizations
|-- README.md            # Project overview and instructions
```

## How to Use
1. Download the dataset from the [trip data]((https://divvy-tripdata.s3.amazonaws.com/index.html)).
2. Use the provided scripts for data cleaning and analysis.
3. Explore visualizations in R for deeper insights.
4. Review reports for key findings and strategic recommendations.

## Contributors
- Abdulhamid Olayinka
- Open for collaboration! 
