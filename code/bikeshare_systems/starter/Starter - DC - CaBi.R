
#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_dc <-
    read_json("https://gbfs.capitalbikeshare.com/gbfs/en/station_status.json")

#---------------------------------#
# Connecting to database ----
#---------------------------------#

# setwd("all_bike_shares")

cabi_db <-
    dbConnect(RSQLite::SQLite(), "data/cabi_db_040118.sqlite3")

#---------------------------------#
#---- Station Status ----
#---------------------------------#

station_status_dc_1 <-
    station_status_dc$data %>%
    flatten() %>%
    map(flatten_dfc) %>%
    bind_rows() %>% 
    select_if(.predicate = function(x) class(x) != "list")

station_status_dc_2 <-
    station_status_dc_1 %>%
    add_column(
        last_updated = station_status_dc$last_updated %>%
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

rm(station_status_dc)
rm(station_status_dc_1)

#========================================#
#### Writing to database ####
#========================================#

dbWriteTable(
    cabi_db,
    "station_status",
    value = station_status_dc_2,
    append = TRUE,
    temporary = FALSE
)

rm(station_status_dc_2)

dbDisconnect(cabi_db)

################################################################################
################################################################################
