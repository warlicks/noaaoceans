#' Title
#'
#' @param station_id
#' @param start_date
#' @param end_date
#' @param data_product
#' @param units
#' @param time_zone
#' @param datum
#' @param interval
#'
#' @return
#' @export
#'
#' @examples
query_tides_data <- function(station_id,
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
    api_call <- httr::GET(query_url)

    # Parsed the returned content as text
    parsed <- httr::content(api_call, as = 'text')

    # Convert the parsed text to a list
    df_list <- jsonlite::fromJSON(parsed,
                                  simplifyDataFrame = TRUE,
                                  flatten = TRUE)

    # Check if the call returned an error message
    if(names(df_list) == 'error'){
        stop(df_list$error$message)
    }

    # The data frame is stored as an element in a list. Here we extract it.
    df <- df_list[[1]]

    # Add the station ID for record keeping.
    df$station <- rep(station_id, times = nrow(df))

    # Return our data frame.
    return(df)

}
