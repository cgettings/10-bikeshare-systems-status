#############################################################-
#############################################################-
##
## Filtering out observations *not* in May ----
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
library(fs)

#----------------------------------------#
# Renaming files ----
#----------------------------------------#

db_names <- dir_ls("./data/") %>% str_subset(".sqlite")

file_copy(
    db_names, 
    paste0(
        str_replace(db_names, "040118", "may") %>% 
            str_replace(., "./data/", "./data/may/"))
    )

#----------------------------------------#
# Connecting to databases ----
#----------------------------------------#

bike_share_toronto_db <- dbConnect(SQLite(), "./data/may/bike_share_toronto_db_may.sqlite3")
cabi_db               <- dbConnect(SQLite(), "./data/may/cabi_db_may.sqlite3")
citibike_db           <- dbConnect(SQLite(), "./data/may/citibike_db_may.sqlite3")
hubway_db             <- dbConnect(SQLite(), "./data/may/hubway_db_may.sqlite3")
relay_db              <- dbConnect(SQLite(), "./data/may/relay_bike_share_db_may.sqlite3")

divvybike_db          <- dbConnect(SQLite(), "./data/may/divvybike_db_may.sqlite3")
topeka_metro_bikes_db <- dbConnect(SQLite(), "./data/may/topeka_metro_bikes_db_may.sqlite3")

biketown_db           <- dbConnect(SQLite(), "./data/may/biketown_db_may.sqlite3")
ford_gobike_db        <- dbConnect(SQLite(), "./data/may/ford_gobike_db_may.sqlite3")
metro_bike_share_db   <- dbConnect(SQLite(), "./data/may/metro_bike_share_db_may.sqlite3")

#========================================#
# Deleting June ----
#========================================#

#----------------------------------------#
# Creating cut point ----
#----------------------------------------#

cut_date_6_e <- as.numeric(as_datetime("2018-06-01 00:00:00", tz = "US/Eastern"))
cut_date_6_c <- as.numeric(as_datetime("2018-06-01 00:00:00", tz = "US/Central"))
cut_date_6_p <- as.numeric(as_datetime("2018-06-01 00:00:00", tz = "US/Pacific"))

#----------------------------------------#
# Deleting non-May observations ----
#----------------------------------------#

dbExecute(bike_share_toronto_db, glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_e}"))
dbExecute(cabi_db,               glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_e}"))
dbExecute(citibike_db,           glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_e}"))
dbExecute(hubway_db,             glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_e}"))
dbExecute(relay_db,              glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_e}"))

dbExecute(divvybike_db,          glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_c}"))
dbExecute(topeka_metro_bikes_db, glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_c}"))

dbExecute(biketown_db,           glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_p}"))
dbExecute(ford_gobike_db,        glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_p}"))
dbExecute(metro_bike_share_db,   glue("DELETE FROM station_status WHERE last_updated >= {cut_date_6_p}"))

#========================================#
# Deleting April ----
#========================================#

#----------------------------------------#
# Creating cut point ----
#----------------------------------------#

cut_date_4_e <- as.numeric(as_datetime("2018-05-01 00:00:00", tz = "US/Eastern"))
cut_date_4_c <- as.numeric(as_datetime("2018-05-01 00:00:00", tz = "US/Central"))
cut_date_4_p <- as.numeric(as_datetime("2018-05-01 00:00:00", tz = "US/Pacific"))

#----------------------------------------#
# Deleting non-May observations ----
#----------------------------------------#

dbExecute(bike_share_toronto_db, glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_e}"))
dbExecute(cabi_db,               glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_e}"))
dbExecute(citibike_db,           glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_e}"))
dbExecute(hubway_db,             glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_e}"))
dbExecute(relay_db,              glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_e}"))

dbExecute(divvybike_db,          glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_c}"))
dbExecute(topeka_metro_bikes_db, glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_c}"))

dbExecute(biketown_db,           glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_p}"))
dbExecute(ford_gobike_db,        glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_p}"))
dbExecute(metro_bike_share_db,   glue("DELETE FROM station_status WHERE last_updated < {cut_date_4_p}"))

#----------------------------------------#
# Cleaning up ----
#----------------------------------------#

dbExecute(bike_share_toronto_db, "VACUUM")
dbExecute(cabi_db,               "VACUUM")
dbExecute(citibike_db,           "VACUUM")
dbExecute(hubway_db,             "VACUUM")
dbExecute(relay_db,              "VACUUM")

dbExecute(divvybike_db,          "VACUUM")
dbExecute(topeka_metro_bikes_db, "VACUUM")

dbExecute(biketown_db,           "VACUUM")
dbExecute(ford_gobike_db,        "VACUUM")
dbExecute(metro_bike_share_db,   "VACUUM")

#----------------------------------------#
# Disconnecting ----
#----------------------------------------#

dbDisconnect(bike_share_toronto_db)
dbDisconnect(cabi_db)
dbDisconnect(citibike_db)
dbDisconnect(hubway_db)
dbDisconnect(relay_db)

dbDisconnect(divvybike_db)
dbDisconnect(topeka_metro_bikes_db)

dbDisconnect(biketown_db)
dbDisconnect(ford_gobike_db)
dbDisconnect(metro_bike_share_db)

##########################################
##########################################
