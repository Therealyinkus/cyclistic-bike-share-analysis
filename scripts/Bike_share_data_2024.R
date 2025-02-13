#Installing Packages
install.packages("tidyverse")
install.packages("lubridate")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("scales")

#load packages
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(scales)

# Setting the working directory to the folder containing the datasets of the previous 12 months
setwd("C:/Users/USER/Desktop/Data Analytics Project/about_bike_sharing_last_12_month/")

# Listing all files in the directory containing monthly data
file_list <- list.files(pattern = "*.csv", full.names = TRUE)

# Displaying the list of files
print(file_list)


# Looping through each file in the directory and preview
for (file in file_list) {
  cat("Preview of file:", file, "\n")
  data_preview <- read_csv(file, n_max = 5)
  print(data_preview)
  cat("Structure of the dataset:\n")
  print(str(data_preview))
  cat("\n-----------------------------------\n")
}

# Reading and combine]ing all 12 datasets
bikedata_2024 <- file_list %>%
  lapply(read.csv) %>%
  bind_rows()

# Previewing the combined datasets
head(bikedata_2024)

# Saving the combined data as a new file
write.csv(bikedata_2024, "C:/Users/USER/Desktop/Data Analytics Project/2024_cyclistic_bikesharing_data.csv", row.names = FALSE)

# Viewing the Structure of the dataset
str(bikedata_2024)
colnames(bikedata_2024)
glimpse(bikedata_2024)

# Making a copy of the dataset
data <- bikedata_2024

# Checking for blank/null cells
colSums(data == "" | is.na(data))

# Checking duplicate entries by ride_id
duplicate_entries = data[duplicated(data$ride_id), ]
print(duplicate_entries)

# Removing duplicates with distinct
distinct_data = distinct(data)
  
# Data Processing
# checking the data type of each column
sapply(distinct_data, class)

# Converting started_at and ended_at to timestamp format
distinct_data <- distinct_data %>%
  mutate(
    started_at = as.POSIXct(started_at, format = "%Y-%m-%d %H:%M:%S"),
    ended_at = as.POSIXct(ended_at, format = "%Y-%m-%d %H:%M:%S")
  )
head(distinct_data)
    
# Creating new columns for ride_duration, day_of_week, hour_trip_started, time_of_day(morning, afternoon, evening)
distinct_data <- distinct_data %>%
  mutate(
    ride_duration_mins = as.numeric(difftime(distinct_data$ended_at, distinct_data$started_at), units = "mins"),
    day_of_week = weekdays(distinct_data$started_at),
    hour_trip_started = as.numeric(format(distinct_data$started_at, "%H")),
    time_of_day = cut(
      hour_trip_started,
      breaks = c(-1,11,17,24),
      labels = c("Morning", "Afternoon", "Evening"),
      right = TRUE)
  )  
  
head(distinct_data)

# Renaming member_casual to user_type
colnames(distinct_data)[colnames(distinct_data) == "member_casual"] <- "user_type"

colnames(distinct_data)

# Filtering outliers to show only ride_duration greater than or equal to 1
# Checking minimum and maximum of ride_duration_mins then filtering

min(distinct_data$ride_duration_mins)
max(distinct_data$ride_duration_mins)

filtered_data = distinct_data %>%
  filter(ride_duration_mins > 1 | ride_duration_mins == 1)
View(filtered_data)

# Ordering by started_at
filtered_data <- filtered_data %>%
  arrange(started_at)

# Rearranging postion of the columns for easy analysis
filtered_data <- filtered_data %>%
  relocate(day_of_week, .before = 3) %>%
  relocate(hour_trip_started, .before = 5) %>%
  relocate(time_of_day, .before = 6) %>%
  relocate(ride_duration_mins, .before = 7)
  
head(filtered_data)

# Data overview and summary
summary(filtered_data)

# Exploratory Data Analysis

# Average ride duration for each user_type(member_casual)
filtered_data %>%
  group_by(user_type) %>%
  summarize(avg_duration = mean(ride_duration_mins, na.rm = TRUE))

# Counting rides by bike type
filtered_data %>%
  group_by(rideable_type) %>%
  summarize(count=n()) %>%
  arrange(desc(count))

