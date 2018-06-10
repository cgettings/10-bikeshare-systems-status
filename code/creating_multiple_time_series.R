
#############################################################-
#############################################################-
##
## Creating time series for April & May ----
##
#############################################################-
#############################################################-

#===========================================================#
# Setting up ----
#===========================================================#

#-----------------------------------------------------------#
# Loading libraries ----
#-----------------------------------------------------------#

library(lubridate)
library(tidyverse)
library(forecast)
library(DBI)
library(RSQLite)
library(tibbletime)
library(magrittr)

#-----------------------------------------------------------#
# Loading data from RDS ----
#-----------------------------------------------------------#

### Station status ###

station_status_april <- read_rds("./data/april/station_status_april.rds")
station_status_may   <- read_rds("./data/may/station_status_may.rds")

### Hourly ###

station_status_hourly_april <- read_rds("./data/april/station_status_hourly_april.rds")
station_status_hourly_may   <- read_rds("./data/may/station_status_hourly_may.rds")

#-----------------------------------------------------------#
# Connecting to database ----
#-----------------------------------------------------------#

citibike_april_db <- dbConnect(SQLite(), "./data/april/citibike_db_april.sqlite3")
citibike_may_db   <- dbConnect(SQLite(), "./data/may/citibike_db_may.sqlite3")

#===========================================================#
# Summarizing by hour ----
#===========================================================#

#-----------------------------------------------------------#
# April ----
#-----------------------------------------------------------#

### Pulling out of database ###

station_status_april <- 
    tbl(citibike_april_db, "station_status") %>% 
    select(
        station_id, 
        last_reported, 
        num_docks_available) %>% 
    collect() %>% 
    mutate(last_reported = as_datetime(last_reported, tz = "US/Eastern")) %>% 
    filter(month(last_reported) == 4) %>%
    mutate(last_reported_hourly = floor_date(last_reported, "hours"))

### Writing RDS ###

write_rds(
    station_status_april,
    "./data/april/station_status_april_1.rds",
    compress = "gz",
    compression = 9
)

### Summariing ###

station_status_hourly_april <- 
    station_status_april %>% 
    group_by(station_id, last_reported_hourly) %>% 
    summarise(mean_station_docks = mean(num_docks_available, na.rm = TRUE)) %>% 
    ungroup() %>% 
    group_by(last_reported_hourly) %>% 
    summarise(mean_hourly_docks = mean(mean_station_docks))

station_status_hourly_april <- 
    station_status_hourly_april %>% 
    mutate(mean_hourly_docks = case_when(
        last_reported_hourly %in% 
            c(as_datetime("2018-04-10 17:00:00", tz = "US/Eastern"), 
              as_datetime("2018-04-11 08:00:00", tz = "US/Eastern")) ~ NA_real_, 
        TRUE ~ identity(mean_hourly_docks)
    ))

write_rds(station_status_hourly_april, "./data/april/station_status_hourly_april.rds")

rm(station_status_april)
gc()


#-----------------------------------------------------------#
# May ----
#-----------------------------------------------------------#

### Pulling out of database ###

station_status_may <- 
    tbl(citibike_may_db, "station_status") %>% 
    select(
        station_id, 
        last_reported, 
        num_docks_available) %>% 
    collect() %>% 
    mutate(last_reported = as_datetime(last_reported, tz = "US/Eastern")) %>% 
    filter(month(last_reported) == 5) %>%
    mutate(last_reported_hourly = floor_date(last_reported, "hours"))

### Writing RDS ###

write_rds(
    station_status_may,
    "./data/may/station_status_may.rds",
    compress = "gz",
    compression = 9
)

### Summariing ###

station_status_hourly_may <- 
    station_status_may %>% 
    group_by(station_id, last_reported_hourly) %>% 
    summarise(mean_station_docks = mean(num_docks_available, na.rm = TRUE)) %>% 
    ungroup() %>% 
    group_by(last_reported_hourly) %>% 
    summarise(mean_hourly_docks = mean(mean_station_docks))

write_rds(station_status_hourly_may, "./data/may/station_status_hourly_may.rds")

rm(station_status_may)
gc()


#-----------------------------------------------------------#
# Combining ----
#-----------------------------------------------------------#

station_status_hourly <-
    bind_rows(station_status_hourly_april,
              station_status_hourly_may)

#===========================================================#
# Playing with time series ----
#===========================================================#

station_status_hourly %>% ggplot(aes(x = last_reported_hourly, y = mean_hourly_docks)) + geom_line()

#-----------------------------------------------------------#
# Creating Multi-Seasonal Time Series ----
#-----------------------------------------------------------#

## Creating a multi-seasonal time series with seasonal periods of
##  24 hours, and 7 days (168 hours), with observations every
##  1 hour (freq = 24)


station_status_msts <- 
    station_status_hourly %$%
    msts(
        mean_hourly_docks,
        seasonal.periods = c(24, 24 * 7),
        start = c(0, 1),
        ts.frequency = 24)


### Adding msts column into data frame ###

station_status_hourly_msts <- 
    station_status_hourly %>% 
    as_tbl_time(index = last_reported_hourly) %>% 
    add_column(msts = station_status_msts)


### Fitting TBATS model ###

station_status_tbats <- 
    station_status_hourly_msts %$%
    tbats(msts,
          use.trend = TRUE,
          use.damped.trend = FALSE)


### Plotting TBATS model ###

station_status_tbats %>% plot()


### Fitting multi-seasonal STL decomposition ###

station_status_mstl <- 
    station_status_hourly_msts %$%
    mstl(msts, iterate = 5, lambda = "auto") 


### Plotting MSTL ###

station_status_mstl %>%
    autoplot() +
    theme_minimal()

station_status_mstl %>% plot()


##################################################################
##################################################################
