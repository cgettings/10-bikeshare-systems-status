######################################################-
######################################################-
##
## Chicago - Divvy bikes: station status and info ----
##
######################################################-
######################################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Divvy (Chicago)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_chi <-
    get_json_safely("https://gbfs.divvybikes.com/gbfs/en/station_status.json")

if (length(station_status_chi$error) >= 1) {
    error_chi <- TRUE
    cat("\n*ERROR*")
    
} else {
    error_chi <- FALSE
        
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    divvybike_db <-
        dbConnect(RSQLite::SQLite(), "data/divvybike_db_060118.sqlite3")
    
    col_names <- tbl(divvybike_db, "station_status") %>% head(0) %>% colnames()
    
    # divvybike_db_1 <-
    #     dbConnect(RSQLite::SQLite(), "data/divvybike_db_040118.sqlite3")
    # 
    # col_names <- tbl(divvybike_db_1, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_chi_0 <-
        station_status_chi$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_chi_1 <-
        station_status_chi_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_chi_2 <-
        station_status_chi_1 %>%
        add_column(
            last_updated = station_status_chi_0$last_updated %>%
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
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_chi_0$last_updated %>% 
            as_datetime(tz = "US/Central") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_chi_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_chi_0)
    rm(station_status_chi)
    rm(station_status_chi_2)
    
    ################################################################################
    
    dbDisconnect(divvybike_db)
    
    ################################################################################

}

################################################################################
################################################################################
