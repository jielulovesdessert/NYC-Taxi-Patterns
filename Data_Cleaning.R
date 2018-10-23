# install.packages('geosphere')
library(tidyverse)

df <-
  read_csv("taxi_sample_2016.csv", col_types = cols(X1 = col_skip()))
df %>% rename(pickup_datetime = tpep_pickup_datetime,
              dropoff_datetime = tpep_dropoff_datetime) -> df

# data cleaning

df %>% mutate (
  Duration = (dropoff_datetime - pickup_datetime) / 60,
  Average_speed = trip_distance / as.numeric(Duration / 60),
  Fare_rate = fare_amount / trip_distance,
  Euclidean_distance = 0.000621371192 *
    geosphere::distVincentyEllipsoid(p1 = df[, c('pickup_longitude', 'pickup_latitude')],
                                     p2 = df[, c('dropoff_longitude', 'dropoff_latitude')]),
  Winding_factor = trip_distance / Euclidean_distance
) %>% filter(
  between(pickup_longitude, -74.052, -73.7443),
  between(pickup_latitude, 40.57, 40.877),
  between(trip_distance, 0, 30),
  between(fare_amount, 1, 105),
  between(Fare_rate, 1, 11),
  between(passenger_count, 0, 6),
  between(Duration, 2, 120),
  between(Euclidean_distance, 0, 15),
  between(Winding_factor, 0.95, 6),
  between(Average_speed, 3.1, 55),
  between(total_amount, 0, 300),
  improvement_surcharge >= 0,
  tolls_amount <= 300,
  tip_amount <= 100,
  mta_tax >= 0,
  extra >= 0,
  dropoff_longitude < 0,
  passenger_count > 0,
  RatecodeID <= 6,
) -> clean_df

error_rate  <- 1 - dim(clean_df)[1] / dim(df)[1]
print(paste("Filtered erroneous data rate:", as.character(error_rate)))
dir.create(file.path('.', 'data'))
write_csv(clean_df, './data/clean_df.csv')
