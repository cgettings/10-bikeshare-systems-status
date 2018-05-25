
#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_chi <-
    read_json("https://gbfs.divvybikes.com/gbfs/en/station_status.json")

#---------------------------------#
# Connecting to database ----
#---------------------------------#

# setwd("all_bike_shares")

divvybike_db <-
    dbConnect(RSQLite::SQLite(), "data/divvybike_db_040118.sqlite3")

#---------------------------------#
#---- Station Status ----
#---------------------------------#

station_status_chi_1 <-
    station_status_chi$data %>%
    flatten() %>%
    map(flatten_dfc) %>%
    bind_rows() %>% 
    select_if(.predicate = function(x) class(x) != "list")

station_status_chi_2 <-
    station_status_chi_1 %>%
    add_column(
        last_updated = station_status_chi$last_updated %>%
            as_datetime(tz = "US/Central"),
        .before = 1
    ) %>%
    mutate(
        last_reported = as_datetime(last_reported, tz = "US/Central"),
        last_reported_chr = as.character(last_reported),
        station_id = as.integer(station_id)
    ) %>%
    as_tibble() %>%
    distinct(station_id, last_reported, .keep_all = TRUE)

rm(station_status_chi)
rm(station_status_chi_1)
	
#========================================#
#### Writing to database ####
#========================================#

dbWriteTable(
    divvybike_db,
    "station_status",
    value = station_status_chi_2,
    append = TRUE,
    temporary = FALSE
)

rm(station_status_chi_2)

dbDisconnect(divvybike_db)

################################################################################
################################################################################
