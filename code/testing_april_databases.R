#############################################################-
#############################################################-
##
## Testing April databases ----
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
library(RSQLite)

#========================================#
# Connecting to databases ----
#========================================#

relay_bike_share_db     <- dbConnect(SQLite(), "data/relay_bike_share_db_040118_copy.sqlite3")
hubway_db               <- dbConnect(SQLite(), "data/hubway_db_040118_copy.sqlite3")
divvybike_db            <- dbConnect(SQLite(), "data/divvybike_db_040118_copy.sqlite3")
cabi_db                 <- dbConnect(SQLite(), "data/cabi_db_040118_copy.sqlite3")
metro_bike_share_db     <- dbConnect(SQLite(), "data/metro_bike_share_db_040118_copy.sqlite3")
citibike_db             <- dbConnect(SQLite(), "data/citibike_db_040118_copy.sqlite3")
biketown_db             <- dbConnect(SQLite(), "data/biketown_db_040118_copy.sqlite3")
ford_gobike_db          <- dbConnect(SQLite(), "data/ford_gobike_db_040118_copy.sqlite3")
topeka_metro_bikes_db   <- dbConnect(SQLite(), "data/topeka_metro_bikes_db_040118_copy.sqlite3")
bike_share_toronto_db   <- dbConnect(SQLite(), "data/bike_share_toronto_db_040118_copy.sqlite3")


tbl(relay_bike_share_db, "station_status")      %>% head(100) %>% collect() %>% glimpse()
tbl(hubway_db, "station_status")                %>% head(100) %>% collect() %>% glimpse()
tbl(divvybike_db, "station_status")             %>% head(100) %>% collect() %>% glimpse()
tbl(cabi_db, "station_status")                  %>% head(100) %>% collect() %>% glimpse()
tbl(metro_bike_share_db, "station_status")      %>% head(100) %>% collect() %>% glimpse()
tbl(citibike_db, "station_status")              %>% head(100) %>% collect() %>% glimpse()
tbl(biketown_db, "station_status")              %>% head(100) %>% collect() %>% glimpse()
tbl(ford_gobike_db, "station_status")           %>% head(100) %>% collect() %>% glimpse()
tbl(topeka_metro_bikes_db, "station_status")    %>% head(100) %>% collect() %>% glimpse()
tbl(bike_share_toronto_db, "station_status")    %>% head(100) %>% collect() %>% glimpse()

