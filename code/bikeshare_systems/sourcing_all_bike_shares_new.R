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

#---------------------------------#
# Creating safe functions ----
#---------------------------------#

get_json <- function(url, timeout = 5) GET(url, timeout(timeout))

get_json_safely <- safely(get_json)

#---------------------------------#
# Sourcing downloader scripts ----
#---------------------------------#

while (month(now(tzone = "US/Eastern")) %in% c(3, 4, 5, 6, 7) | 
       month(now(tzone = "US/Pacific")) %in% c(3, 4, 5, 6, 7)) {
    
    
    if (second(round_date(now(tzone = "US/Eastern"), "seconds")) == 0) {
        
        cat("\n=========================================================")
        
        cat("\nNow: ", now(tzone = "US/Eastern") %>% as.character(), "Eastern")
        cat("\nNow: ", now(tzone = "US/Pacific") %>% as.character(), "Pacific")
        
        try(source("code/Atlanta - Relay Bike Share.R"))
        try(source("code/Boston - Hubway.R"))
        try(source("code/Chicago - Divvy bikes.R"))
        try(source("code/DC - CaBi.R"))
        try(source("code/LA - Metro Bike Share.R"))
        try(source("code/NYC - Citibike.R"))
        try(source("code/Portland - BIKETOWN.R"))
        try(source("code/SF - Ford GoBike.R"))
        try(source("code/Topeka - Metro Bikes.R"))
        try(source("code/Toronto - Bike Share Toronto.R"))
        
        
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
                
                while (error_atl == TRUE & it_atl < 5) {
                    it_atl <- nextElem(icount_atl)
                    cat("\n### Try:", it_atl, "###")
                    try(source("code/Atlanta - Relay Bike Share.R"))
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
                    try(source("code/Boston - Hubway.R"))
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
                    try(source("code/Chicago - Divvy bikes.R"))
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
                    try(source("code/DC - CaBi.R"))
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
                    try(source("code/LA - Metro Bike Share.R"))
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
                    try(source("code/NYC - Citibike.R"))
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
                    try(source("code/Portland - BIKETOWN.R"))
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
                    try(source("code/SF - Ford GoBike.R"))
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
                    try(source("code/Topeka - Metro Bikes.R"))
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
                    try(source("code/Toronto - Bike Share Toronto.R"))
                    Sys.sleep(.5)
                }
            }
            
        }
        
        cat("\n=========================================================\n")
        
    }
    
    Sys.sleep(.99)
    
}

###################################################################################
###################################################################################
