#' Retrieve Tides Data From NOAA CO-OPS API
#'
#' @param station_id is a character string that provides the a 7 character
#' station id.
#'
#' @param start_date is a character string that specifies the start date for the
#' retrieval  period.  Dates can be specified in the following formats:
#' \emph{yyyyMMdd}, \emph{yyyyMMdd HH:mm}, \emph{MM/dd/yyyy}, or
#' \emph{MM/dd/yyyy HH:mm}.
#'
#' @param end_date is a character string that specifies the end date for the
#' retrieval  period.  Dates can be specified in the following formats:
#' \emph{yyyyMMdd}, \emph{yyyyMMdd HH:mm}, \emph{MM/dd/yyyy}, or
#' \emph{MM/dd/yyyy HH:mm}.
#'
#' @param data_product specifies the data product to be returned.  See
#' \href{https://tidesandcurrents.noaa.gov/api/}{CO-OPS API Documentation} for
#' the available data products.
#'
#' @param units a character string specifying if the data should be returned
#' using metric or English units.  Defaults to \code{'english'}.
#'
#' @param time_zone a character string specifying what time zone information the
#' data should be returned with.  Options include Greenwich Mean Time
#' \code{'gmt'}, Local Standard Time \code{'lst'}, and Local Standard/Local
#' Daylight Time \code{'lst_ldt'}.  Local times refer to the local time of the
#' specified station.  The default is \code{'lst_ldt'}
#'
#' @param datum a character string indicating the datum that should be returned.
#' See \href{https://tidesandcurrents.noaa.gov/api/}{CO-OPS API Documentation}
#' for the available datums.
#'
#' @param interval a character string that specifies the interval for which
#' Meteorological data is returned. The API defaults to every six minutes and
#' does not need to be specified.  Other option include hourly \code{'h'} and
#' \code{'hilo'}.  The retrieval  time period specified by \strong{start_date} and
#' \strong{end_date} to create restrictions on the intervals that can be
#' returned. See
#' \href{https://tidesandcurrents.noaa.gov/api/}{CO-OPS API Documentation} for
#' details
#'
#' @return a data frame.
#' @export
#'
#' @examples
#' \donttest{
#' # Do Not Run
#' a <- query_coops_data('9414290',
#'                       '20170101',
#'                       '20170201',
#'                       'predictions',
#'                        interval = 'hilo',
#'                        datum = 'MLLW')
#' }

query_coops_data <- function(station_id,
                             start_date,
                             end_date,
                             data_product,
                             units = 'english',
                             time_zone = 'lst_ldt',
                             datum = NULL,
                             interval = NULL){

    base_url <- "https://tidesandcurrents.noaa.gov/api/datagetter"

    ## Create a list of all params.
    query_params <- list(station = station_id,
                         begin_date = start_date,
                         end_date = end_date,
                         product = data_product,
                         datum = datum,
                         units = units,
                         time_zone = time_zone,
                         interval = interval,
                         format = 'json')

    # Set up the full url
    query_url <- httr::modify_url(base_url, query = query_params)

    # Execute the API call with a GET request.
    API_call <- httr::GET(query_url)

    # Parsed the returned content as text
    parsed <- httr::content(API_call, as = 'text')

    # Convert the parsed text to a list
    df_list <- jsonlite::fromJSON(parsed,
                                  simplifyDataFrame = TRUE,
                                  flatten = TRUE)

    # Check if the call returned an error message
    if(any(names(df_list) == 'error')){
        stop(df_list$error$message)
    }

    # The data frame is stored as an element in a list. Here we extract it.
    if(data_product == 'predictions'){
        df <- df_list$predictions
    } else{
        df <- df_list$data
    }

    # Add the station ID for record keeping.
    df$station <- rep(station_id, times = nrow(df))

    # Return our data frame.
    return(df)

}
