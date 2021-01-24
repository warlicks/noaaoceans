#' Query CO-OPS API for Station Metadata
#'
#' Provides easy access to the
#' \href{https://api.tidesandcurrents.noaa.gov/mdapi/prod/#intro}{CO-OPS Metadata API}.
#' The api makes information about measurement stations available to users.
#' Information about a single station or a collection of stations can be
#' accessed. Depending on the type of station queried different information is
#' returned.
#'
#' @param station_id an optional string that provides the a 7 character station
#' id. If omitted the derived product API returns data for all stations.
#'
#' @param resource a character string indicating they type of information to
#' request for a specific station. A list of resource identifiers is available
#' in the \href{https://api.tidesandcurrents.noaa.gov/mdapi/prod/#Resource}{API Documentation}
#'
#' @param type a character string indicating the sensor of interest. Specifying
#' a sensor of interest returns a data frame with all stations that have the
#' particular sensor. A list of sensor identifiers is available in the
#' \href{https://api.tidesandcurrents.noaa.gov/mdapi/prod/#Type}{API Documentation}
#'
#' @param ports A two character string indicating specific ports.
#'
#' @param units a character string specifying if the data should be returned
#' using metric or English units. Defaults to \code{'english'}
#'
#' @param radius an optional numeric argument indicating the radius in nautical
#' miles to search for nearby stations
#'
#' @param bin an optional (positive integer) argument to requests for currents
#' station harmonic constituents. If not specified, all the bins will be
#' returned.
#'
#' @return A data frame. The content of the data frame is dependent on the API
#' call. See the API documentation for specifics.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Query a single stations sensors.
#' sensor_df <- query_metadata('9414290', 'sensors')
#'
#' # Query all stations
#' all_stations_df <- query_metadata()
#'}

query_metadata <- function(station_id = NULL,
                           resource = NULL,
                           type = NULL,
                           ports = NULL,
                           units = 'english',
                           radius = NULL,
                           bin = NULL) {

    base_url <- "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations"

    # Run checks to make sure we can create a valid API call
    if (!is.null(resource) & is.null(station_id)) {
        stop('If resource argument provided, a station id must be provided')
    }

    # Set up the named element of the list that has our data frame.
    if (is.null(resource)) {
        resource_name <- 'stations'
    } else if (resource == 'supersededdatums') {
        resource_name <- 'datums'
    } else if (resource == 'harcon') {
        resource_name <- 'HarmonicConstituents'
    } else if (resource %in% c('details', 'tidepredoffsets', 'floodlevels')) {
        resource_name <- NULL
    } else {
        resource_name <- resource
    }

    # Construct URL
    query_params <- list(type = type,
                         ports = ports,
                         radius = radius,
                         bin = bin,
                         application = "noaaoceans")

    url <- httr::parse_url(base_url)
    query_url <- httr::modify_url(url,
                                  path = c(url$path, station_id, resource),
                                  query = query_params)



    api_response <- httr::GET(query_url)
    httr::stop_for_status(api_response)

    # Convert response to json/text then to a data frame.
    content <- httr::content(api_response, as = "text",encoding = "UTF-8")
    if (!is.null(resource_name)) {
        df <- jsonlite::fromJSON(content,
                                 flatten = TRUE,
                                 simplifyDataFrame = TRUE)[[resource_name]]
    } else {
        content_list <- jsonlite::fromJSON(content,
                                           flatten = TRUE,
                                           simplifyDataFrame = TRUE)
        df <- data.frame(rbind(unlist(content_list)))
    }
    return(df)

    }
