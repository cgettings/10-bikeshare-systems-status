######################################-
######################################-
##
## NYC - Citibike: station status ----
##
######################################-
######################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Citi Bike (NYC)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_nyc <-
    get_json_safely("https://gbfs.citibikenyc.com/gbfs/en/station_status.json")

if (length(station_status_nyc$error) >= 1) {
    error_nyc <- TRUE
    
} else {
    error_nyc <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    # setwd("all_bike_shares")
    
    citibike_db <- 
        dbConnect(RSQLite::SQLite(), "data/citibike_db_040118.sqlite3")
    
    col_names <- tbl(citibike_db, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_nyc_0 <-
        station_status_nyc$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_nyc_1 <-
        station_status_nyc_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_nyc_2 <-
        station_status_nyc_1 %>%
        add_column(
            last_updated = station_status_nyc_0$last_updated %>%
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
    
    rm(station_status_nyc_1)
    
    #========================================#
    #### Writing to database ####
    #========================================#
    
    dbWriteTable(
        citibike_db,
        "station_status",
        value = station_status_nyc_2,
        append = TRUE,
        temporary = FALSE
    )
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_nyc_0$last_updated %>% 
            as_datetime(tz = "US/Eastern") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_nyc_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_nyc_0)
    rm(station_status_nyc)
    rm(station_status_nyc_2)
    
    ################################################################################
    
    dbDisconnect(citibike_db)
    
    ################################################################################

}

################################################################################
################################################################################
