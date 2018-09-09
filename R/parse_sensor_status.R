#' Title
#'
#' @param station_nodes
#' @param data_frame
#'
#' @return
#' @noRd
#' @keywords internal
#'
#' @examples
parse_sensor_status <- function(station_nodes, data_frame){

    for(i in 1:length(station_nodes)){
        node_children <- rvest::html_nodes(station_nodes[i], 'parameter')
        current_station_id <- rvest::html_attr(station_nodes[i], 'id')
        station_sensors <- rvest::html_attrs(node_children)

        if(length(station_sensors) < 1){
            next()
        }

        for(j in 1:length(station_sensors)){
            sensor_name <- station_sensors[[j]]['name']
            sensor_status <- station_sensors[[j]]['status']

            # Skip sensors without a name
            if(sensor_name == ""){
                next()
            }

             data_frame[data_frame$station_id == current_station_id,
                        sensor_name] <- sensor_status
        }
    }

    return(data_frame)
}
