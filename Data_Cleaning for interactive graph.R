library(tidyverse)
library(dplyr)

df <-
  read_csv("taxi_sample_2017_12.csv")

#df <- df %>% rename(pickup_datetime = tpep_pickup_datetime,
#              dropoff_datetime = tpep_dropoff_datetime)

# data cleaning

df %>% mutate (
  Duration = (dropoff_datetime - pickup_datetime) / 60,
  Average_speed = trip_distance / as.numeric(Duration / 60),
  Fare_rate = fare_amount / trip_distance
) %>% filter(
  between(trip_distance, 0, 30),
  between(fare_amount, 1, 105),
  between(Fare_rate, 1, 11),
  between(passenger_count, 0, 6),
  between(Duration, 2, 120),
  between(Average_speed, 3.1, 55),
  between(total_amount, 0, 300),
  improvement_surcharge >= 0,
  tolls_amount <= 300,
  tip_amount <= 100,
  mta_tax >= 0,
  extra >= 0,
  passenger_count > 0
) -> clean_df

dir.create(file.path('.', 'data'))
write_csv(clean_df, './data/taxi_sample_2017_12_cleaned.csv')