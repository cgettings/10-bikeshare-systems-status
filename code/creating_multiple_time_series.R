

library(lubridate)
library(tidyverse)
library(forecast)
library(DBI)
library(RSQLite)
library(tibbletime)

# setwd("~/BASP/R analyses/Bike Share/All Bikeshares/all_bike_shares_april/")

citibike_db <- 
    dbConnect(SQLite(), "./data/citibike_db_april.sqlite3")


station_status_0 <- 
    tbl(citibike_db, "station_status") %>% 
    select(station_id, last_reported, num_docks_available) %>% 
    collect() %>% 
    mutate(last_reported = as_datetime(last_reported, tz = "US/Eastern"))


station_status <- 
    station_status_0 %>% 
    filter(month(last_reported) == 4) %>%
    mutate(last_reported_hourly = floor_date(last_reported, "hours"))

rm(station_status_0)
gc()



station_status_hourly <- 
    station_status %>% 
    group_by(station_id, last_reported_hourly) %>% 
    summarise(mean_station_docks = mean(num_docks_available, na.rm = TRUE)) %>% 
    ungroup() %>% 
    group_by(last_reported_hourly) %>% 
    # summarise(median_hourly_docks = sum(mean_station_docks, na.rm = TRUE))
    # summarise(total_hourly_docks = sum(mean_station_docks, na.rm = TRUE))
    summarise(mean_hourly_docks = mean(mean_station_docks))


station_status_hourly$mean_hourly_docks[station_status_hourly$last_reported_hourly == "2018-04-10 17:00:00"] <- NA
station_status_hourly$mean_hourly_docks[station_status_hourly$last_reported_hourly == "2018-04-11 08:00:00"] <- NA


station_status_hourly %>% ggplot(aes(x = last_reported_hourly, y = mean_hourly_docks)) + geom_line()


station_status_msts <- 
    station_status_hourly %>% 
    filter(last_reported_hourly > "2018-04-11 08:00:00") %$% 
    msts(
        mean_hourly_docks,
        seasonal.periods = c(24, 24 * 7),
        start = c(1, (6 * 24) + 1)
    )

station_status_hourly_msts <- 
    station_status_hourly %>% 
    filter(last_reported_hourly > "2018-04-11 08:00:00") %>%  
    as_tbl_time(index = last_reported_hourly) %>% 
    add_column(msts = station_status_msts)


station_status_tbats <- 
    tbats(station_status_hourly_msts$msts, use.trend = TRUE, use.damped.trend = FALSE)

plot(station_status_tbats)


auto.arima(station_status_hourly_msts$msts)

