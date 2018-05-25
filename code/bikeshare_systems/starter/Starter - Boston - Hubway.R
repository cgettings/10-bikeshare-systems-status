
#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_bos <-
    read_json("https://gbfs.thehubway.com/gbfs/en/station_status.json")

#---------------------------------#
# Connecting to database ----
#---------------------------------#

# setwd("all_bike_shares")

hubway_db <-
    dbConnect(RSQLite::SQLite(), "data/hubway_db_040118.sqlite3")

#---------------------------------#
#---- Station Status ----
#---------------------------------#

station_status_bos_1 <-
    station_status_bos$data %>%
    flatten() %>%
    map(flatten_dfc) %>%
    bind_rows() %>% 
    select_if(.predicate = function(x) class(x) != "list")

station_status_bos_2 <-
    station_status_bos_1 %>%
    add_column(
        last_updated = station_status_bos$last_updated %>%
            as_datetime(tz = "US/Eastern"),
        .before = 1
    ) %>%
    mutate(
        last_reported = as_datetime(last_reported, tz = "US/Eastern"),
        last_reported_chr = as.character(last_reported),
        station_id = as.integer(station_id)
    ) %>%
    as_tibble() %>%
    distinct(station_id, last_reported, .keep_all = TRUE)

rm(station_status_bos)
rm(station_status_bos_1)

#========================================#
#### Writing to database ####
#========================================#

dbWriteTable(
    hubway_db,
    "station_status",
    value = station_status_bos_2,
    append = TRUE,
    temporary = FALSE
)

rm(station_status_bos_2)

dbDisconnect(hubway_db)

################################################################################
################################################################################
