
/* Average area pickup frequency */

SELECT 
  row_number() over() as cartodb_id,
  ROUND((ts.num_pickups/tz.shape_area)::numeric,2)as avg_area_pickups,
  ts.num_pickups,
  tz.zone,
  tz.borough as Borough,
  tz.the_geom as the_geom,
  tz.the_geom_webmercator
FROM
  (SELECT * FROM nyc_taxi) AS tz
  INNER JOIN
  (SELECT pulocationid,
   count(*) as num_pickups 
   FROM taxi_sample_2017_12_cleaned
   group by pulocationid
  ) AS ts
ON tz.locationid = ts.pulocationid;

/* Average area fare amount */

SELECT 
  row_number() over() as cartodb_id,
  ts.average_fare,
  tz.zone,
  tz.borough as borough,
  tz.the_geom as the_geom,
  tz.the_geom_webmercator
FROM
  (SELECT * FROM nyc_taxi) AS tz
  INNER JOIN
  (SELECT pulocationid,
   ROUND(AVG(total_amount)::numeric,2) as average_fare 
   FROM taxi_sample_2017_12_cleaned
   group by pulocationid
  ) AS ts
ON tz.locationid = ts.pulocationid;

/* Average area duration */

SELECT 
  row_number() over() as cartodb_id,
  ts.average_duration,
  tz.zone,
  tz.borough as borough,
  tz.the_geom as the_geom,
  tz.the_geom_webmercator
FROM
  (SELECT * FROM nyc_taxi) AS tz
  INNER JOIN
  (SELECT pulocationid,
   ROUND(AVG(Duration)::numeric,2) as average_duration 
   FROM taxi_sample_2017_12_cleaned
   group by pulocationid
  ) AS ts
ON tz.locationid = ts.pulocationid;

/* Average area distance */

SELECT 
  row_number() over() as cartodb_id,
  ts.average_distance,
  tz.zone,
  tz.borough as borough,
  tz.the_geom as the_geom,
  tz.the_geom_webmercator
FROM
  (SELECT * FROM nyc_taxi) AS tz
  INNER JOIN
  (SELECT pulocationid,
   ROUND(AVG(trip_distance)::numeric,2) as average_distance 
   FROM taxi_sample_2017_12_cleaned
   group by pulocationid
  ) AS ts
ON tz.locationid = ts.pulocationid;


/* Average area speed */

SELECT 
  row_number() over() as cartodb_id,
  ts.average_speed,
  tz.zone,
  tz.borough as borough,
  tz.the_geom as the_geom,
  tz.the_geom_webmercator
FROM
  (SELECT * FROM nyc_taxi) AS tz
  INNER JOIN
  (SELECT pulocationid,
   ROUND(AVG(Average_speed)::numeric,2) as average_speed 
   FROM taxi_sample_2017_12_cleaned
   group by pulocationid
  ) AS ts
ON tz.locationid = ts.pulocationid;

/* Average area Fare_rate */

SELECT 
  row_number() over() as cartodb_id,
  ts.average_fare_rate,
  tz.zone,
  tz.borough as borough,
  tz.the_geom as the_geom,
  tz.the_geom_webmercator
FROM
  (SELECT * FROM nyc_taxi) AS tz
  INNER JOIN
  (SELECT pulocationid,
   ROUND(AVG(Fare_rate)::numeric,2) as average_fare_rate 
   FROM taxi_sample_2017_12_cleaned
   group by pulocationid
  ) AS ts
ON tz.locationid = ts.pulocationid;


/*Time Series Plot*/
select *,
  row_number() over() as cartodb_id,
  ST_SetSRID(ST_Makepoint(longitude,latitude),4326) as the_geom,
  ST_Transform(ST_SetSRID(ST_Makepoint(longitude,latitude),4326),3857) as the_geom_webmercator
from 
 (SELECT 
      cartodb_id as trip_id, 
      payment_type,
      passenger_count,
      total_amount,
      trip_distance,
      unnest(array['pickup','dropoff' ]) AS ttype,
      unnest(array[pickup_longitude,dropoff_longitude]) as longitude,
      unnest(array[pickup_latitude,dropoff_latitude]) as latitude,
      unnest(array[pickup_datetime,dropoff_datetime]) as datetime,
      round(extract(EPOCH from (dropoff_datetime - pickup_datetime))/60) as duration
  FROM taxi_sample_2016
  order by trip_id
  ) as G
 where longitude between -74.052 and -73.744 and 
 latitude between 40.57 and 40.88 and
 datetime between 
 to_timestamp('2016-01-01','YYYY-MM-DD') and to_timestamp('2016-01-02','YYYY-MM-DD');