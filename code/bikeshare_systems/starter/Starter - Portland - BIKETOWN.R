
#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_por <-
    read_json("https://biketownpdx.socialbicycles.com/opendata/station_status.json")

#---------------------------------#
# Connecting to database ----
#---------------------------------#

# setwd("all_bike_shares")

biketown_db <- 
    dbConnect(RSQLite::SQLite(), "data/biketown_db_040118.sqlite3")

#---------------------------------#
#---- Station Status ----
#---------------------------------#

station_status_por_1 <-
    station_status_por$data %>%
    flatten() %>%
    map(flatten_dfc) %>%
    bind_rows() %>% 
    select_if(.predicate = function(x) class(x) != "list")

station_status_por_2 <-
    station_status_por_1 %>%
    add_column(
        last_updated = station_status_por$last_updated %>%
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

rm(station_status_por)
rm(station_status_por_1)

#========================================#
#### Writing to database ####
#========================================#

dbWriteTable(
    biketown_db,
    "station_status",
    value = station_status_por_2,
    append = TRUE,
    temporary = FALSE
)

rm(station_status_por_2)

dbDisconnect(biketown_db)

################################################################################
################################################################################
