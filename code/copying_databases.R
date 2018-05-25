#############################################################-
#############################################################-
##
## Copying databases ----
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

#========================================#
#### Copying ####
#========================================#

#---------------------------------#
# Atlanta - Relay Bike Share ----
#---------------------------------#

relay_db <- 
    dbConnect(RSQLite::SQLite(), "data/relay_bike_share_db_040118.sqlite3")

relay_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/relay_bike_share_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(relay_db, relay_db_copy)

dbDisconnect(relay_db)
dbDisconnect(relay_db_copy)

#---------------------------------#
# Boston - Hubway ----
#---------------------------------#

hubway_db <- 
    dbConnect(RSQLite::SQLite(), "data/hubway_db_040118.sqlite3")

hubway_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/hubway_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(hubway_db, hubway_db_copy)

dbDisconnect(hubway_db)
dbDisconnect(hubway_db_copy)

#---------------------------------#
# Chicago - Divvy bikes ----
#---------------------------------#

divvybike_db <- 
    dbConnect(RSQLite::SQLite(), "data/divvybike_db_040118.sqlite3")

divvybike_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/divvybike_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(divvybike_db, divvybike_db_copy)

dbDisconnect(divvybike_db)
dbDisconnect(divvybike_db_copy)

#---------------------------------#
# DC - CaBi ----
#---------------------------------#

cabi_db <- 
    dbConnect(RSQLite::SQLite(), "data/cabi_db_040118.sqlite3")

cabi_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/cabi_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(cabi_db, cabi_db_copy)

dbDisconnect(cabi_db)
dbDisconnect(cabi_db_copy)

#---------------------------------#
# LA - Metro Bike Share ----
#---------------------------------#

metro_bike_share_db <- 
    dbConnect(RSQLite::SQLite(), "data/metro_bike_share_db_040118.sqlite3")

metro_bike_share_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/metro_bike_share_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(metro_bike_share_db, metro_bike_share_db_copy)

dbDisconnect(metro_bike_share_db)
dbDisconnect(metro_bike_share_db_copy)

#---------------------------------#
# NYC - Citibike ----
#---------------------------------#

citibike_db <- 
    dbConnect(RSQLite::SQLite(), "data/citibike_db_040118.sqlite3")

citibike_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/citibike_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(citibike_db, citibike_db_copy)

dbDisconnect(citibike_db)
dbDisconnect(citibike_db_copy)

#---------------------------------#
# Portland - BIKETOWN ----
#---------------------------------#

biketown_db <- 
    dbConnect(RSQLite::SQLite(), "data/biketown_db_040118.sqlite3")

biketown_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/biketown_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(biketown_db, biketown_db_copy)

dbDisconnect(biketown_db)
dbDisconnect(biketown_db_copy)

#---------------------------------#
# SF - Ford GoBike ----
#---------------------------------#

ford_gobike_db <- 
    dbConnect(RSQLite::SQLite(), "data/ford_gobike_db_040118.sqlite3")

ford_gobike_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/ford_gobike_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(ford_gobike_db, ford_gobike_db_copy)

dbDisconnect(ford_gobike_db)
dbDisconnect(ford_gobike_db_copy)

#---------------------------------#
# Topeka - Metro Bikes ----
#---------------------------------#

topeka_metro_bikes_db <- 
    dbConnect(RSQLite::SQLite(), "data/topeka_metro_bikes_db_040118.sqlite3")

topeka_metro_bikes_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/topeka_metro_bikes_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(topeka_metro_bikes_db, topeka_metro_bikes_db_copy)

dbDisconnect(topeka_metro_bikes_db)
dbDisconnect(topeka_metro_bikes_db_copy)

#---------------------------------#
# Toronto - Bike Share Toronto ----
#---------------------------------#

bike_share_toronto_db <- 
    dbConnect(RSQLite::SQLite(), "data/bike_share_toronto_db_040118.sqlite3")

bike_share_toronto_db_copy <- 
    dbConnect(RSQLite::SQLite(), "data/bike_share_toronto_db_040118_copy.sqlite3")

RSQLite::sqliteCopyDatabase(bike_share_toronto_db, bike_share_toronto_db_copy)

dbDisconnect(bike_share_toronto_db)
dbDisconnect(bike_share_toronto_db_copy)

########################################
########################################
