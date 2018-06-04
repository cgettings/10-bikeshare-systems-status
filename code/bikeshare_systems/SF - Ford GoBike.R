#########################################-
#########################################-
##
## FSF - Ford GoBike: station status ----
##
#########################################-
#########################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Ford GoBike (San Francisco)") 

#==========================================#
#### Downloading Station Info & Status ####
#==========================================#

station_status_sf <-
    get_json_safely("https://gbfs.fordgobike.com/gbfs/en/station_status.json")

if (length(station_status_sf$error) >= 1) {
    error_sf <- TRUE
    cat("\n*ERROR*")
    
} else {
    error_sf <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    ford_gobike_db <- 
        dbConnect(RSQLite::SQLite(), "data/ford_gobike_db_060118.sqlite3")
    
    col_names <- tbl(ford_gobike_db, "station_status") %>% head(0) %>% colnames()
    
    # ford_gobike_db_1 <-
    #     dbConnect(RSQLite::SQLite(), "data/ford_gobike_db_040118.sqlite3")
    # 
    # col_names <- tbl(ford_gobike_db_1, "station_status") %>% head(0) %>% colnames()
    
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_sf_0 <-
        station_status_sf$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_sf_1 <-
        station_status_sf_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_sf_2 <-
        station_status_sf_1 %>%
        add_column(
            last_updated = station_status_sf_0$last_updated %>%
                as_datetime(tz = "US/Pacific"),
            .before = 1
        ) %>%
        mutate(
            last_reported = as_datetime(last_reported, tz = "US/Pacific"),
            last_reported_chr = as.character(last_reported),
            station_id = as.integer(station_id)
        ) %>%
        as_tibble() %>%
        distinct(station_id, last_reported, .keep_all = TRUE)
    
    rm(station_status_sf_1)
    
    #========================================#
    #### Writing to database ####
    #========================================#
    
    dbWriteTable(
        ford_gobike_db,
        "station_status",
        value = station_status_sf_2,
        append = TRUE,
        temporary = FALSE
    )
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_sf_0$last_updated %>% 
            as_datetime(tz = "US/Pacific") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_sf_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_sf_0)
    rm(station_status_sf)
    rm(station_status_sf_2)
    
    ################################################################################
    
    dbDisconnect(ford_gobike_db)
    
    ################################################################################

}

################################################################################
################################################################################
