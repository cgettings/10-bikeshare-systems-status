
#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_la <-
    read_json("https://gbfs.bcycle.com/bcycle_lametro/station_status.json")

#---------------------------------#
# Connecting to database ----
#---------------------------------#

# setwd("all_bike_shares")

metro_bike_share_db <- 
    dbConnect(RSQLite::SQLite(), "data/metro_bike_share_db_040118.sqlite3")

#---------------------------------#
#---- Station Status ----
#---------------------------------#

station_status_la_1 <-
    station_status_la$data %>%
    flatten() %>%
    map(flatten_dfc) %>%
    bind_rows() %>% 
    select_if(.predicate = function(x) class(x) != "list")

station_status_la_2 <-
    station_status_la_1 %>%
    add_column(
        last_updated = station_status_la$last_updated %>%
            as_datetime(tz = "US/Pacific"),
        .before = 1
    ) %>%
    mutate(
        last_reported = as_datetime(last_reported, tz = "US/Pacific"),
        last_reported_chr = as.character(last_reported)
        # station_id = as.integer(station_id)
    ) %>%
    as_tibble() %>%
    distinct(station_id, last_reported, .keep_all = TRUE)

rm(station_status_la)
rm(station_status_la_1)

#========================================#
#### Writing to database ####
#========================================#

dbWriteTable(
    metro_bike_share_db,
    "station_status",
    value = station_status_la_2,
    append = TRUE,
    temporary = FALSE
)

rm(station_status_la_2)

dbDisconnect(metro_bike_share_db)

################################################################################
################################################################################
