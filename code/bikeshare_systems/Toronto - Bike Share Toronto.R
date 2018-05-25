####################################################-
####################################################-
##
## Toronto - Bike Share Toronto: station status ----
##
####################################################-
####################################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Toronto") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_tor <-
    get_json_safely("https://tor.publicbikesystem.net/ube/gbfs/v1/en/station_status.json")

if (length(station_status_tor$error) >= 1) {
    error_tor <- TRUE
    
} else {
    error_tor <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    bike_share_toronto_db <-
        dbConnect(RSQLite::SQLite(), "data/bike_share_toronto_db_040118.sqlite3")
    
    col_names <- tbl(bike_share_toronto_db, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_tor_0 <-
        station_status_tor$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_tor_1 <-
        station_status_tor_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_tor_2 <-
        station_status_tor_1 %>%
        add_column(
            last_updated = station_status_tor_0$last_updated %>%
                as_datetime(tz = "Canada/Eastern"),
            .before = 1
        ) %>%
        mutate(
            last_reported = as_datetime(last_reported, tz = "Canada/Eastern"),
            last_reported_chr = as.character(last_reported),
            station_id = as.integer(station_id)
        ) %>%
        as_tibble() %>%
        distinct(station_id, last_reported, .keep_all = TRUE)
    
    rm(station_status_tor_1)
    
    #========================================#
    #### Writing to database ####
    #========================================#
    
    dbWriteTable(
        bike_share_toronto_db,
        "station_status",
        value = station_status_tor_2,
        append = TRUE,
        temporary = FALSE
    )
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_tor_0$last_updated %>% 
            as_datetime(tz = "Canada/Eastern") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_tor_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_tor_0)
    rm(station_status_tor)
    rm(station_status_tor_2)
    
    ################################################################################
    
    dbDisconnect(bike_share_toronto_db)
    
    ################################################################################

}

################################################################################
################################################################################
