##################################################-
##################################################-
##
## Atlanta - Relay Bike Share: station status ----
##
##################################################-
##################################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Relay (Atlanta)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_atl <- 
    get_json_safely("https://relaybikeshare.socialbicycles.com/opendata/station_status.json")

if (length(station_status_atl$error) >= 1) {
    error_atl <- TRUE
    
} else {
    error_atl <- FALSE
        
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    relay_bike_share_db <- 
        dbConnect(RSQLite::SQLite(), "data/relay_bike_share_db_040118.sqlite3")
    
    col_names <- tbl(relay_bike_share_db, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_atl_0 <-
        station_status_atl$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_atl_1 <-
        station_status_atl_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_atl_2 <-
        station_status_atl_1 %>%
        add_column(
            last_updated = station_status_atl_0$last_updated %>%
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
    
    rm(station_status_atl_1)
    
    #========================================#
    #### Writing to database ####
    #========================================#
    
    dbWriteTable(
        relay_bike_share_db,
        "station_status",
        value = station_status_atl_2,
        append = TRUE,
        temporary = FALSE
    )
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_atl_0$last_updated %>% 
            as_datetime(tz = "US/Eastern") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_atl_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_atl_0)
    rm(station_status_atl)
    rm(station_status_atl_2)
    
    ################################################################################
    
    dbDisconnect(relay_bike_share_db)
    
    ################################################################################

}

################################################################################
################################################################################
