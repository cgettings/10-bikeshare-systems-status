###########################################-
###########################################-
##
## Portland - BIKETOWN: station status ----
##
###########################################-
###########################################-

#========================================#
#### Setting up ####
#========================================#

cat("\n---------------------------------------------------------\n")
cat("BIKETOWN (Portland)") 

#==========================================#
#### Downloading Station Status ####
#==========================================#

station_status_por <-
    get_json_safely("https://biketownpdx.socialbicycles.com/opendata/station_status.json")

if (length(station_status_por$error) >= 1) {
    error_por <- TRUE
    cat("\n*ERROR*")
    
} else {
    error_por <- FALSE
    
    #---------------------------------#
    # Connecting to database ----
    #---------------------------------#
    
    # setwd("all_bike_shares")
    
    biketown_db <- 
        dbConnect(RSQLite::SQLite(), "data/biketown_db_060118.sqlite3")
    
    col_names <- tbl(biketown_db, "station_status") %>% head(0) %>% colnames()
    
    # biketown_db_1 <-
    #     dbConnect(RSQLite::SQLite(), "data/biketown_db_040118.sqlite3")
    # 
    # col_names <-
    #     tbl(biketown_db_1, "station_status") %>% head(0) %>% colnames()
    
    #---------------------------------#
    #---- Station Status ----
    #---------------------------------#
    
    station_status_por_0 <-
        station_status_por$result$content %>%
        read_file() %>%
        fromJSON()
    
    station_status_por_1 <-
        station_status_por_0$data$stations %>%
        select(one_of(col_names))
    
    rm(col_names)

    station_status_por_2 <-
        station_status_por_1 %>%
        add_column(
            last_updated = station_status_por_0$last_updated %>%
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
    
    rm(station_status_por_1)
    
    #========================================#
    #### Writing to database ####
    #========================================#
    
    dbWriteTable(
        biketown_db,
        "station_status",
        value = station_status_por_2,
        append = TRUE,
        temporary = FALSE
    )
    
    #========================================#
    #### Update Info ####
    #========================================#
    
    cat("\nLast updated:", 
        station_status_por_0$last_updated %>% 
            as_datetime(tz = "US/Pacific") %>% 
            as.character(), 
        "\n")
    
    cat(nrow(station_status_por_2), "rows added", "\n")
    
    cat("---------------------------------------------------------")
    
    rm(station_status_por_0)
    rm(station_status_por)
    rm(station_status_por_2)
    
    ################################################################################
    
    dbDisconnect(biketown_db)
    
    ################################################################################

}

################################################################################
################################################################################
