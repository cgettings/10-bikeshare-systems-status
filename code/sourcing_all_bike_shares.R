#############################################################-
#############################################################-
##
## Sourcing all bike shares ----
##
#############################################################-
#############################################################-

#========================================#
#### Setting up ####
#========================================#

#---------------------------------#
# Loading libraries ----
#---------------------------------#

library(jsonlite)
library(lubridate)
library(tidyverse)
library(DBI)
library(iterators)
library(httr)

#---------------------------------#
# Connecting to database ----
#---------------------------------#

setwd("~/all_bike_shares")

#==========================================#
#### Downloading Station Info & Status ####
#==========================================#

get_json <- function(url, timeout = 5) GET(url, timeout(timeout))

get_json_safely <- safely(get_json)

#---------------------------------#
# Starting Database ----
#---------------------------------#

source("code/bikeshare_systems/starter/Starter - Atlanta - Relay Bike Share.R")
source("code/bikeshare_systems/starter/Starter - Boston - Hubway.R")
source("code/bikeshare_systems/starter/Starter - Chicago - Divvy bikes.R")
source("code/bikeshare_systems/starter/Starter - DC - CaBi.R")
source("code/bikeshare_systems/starter/Starter - LA - Metro Bike Share.R")
source("code/bikeshare_systems/starter/Starter - NYC - Citibike.R")
source("code/bikeshare_systems/starter/Starter - SF - Ford GoBike.R")
source("code/bikeshare_systems/starter/Starter - Portland - BIKETOWN.R")
source("code/bikeshare_systems/starter/Starter - Topeka - Metro Bikes.R")
source("code/bikeshare_systems/starter/Starter - Toronto - Bike Share Toronto.R")

### Continuing ###

## Running continuously during March - June

