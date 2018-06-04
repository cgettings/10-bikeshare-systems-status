#############################################################-
#############################################################-
##
## April citi bike data ----
##
#############################################################-
#############################################################-

#========================================#
# Setting up ----
#========================================#

#----------------------------------------#
# Loading libraries ----
#----------------------------------------#

library(lubridate)
library(tidyverse)
library(DBI)
library(glue)
library(RSQLite)

#----------------------------------------#
# Connecting to databases ----
#----------------------------------------#

citibike_db <- dbConnect(SQLite(), "./data/citibike_db_april.sqlite3")

#----------------------------------------#
# Extracting and cleaning ----
#----------------------------------------#

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
    summarise(total_hourly_docks = sum(mean_station_docks, na.rm = TRUE))


#========================================#
# Plotting overall trend ----
#========================================#

station_status_hourly %>% 
    # ggplot(aes(x = last_reported_hourly, y = median_hourly_docks)) + 
    ggplot(aes(x = last_reported_hourly, y = total_hourly_docks)) +
    geom_line() +
    scale_x_datetime(date_breaks = "day") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90))


station_status_hourly_zoo <- read.zoo(station_status_hourly)

z <- as.ts(station_status_hourly_zoo, frequency = 7)
z <- as.ts(station_status_hourly$total_hourly_docks, frequency = 8760)

tslm(z ~ trend)

zz <- ma(z, order = 24, centre = T)

plot(z)
lines(zz, col = "red")
# plot(as.ts(zz))

zzz <- ma(z, order = 168, centre = T)

lines(zzz, col = "blue")
# plot(as.ts(zzz))


z <- ts(station_status_hourly$total_hourly_docks, deltat = 1/365)

tslm(z ~ trend + season) %>% forecast()













