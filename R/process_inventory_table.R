process_inventory_table <- function(query_url){
    # Call URL & process the returned HTML
    returned_html <- httr::GET(query_url)
    processed_html <- xml2::read_html(returned_html$content)

    # Find the body of the html
    station_body <- rvest::html_node(processed_html, 'body')

    # Find the table node in the body.
    station_table <- rvest::html_node(station_body, 'table')

    # Convert the table to a data frame
    inventory_df <- rvest::html_table(station_table)

    # Return data frame
    return(inventory_df)
}