while (month(now(tzone = "US/Eastern")) %in% c(3, 4, 5, 6) | 
       month(now(tzone = "US/Pacific")) %in% c(3, 4, 5, 6)) {
    
    
    ## Sourcing bikeshare system files on the minute
    
    if (second(round_date(now(tzone = "US/Eastern"), "seconds")) == 0) {
        
        cat("\n=========================================================")
        
        cat("\nNow: ", now(tzone = "US/Eastern") %>% as.character(), "Eastern")
        cat("\nNow: ", now(tzone = "US/Pacific") %>% as.character(), "Pacific")
        
        try(source("code/bikeshare_systems/Atlanta - Relay Bike Share.R"))
        try(source("code/bikeshare_systems/Boston - Hubway.R"))
        try(source("code/bikeshare_systems/Chicago - Divvy bikes.R"))
        try(source("code/bikeshare_systems/DC - CaBi.R"))
        try(source("code/bikeshare_systems/LA - Metro Bike Share.R"))
        try(source("code/bikeshare_systems/NYC - Citibike.R"))
        try(source("code/bikeshare_systems/Portland - BIKETOWN.R"))
        try(source("code/bikeshare_systems/SF - Ford GoBike.R"))
        try(source("code/bikeshare_systems/Topeka - Metro Bikes.R"))
        try(source("code/bikeshare_systems/Toronto - Bike Share Toronto.R"))
        
        
        ## Collecting errors
        
        if (
            any(
                error_atl,
                error_bos,
                error_chi,
                error_dc,
                error_la,
                error_nyc,
                error_por,
                error_sf,
                error_top,
                error_tor
            )
        ) {
            
            
            cat("\n\n#########################################################")
            
            cat("\nRetrying errors with `if` statements\n")
            
            cat("#########################################################\n")
            
            # Retrying errors ----
            
            ## Atlanta - Relay Bike Share ##
            
            if (error_atl == TRUE) {
                
                it_atl <- 0
                icount_atl <- icount()
                
                cat("Atlanta ERROR:\n")
                cat("===============")
                
                ## Retrying downloads with errors, but only 5 times:
                
                while (error_atl == TRUE & it_atl < 5) {
                    
                    it_atl <- nextElem(icount_atl)
                    
                    cat("\n### Try:", it_atl, "###")
                    
                    try(source("code/bikeshare_systems/Atlanta - Relay Bike Share.R"))
                    
                    Sys.sleep(.5)
                }
            }
            
            ## Boston - Hubway ##
            
            if (error_bos == TRUE) {
            
                it_bos <- 0
                icount_bos <- icount()
                cat("\nBoston ERROR:\n")
                cat("===============")
                
                while (error_bos == TRUE & it_bos < 5) {
                    it_bos <- nextElem(icount_bos)
                    cat("\n### Try:", it_bos, "###")
                    try(source("code/bikeshare_systems/Boston - Hubway.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## Chicago - Divvy bikes ##
            
            if (error_chi == TRUE) {
            
                it_chi <- 0
                icount_chi <- icount()
                cat("\nChicago ERROR:\n")
                cat("===============")
                
                while (error_chi == TRUE & it_chi < 5) {
                    it_chi <- nextElem(icount_chi)
                    cat("\n### Try:", it_chi, "###")
                    try(source("code/bikeshare_systems/Chicago - Divvy bikes.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## DC - CaBi ##
            
            if (error_dc == TRUE) {
            
                it_dc <- 0
                icount_dc <- icount()
                cat("DC ERROR:\n")
                cat("===============")
                
                while (error_dc == TRUE & it_dc < 5) {
                    it_dc <- nextElem(icount_dc)
                    cat("\n### Try:", it_dc, "###")
                    try(source("code/bikeshare_systems/DC - CaBi.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## LA - Metro Bike Share ##
            
            if (error_la == TRUE) {
            
                it_la <- 0
                icount_la <- icount()
                cat("\nLA ERROR:\n")
                cat("===============")
                
                while (error_la == TRUE & it_la < 5) {
                    it_la <- nextElem(icount_la)
                    cat("\n### Try:", it_la, "###")
                    try(source("code/bikeshare_systems/LA - Metro Bike Share.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## NYC - Citibike ##
            
            if (error_nyc == TRUE) {
            
                it_nyc <- 0
                icount_nyc <- icount()
                cat("\nNYC ERROR:\n")
                cat("===============")
                
                while (error_nyc == TRUE & it_nyc < 5) {
                    it_nyc <- nextElem(icount_nyc)
                    cat("\n### Try:", it_nyc, "###")
                    try(source("code/bikeshare_systems/NYC - Citibike.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## Portland - BIKETOWN ##
            
            if (error_por == TRUE) {
            
                it_por <- 0
                icount_por <- icount()
                cat("\nPortland ERROR:\n")
                cat("===============")
                
                while (error_por == TRUE & it_por < 5) {
                    it_por <- nextElem(icount_por)
                    cat("\n### Try:", it_por, "###")
                    try(source("code/bikeshare_systems/Portland - BIKETOWN.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## SF - Ford GoBike ##
            
            if (error_sf == TRUE) {
            
                it_sf <- 0
                icount_sf <- icount()
                cat("\nSF ERROR:\n")
                cat("===============")
                
                while (error_sf == TRUE & it_sf < 5) {
                    it_sf <- nextElem(icount_sf)
                    cat("\n### Try:", it_sf, "###")
                    try(source("code/bikeshare_systems/SF - Ford GoBike.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## Topeka - Metro Bikes ##
            
            if (error_top == TRUE) {
            
                it_top <- 0
                icount_top <- icount()
                cat("\nTopeka ERROR:\n")
                cat("===============")
                
                while (error_top == TRUE & it_top < 5) {
                    it_top <- nextElem(icount_top)
                    cat("\n### Try:", it_top, "###")
                    try(source("code/bikeshare_systems/Topeka - Metro Bikes.R"))
                    Sys.sleep(.5)
                }
            }
            
            ## Toronto - Bike Share Toronto ##
            
            if (error_tor == TRUE) {
                
                it_tor <- 0
                icount_tor <- icount()
                cat("\nToronto ERROR:\n")
                cat("===============")
                
                while (error_tor == TRUE & it_tor < 5) {
                    it_tor <- nextElem(icount_tor)
                    cat("\n### Try:", it_tor, "###")
                    try(source("code/bikeshare_systems/Toronto - Bike Share Toronto.R"))
                    Sys.sleep(.5)
                }
            }
            
        }
        
        cat("\n=========================================================\n")
        
    }
    
    
    ## So I don't hit each page 40 times a second:
    
    Sys.sleep(.99)
    
}

###################################################################################
###################################################################################
