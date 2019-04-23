# Load Library
library(dplyr)

# Define Version of function with xml2::read_html instead of httr::get() ----

# Define new process inventory function using read_html
process_inventory_table2 <- function(query_url){
    # Call the url and read the html from the response.
    station_xml <- xml2::read_html(query_url)

    #station_xml <- xml2::read_html(response)

    # Find the body of the html
    station_body <- rvest::html_node(station_xml, 'body')

    # Find the table node in the body.
    station_table <- rvest::html_node(station_body, 'table')

    # Convert the table to a data frame
    inventory_df <- rvest::html_table(station_table)

    # Return data frame
    return(inventory_df)
}

# Define function for getting inventory.
coops_station_inventory2 <- function(id){

    # Set Up URL for the data inventory
    base_url <-   "https://tidesandcurrents.noaa.gov/inventory.html"

    # Modifiy the station for the current URL
    query_params <- list(id = id)
    query_url <- httr::modify_url(base_url, query = query_params)

    # Call the url and read the html from the response.
    inventory_df <- process_inventory_table2(query_url)

    # Check if data was returned.  Try one more time
    if (nrow(inventory_df) == 0) {
        message('First Call Returned No Data. Trying Call Again')
        Sys.sleep(3)
        inventory_df2 <- process_inventory_table(query_url)

        if (nrow(inventory_df2) == 0) {

            warning(paste("No Data Returned for Station Id:", id),
                    call. = FALSE)
        } else {
            return(inventory_df2)
        }

    } else{
        # Return the station data inventory as a data frame.
        return(inventory_df)
    }
}

all_coops <- noaaoceans::list_coops_stations()

names(all_coops)

storage <- list()
storage_rvest <- list()
for (i in 1:5) {
    all_station_id <- all_coops$station_id

    all_inventory <- lapply(all_station_id,
                            coops_station_inventory)

    all_inventory_rvest <- lapply(all_station_id,
                                  coops_station_inventory)


    check_index <- which(lapply(all_inventory, class) == 'character')
    check_index_rvest <- which(lapply(all_inventory_rvest,
                                      class) == 'character')

    missing <- all_station_id[check_index]
    missing_rvest <- all_inventory_rvest[check_index_rvest]

    storage[[i]] <- missing
    storage_rvest[[i]] <- missing_rvest
}

# How many lstations didn't have data on each itteration?
lapply(storage, length)
lapply(storage_rvest, length)

Reduce(sum, lapply(storage, length))
Reduce(sum, lapply(storage_rvest, length))
