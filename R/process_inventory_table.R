#' Query Data Inventory Page and Process HTML
#'
#' An internal function used by \code{\link{coops_station_inventory}}. It gets
#' the HTML for coops station and parses HTML to find the table with data
#' inventory data. The table is return  as a data frame.
#'
#' @param query_url a character string provideing a URL for the data inventory
#' page of a NOOA CO-OPS station.
#'
#' @return data frame
#'
#' @keywords internal
#' @noRd
#'
#'
process_inventory_table <- function(query_url) {

    # Call URL & process the returned HTML ----
    returned_html <- httr::GET(query_url)
    processed_html <- xml2::read_html(returned_html$content)

    # Parse the HTML ----

    # Find the body of the html
    station_body <- rvest::html_node(processed_html, "body")

    # Find the table node in the body.
    station_table <- rvest::html_node(station_body, "table")

    # Convert the table to a data frame
    inventory_df <- rvest::html_table(station_table)

    # Return data frame
    return(inventory_df)
}
