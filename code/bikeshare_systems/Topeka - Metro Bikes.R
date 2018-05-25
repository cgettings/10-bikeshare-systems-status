##################################################-
##################################################-
##
## Topeka - Metro Bikes: station status ----
##
##################################################-
##################################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Metro Bikes (Topeka)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_top <-
    get_json_safely("https://topekametrobikes.org/opendata/station_status.json")

if (length(station_status_top$error) >= 1) {
    error_top <- TRUE
    
} else {
    error_top <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    topeka_metro_bikes_db <- 
        dbConnect(RSQLite::SQLite(), "data/topeka_metro_bikes_db_040118.sqlite3")
    
    col_names <- tbl(topeka_metro_bikes_db, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_top_0 <-
        station_status_top$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_top_1 <-
        station_status_top_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_top_2 <-
        station_status_top_1 %>%
        add_column(
            last_updated = station_status_top_0$last_updated %>%
                as_datetime(tz = "US/Central"),
            .before = 1
        ) %>%
        mutate(
            last_reported = as_datetime(last_reported, tz = "US/Central"),
            last_reported_chr = as.character(last_reported)
            # station_id = as.integer(station_id)
        ) %>%
        as_tibble() %>%
        distinct(station_id, last_reported, .keep_all = TRUE)
    
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
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_top_0$last_updated %>% 
            as_datetime(tz = "US/Central") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_top_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_top_0)
    rm(station_status_top)
    rm(station_status_top_2)
    
    ################################################################################
    
    dbDisconnect(topeka_metro_bikes_db)
    
    ################################################################################

}

################################################################################
################################################################################
