coops_station_inventory <- function(id){

    # Set Up URL for the data inventory
    base_url <-   "https://tidesandcurrents.noaa.gov/inventory.html"

    # Modifiy the station for the current URL
    query_params <- list(id = id)
    query_url <- httr::modify_url(base_url, query = query_params)

    # Call the url and read the html from the response.
    response <- httr::GET(query_url)
    print(response)
    station_xml <- xml2::read_html(response)

    # Find the body of the html
    station_body <- rvest::html_node(station_xml, 'body')

    # Find the table node in the body.
    station_table <- rvest::html_node(station_body, 'table')

    # Convert the table to a data frame
    inventory_df <- rvest::html_table(station_table)

    ## TODO:CHECK IF DATA WAS RETURNED. ----

    # Return the station data inventory as a data frame.
    return(inventory_df)
}
