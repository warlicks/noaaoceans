#' Parse Sensor Status
#'
#' This is an internal function used by \code{\link{list_stations}}.  It helps
#' gather the status of various station sensors.
#'
#' @param station_nodes is a xml_nodeset from \link[=rvest]{Rvest}.  It provides
#' a list of all the stations and the child nodes.
#' @param data_frame a data frame with columns for the station, its location and
#' all of the sensors.  The sensor columns should be NA.
#'
#' @return a data frame that is used by \code{\link{list_stations}}
#' @keywords internal
#' @noRd
#'
parse_sensor_status <- function(station_nodes, data_frame) {

    for (i in 1:length(station_nodes)) {
        # Find all the parameter tags and the sation id for the current station.
        node_children <- rvest::html_nodes(station_nodes[i], "parameter")
        current_station_id <- rvest::html_attr(station_nodes[i], "id")

        # Find all the sensors for the current station.
        station_sensors <- rvest::html_attrs(node_children)

        # Check that there is at least 1 sensor for the current station.
        # TO DO: Write a unit test for this condidtion.
        if (length(station_sensors) < 1) {
            next
        }

        # Update the data frame with the station status.
        for (j in 1:length(station_sensors)) {
            sensor_name <- station_sensors[[j]]["name"]
            sensor_status <- station_sensors[[j]]["status"]

            # Skip sensors without a name
            if (sensor_name == "") {
                next
            }

             data_frame[data_frame$station_id == current_station_id,
                        sensor_name] <- sensor_status
        }
    }

    return(data_frame)
}