# Most popular start_station_name
filtered_data_with_start_station <- filtered_data %>%
  filter(filtered_data$start_station_name != "")

filtered_data_with_start_station %>% 
  group_by(start_station_name) %>%
  summarize(count=n()) %>%
  arrange(desc(count))


# Most popular end_station_name
filtered_data_with_end_station <- filtered_data %>%
  filter(filtered_data$end_station_name != "")

filtered_data_with_end_station %>% 
  group_by(end_station_name) %>%
  summarize(count=n()) %>%
  arrange(desc(count))


# Data Visualisations
# Distribution of Rides by User Type
ggplot(filtered_data, aes(x = user_type, fill = user_type)) +
  geom_bar() +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5, size = 4) +
  labs(
    title = "Distribution of Rides by User Type",
    subtitle = "Comparison between Casual Riders and Annual Members",
    x = "User Type",
    y = "Number of Rides",
    fill = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +
  scale_y_continuous(labels = label_number()
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

# Ride Duration by User Type
ggplot(filtered_data, aes(x = user_type, y = ride_duration_mins, fill = user_type)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 16, outlier.size = 2) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Ride Duration by User Type",
    subtitle = "Comparison of Ride Durations Between Members and Casual Riders",
    x = "User Type",
    y = "Ride Duration (Minutes)",
    fill = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) + 
  scale_y_continuous(labels = label_number()
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  ) 

# by time of day
ggplot(filtered_data, aes(x = user_type, fill = time_of_day)) +
  geom_bar(position = "dodge") +
  geom_text(
    stat = "count",
    aes(label = after_stat(count)),
    position = position_dodge(width = 0.9),
    vjust = -0.5,
    size = 4
  ) +
  labs(
    title = "Ride Distribution by Time of Day",
    subtitle = "Comparing ride distribution across user types during different times of the day",
    x = "User Type",
    y = "Number of Rides",
    fill = "Time of Day",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +
  facet_wrap(~time_of_day) +
  scale_y_continuous(labels = label_number()
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

# Weekly ride trends
filtered_data$day_of_week <- factor(
  filtered_data$day_of_week,
  levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
)

# Grouping data by day of the week and user type
weekly_data <- filtered_data %>%
  group_by(day_of_week, user_type) %>%
  summarise(total_rides = n())

ggplot(weekly_data, aes(x = day_of_week, y = total_rides, fill = user_type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) + 
  geom_text(
    aes(label = total_rides),
    position = position_dodge(width = 0.7),
    vjust = -0.5,
    size = 3
  ) +  
  labs(
    title = "Ride Trends by Day of the Week",
    subtitle = "Weekly patterns in ride usage for casual riders and members",
    x = "Day of the Week",
    y = "Number of Rides",
    fill = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +  annotate(
    "text",
    x = 3,
    y = max(weekly_data$total_rides[weekly_data$user_type == "member"]) * 1.05,
    label = "Wednesday has the highest rides for members",
    color = "darkgreen",
    size = 3,
    hjust = 0
  ) +
  scale_y_continuous(labels = label_number()
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text.x = element_text(size = 12, angle = 45, hjust = 1),
    axis.title = element_text(size = 14)
  )

# Week trends (Weekday vs Weekends)
ggplot(filtered_data, aes(x = ifelse(day_of_week %in% c("Saturday", "Sunday"), "Weekend", "Weekday")
, fill = user_type)) +
  geom_bar(position = "dodge") + 
  geom_text(stat = "count", aes(label = after_stat(count)), position = position_dodge(width = 0.9), vjust = -0.5, size = 4) +
  labs(
    title = "Weekly Ride Trends: Weekday vs. Weekend",
    subtitle = "Observing ride patterns split by user type across weekdays and weekends",
    x = "Day Type",
    y = "Number of Rides",
    fill = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +
  facet_wrap(~user_type, scales = "free_y") +
  scale_y_continuous(labels = label_number()
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )


# Hourly ride trends
hourly_data <- filtered_data %>%
  group_by(hour_trip_started, user_type) %>%
  summarise(total_rides = n(), .groups = "drop")

# Finding peaks for each user type
peaks <- hourly_data %>%
  group_by(user_type) %>%
  filter(total_rides == max(total_rides)) %>%
  ungroup()

ggplot(hourly_data, aes(x = hour_trip_started, y = total_rides, color = user_type, group = user_type)) +
  geom_line(size = 1) +
  geom_point(size = 2) + 
  labs(
    title = "Hourly Ride Trends",
    subtitle = "Peak usage times for casual riders and members throughout the day",
    x = "Hour of the Day",
    y = "Number of Rides",
    color = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +
  
  geom_segment(data = peaks,
               aes(x = hour_trip_started - 0.5, xend = hour_trip_started, 
                   y = total_rides - 50, yend = total_rides), 
               arrow = arrow(length = unit(0.2, "cm")), color = "green") +
  
  geom_text(data = peaks, 
            aes(x = hour_trip_started, y = total_rides + 55, 
                label = paste("Peak:", total_rides, "rides")), 
            color = "black", fontface = "bold", size = 3) +
  scale_y_continuous(labels = label_number()
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

# Top 10 popular start stations

top_stations <- filtered_data_with_start_station %>%
  count(start_station_name, user_type) %>%
  arrange(desc(n)) %>% 
  head(10)
ggplot(top_stations, aes(x = n, y = reorder(start_station_name, n), fill = user_type)) +
  geom_bar(stat = "identity", width = 0.7) +  
  geom_text(aes(label = n), hjust = -0.3, size = 3) +  
  labs(
    title = "Top 10 Popular Start Stations",
    subtitle = "Most frequently used start stations by user type",
    x = "Number of Rides",
    y = "Start Station",
    fill = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +
 
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12, angle = 45, hjust = 1),  
    axis.title = element_text(size = 14)
  ) +
  coord_flip()


# seasonal trends
# Converting 'month' column to a factor with proper levels (January to December)
filtered_data$month <- factor(format(as.Date(filtered_data$started_at), "%B"),
                              levels = c("January", "February", "March", "April", "May", "June", 
                                         "July", "August", "September", "October", "November", "December"))

# Summarizing monthly data by user type using stacked bar chart
# Converting month to an ordered factor from January to December
monthly_data <- filtered_data %>%
  mutate(month = factor(month, levels = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"), 
                                        ordered = TRUE)) %>%
  group_by(month, user_type) %>%
  summarise(total_rides = n(), .groups = "drop")
ggplot(monthly_data, aes(x = month, y = total_rides, fill = user_type)) +
  geom_col(position = "stack", width = 0.7) +  
  geom_text(aes(label = total_rides), position = position_stack(vjust = 0.5), size = 2, color = "white") + 
  labs(
    title = "Monthly Ride Trends",
    subtitle = "Seasonal patterns in rides for casual riders and members",
    x = "Month",
    y = "Number of Rides",
    fill = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +
  annotate(
    "text", x = 7, y = 830000, label = "September shows the highest total rides, with members contributing the most", color = "purple", size = 3, hjust = 0
  ) +
  scale_y_continuous(labels = scales::label_number()) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text.x = element_text(size = 12, angle = 45, hjust = 1),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )

# Distribution over the year
# Creating a new column for Date and extracting the day and month
filtered_data$day_of_year <- as.numeric(format(as.Date(filtered_data$started_at), "%j"))
filtered_data$month <- format(as.Date(filtered_data$started_at), "%B")

# Grouping data by day and user type
daily_data <- filtered_data %>%
  group_by(day_of_year, user_type) %>%
  summarise(total_rides = n(), .groups = "drop")

# Creating a line chart for daily ride distribution across the year
ggplot(daily_data, aes(x = day_of_year, y = total_rides, color = user_type, group = user_type)) +
  geom_line(linewidth = 1.2) +  
  geom_point(size = 2) + 
  labs(
    title = "Daily Ride Distribution Over the Year",
    subtitle = "Trends in ride usage for casual riders and members across the year",
    x = "Months across the year",
    y = "Number of Rides",
    color = "User Type",
    caption = "Data Source: Cyclistic Bike-Share Program"
  ) +
   scale_y_continuous(labels = label_number()
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  ) +
  scale_x_continuous(
    breaks = c(1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335),
    labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")  # Month labels
  ) +
  scale_color_manual(values = c("blue", "darkgreen"))  


