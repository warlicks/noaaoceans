process_inventory_table <- function(query_url){
    # Call the url and read the html from the response.
    response <- httr::GET(query_url)

    station_xml <- xml2::read_html(response)

    # Find the body of the html
    station_body <- rvest::html_node(station_xml, 'body')

    # Find the table node in the body.
    station_table <- rvest::html_node(station_body, 'table')

    # Convert the table to a data frame
    inventory_df <- rvest::html_table(station_table)

    # Return data frame
    return(inventory_df)
}
