#######################################-
#######################################-
##
## Boston - Hubway: station status ----
##
#######################################-
#######################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Hubway (Boston)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_bos <-
    get_json_safely("https://gbfs.thehubway.com/gbfs/en/station_status.json")

if (length(station_status_bos$error) >= 1) {
    error_bos <- TRUE
    
} else {
    error_bos <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    hubway_db <-
        dbConnect(RSQLite::SQLite(), "data/hubway_db_040118.sqlite3")
    
    col_names <- tbl(hubway_db, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_bos_0 <-
        station_status_bos$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_bos_1 <-
        station_status_bos_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_bos_2 <-
        station_status_bos_1 %>%
        add_column(
            last_updated = station_status_bos_0$last_updated %>%
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
    
    rm(station_status_bos_1)
    
    #========================================#
    #### Writing to database ####
    #========================================#
    
    dbWriteTable(
        hubway_db,
        "station_status",
        value = station_status_bos_2,
        append = TRUE,
        temporary = FALSE
    )
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_bos_0$last_updated %>% 
            as_datetime(tz = "US/Eastern") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_bos_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_bos_0)
    rm(station_status_bos)
    rm(station_status_bos_2)
    
    ################################################################################
    
    dbDisconnect(hubway_db)
    
    ################################################################################

}

################################################################################
################################################################################
