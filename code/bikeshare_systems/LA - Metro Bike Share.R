#############################################-
#############################################-
##
## LA - Metro Bike Share: station status ----
##
#############################################-
#############################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Metro Bike Share (Los Angeles)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_la <-
    get_json_safely("https://gbfs.bcycle.com/bcycle_lametro/station_status.json")

if (length(station_status_la$error) >= 1) {
    error_la <- TRUE
    cat("\n*ERROR*")
    
} else {
    error_la <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    # setwd("all_bike_shares")
    
    metro_bike_share_db <- 
        dbConnect(RSQLite::SQLite(), "data/metro_bike_share_db_060118.sqlite3")
    
    # col_names <- tbl(metro_bike_share_db, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_la_0 <-
        station_status_la$result$content %>%
        read_file() %>%
        fromJSON()
    
     station_status_la_1 <-
         station_status_la_0$data$stations %>% 
         select_if(.predicate = function(x) class(x) != "list")
    
    # rm(col_names)
    
    station_status_la_2 <-
        station_status_la_1 %>%
        add_column(
            last_updated = station_status_la_0$last_updated %>%
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
    
   # rm(station_status_la_1)
    
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
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_la_0$last_updated %>% 
            as_datetime(tz = "US/Pacific") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_la_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_la_0)
    rm(station_status_la)
    rm(station_status_la_2)
    
    ################################################################################
    
    dbDisconnect(metro_bike_share_db)
    
    ################################################################################

}

################################################################################
################################################################################
