
#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_top <-
    read_json("https://topekametrobikes.org/opendata/station_status.json")

#---------------------------------#
# Connecting to database ----
#---------------------------------#

# setwd("all_bike_shares")

topeka_metro_bikes_db <- 
    dbConnect(RSQLite::SQLite(), "data/topeka_metro_bikes_db_040118.sqlite3")

#---------------------------------#
#---- Station Status ----
#---------------------------------#

station_status_top_1 <-
    station_status_top$data %>%
    flatten() %>%
    map(flatten_dfc) %>%
    bind_rows() %>% 
    select_if(.predicate = function(x) class(x) != "list")

station_status_top_2 <-
    station_status_top_1 %>%
    add_column(
        last_updated = station_status_top$last_updated %>%
            as_datetime(tz = "US/Eastern"),
        .before = 1
    ) %>%
    mutate(
        last_reported = as_datetime(last_reported, tz = "US/Eastern"),
        last_reported_chr = as.character(last_reported)
        # station_id = as.integer(station_id)
    ) %>%
    as_tibble() %>%
    distinct(station_id, last_reported, .keep_all = TRUE)

rm(station_status_top)
rm(station_status_top_1)

#========================================#
#### Writing to database ####
#========================================#

dbWriteTable(
    topeka_metro_bikes_db,
    "station_status",
    value = station_status_top_2,
    append = TRUE,
    temporary = FALSE
)

rm(station_status_top_2)

dbDisconnect(topeka_metro_bikes_db)

################################################################################
################################################################################
