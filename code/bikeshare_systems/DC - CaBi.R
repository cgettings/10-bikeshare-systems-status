#################################-
#################################-
##
## DC - CaBi: station status ----
##
#################################-
#################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("Capital Bikeshare (DC)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_dc <-
    get_json_safely("https://gbfs.capitalbikeshare.com/gbfs/en/station_status.json")

if (length(station_status_dc$error) >= 1) {
    error_dc <- TRUE
    cat("\n*ERROR*")
    
} else {
    error_dc <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    # setwd("all_bike_shares")
    
    cabi_db <-
        dbConnect(RSQLite::SQLite(), "data/cabi_db_060118.sqlite3")
    
    col_names <- tbl(cabi_db, "station_status") %>% head(0) %>% colnames()
    
    # cabi_db_1 <-
    #     dbConnect(RSQLite::SQLite(), "data/cabi_db_040118.sqlite3")
    # 
    # col_names <- tbl(cabi_db_1, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_dc_0 <-
        station_status_dc$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_dc_1 <-
        station_status_dc_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)
    
    station_status_dc_2 <-
        station_status_dc_1 %>%
        add_column(
            last_updated = station_status_dc_0$last_updated %>%
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
    
    rm(station_status_dc_1)
    
    #========================================#
    #### Writing to database ####
    #========================================#
    
    dbWriteTable(
        cabi_db,
        "station_status",
        value = station_status_dc_2,
        append = TRUE,
        temporary = FALSE
    )
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_dc_0$last_updated %>% 
            as_datetime(tz = "US/Eastern") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_dc_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_dc_0)
    rm(station_status_dc)
    rm(station_status_dc_2)
    
    ################################################################################
    
    dbDisconnect(cabi_db)
    
    ################################################################################

}

################################################################################
################################################################################
