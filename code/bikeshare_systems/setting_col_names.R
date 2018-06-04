#############################################################-
#############################################################-
##
## Setting column names ----
##
#############################################################-
#############################################################-

#========================================#
#### Setting up ####
#========================================#

#---------------------------------#
# Loading libraries ----
#---------------------------------#

library(tidyverse)
library(DBI)

#######################################################################

relay_bike_share_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/relay_bike_share_db_040118.sqlite3")

relay_bike_share_col_names <- tbl(relay_bike_share_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(relay_bike_share_col_names, "relay_bike_share_col_names.rds")

#######################################################################

hubway_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/hubway_db_040118.sqlite3")

hubway_col_names <- tbl(hubway_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(hubway_col_names, "hubway_col_names.rds")

#######################################################################

divvybike_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/divvybike_db_040118.sqlite3")

divvybike_col_names <- tbl(divvybike_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(divvybike_col_names, "divvybike_col_names.rds")

#######################################################################

cabi_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/cabi_db_040118.sqlite3")

cabi_col_names <- tbl(cabi_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(cabi_col_names, "cabi_col_names.rds")

#######################################################################

citibike_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/citibike_db_040118.sqlite3")

citibike_col_names <- tbl(citibike_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(citibike_col_names, "citibike_col_names.rds")

#######################################################################

biketown_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/biketown_db_040118.sqlite3")

biketown_col_names <-
    tbl(biketown_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(biketown_col_names, "biketown_col_names.rds")

#######################################################################

ford_gobike_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/ford_gobike_db_040118.sqlite3")

ford_gobike_col_names <- tbl(ford_gobike_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(ford_gobike_col_names, "ford_gobike_col_names.rds")

#######################################################################

topeka_metro_bikes_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/topeka_metro_bikes_db_040118.sqlite3")

topeka_metro_bikes_col_names <- tbl(topeka_metro_bikes_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(topeka_metro_bikes_col_names, "topeka_metro_bikes_col_names.rds")

#######################################################################

bike_share_toronto_db_1 <-
    dbConnect(RSQLite::SQLite(), "data/bike_share_toronto_db_040118.sqlite3")

bike_share_toronto_col_names <- tbl(bike_share_toronto_db_1, "station_status") %>% head(0) %>% colnames()

write_rds(bike_share_toronto_col_names, "bike_share_toronto_col_names.rds")

#######################################################################
