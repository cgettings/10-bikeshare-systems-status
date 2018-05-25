
#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_sf <-
    read_json("https://gbfs.fordgobike.com/gbfs/en/station_status.json")

#---------------------------------#
# Connecting to database ----
#---------------------------------#

# setwd("all_bike_shares")

ford_gobike_db <- 
    dbConnect(RSQLite::SQLite(), "data/ford_gobike_db_040118.sqlite3")

#---------------------------------#
#---- Station Status ----
#---------------------------------#

station_status_sf_1 <-
    station_status_sf$data %>%
    flatten() %>%
    map(flatten_dfc) %>%
    bind_rows() %>% 
    select_if(.predicate = function(x) class(x) != "list")

station_status_sf_2 <-
    station_status_sf_1 %>%
    add_column(
        last_updated = station_status_sf$last_updated %>%
            as_datetime(tz = "US/Pacific"),
        .before = 1
    ) %>%
    mutate(
        last_reported = as_datetime(last_reported, tz = "US/Pacific"),
        last_reported_chr = as.character(last_reported),
        station_id = as.integer(station_id)
    ) %>%
    as_tibble() %>%
    distinct(station_id, last_reported, .keep_all = TRUE)

rm(station_status_sf)
rm(station_status_sf_1)

#========================================#
#### Writing to database ####
#========================================#

dbWriteTable(
    ford_gobike_db,
    "station_status",
    value = station_status_sf_2,
    append = TRUE,
    temporary = FALSE
)

rm(station_status_sf_2)

dbDisconnect(ford_gobike_db)

################################################################################
################################################################################
