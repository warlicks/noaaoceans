#' Find All NOAA Stations
#'
#' This function produces a data frame with all NOAA stations.  The list of
#' stations is retrieved  from
#' \href{https://opendap.co-ops.nos.noaa.gov/stations/stationsXML.jsp}{NOAA's}
#' website when the function is called.
#'
#' In the returned data frame there is one row for each station. The name,
#' location and date that the station was established are included as columns.
#' In addition, there are columns that provide the status of various sensors at
#' the station is included.  The column names indicate the type of sensor
#'
#' In the status columns a value of \emph{1} indicates that sensor is working
#' A \emph{0} indicates that the sensor is not working.  If a particular
#' station does not have the capability indicated by the column name, the value
#' provided is \code{NA}
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' # Do Not Run
#' \donttest{
#' station_df <- list_coops_stations()
#' }

list_coops_stations <- function() {
    # Call the URL with station data.
    station_url <- "https://opendap.co-ops.nos.noaa.gov/stations/stationsXML.jsp"
    response <- httr::GET(station_url)
    station_xml <- xml2::read_html(response)

    # Get Station Names
    station_nodes <- rvest::html_nodes(station_xml, "station")
    station_names <- rvest::html_attr(station_nodes, "name")
    station_id <- rvest::html_attr(station_nodes, "id")

    # Parse out the stations location.  We have state, lat and long data to help
    # locate a given station.
    station_lat_nodes <- rvest::html_nodes(station_xml, "lat")
    station_lat <- rvest::html_text(station_lat_nodes)

    station_long_nodes <- rvest::html_nodes(station_xml, "long")
    station_long <- rvest::html_text(station_long_nodes)

    station_state_nodes <- rvest::html_nodes(station_xml, "state")
    station_state <- rvest::html_text(station_state_nodes)

    # Parse the data a station was founded.
    date_established_nodes <- rvest::html_nodes(station_xml, "date_established")
    date_established <- rvest::html_text(date_established_nodes)


    # Create a data frame with the station info.
    station_df <- data.frame(station_id,
                             station_names,
                             station_state,
                             station_lat,
                             station_long,
                             date_established,
                             stringsAsFactors = FALSE)

    # We want to add columns for all the possible sensor names. We start by
    # finding all the parameter nodes.
    parameter_nodes <- rvest::html_nodes(station_xml, "parameter")

    # We then extract all the sensor names and create list of unique names
    sensor_names <- rvest::html_attr(parameter_nodes, "name")
    sensor_names <- unique(sensor_names)
    sensor_names <- sensor_names[sensor_names != ""]

    # We now add the unique sensor names as columns to our data frame.
    station_df[, sensor_names] <- NA

    status_station_df <- parse_sensor_status(station_nodes, station_df)

    #Update column names to make the names consistent
    col_names <- names(status_station_df)
    col_names <- tolower(col_names)
    col_names <- sub(" ", "_", col_names)

    names(status_station_df) <- col_names

    return(status_station_df)
}
