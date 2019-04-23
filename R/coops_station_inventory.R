coops_station_inventory <- function(id){

    # Set Up URL for the data inventory
    base_url <-   "https://tidesandcurrents.noaa.gov/inventory.html"

    # Modifiy the station for the current URL
    query_params <- list(id = id)
    query_url <- httr::modify_url(base_url, query = query_params)

    # Call the url and read the html from the response.
    inventory_df <- process_inventory_table(query_url)

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
