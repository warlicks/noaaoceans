
query_meta_data <- function(station_id = NULL,
                            resource = NULL,
                            type = NULL,
                            units = 'english',
                            expand = NULL,
                            radius = NULL,
                            bin = NULL) {

    base_url <- "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations/"

    # Run checks to make sure we can create a valid API call
    if (!is.null(resource) & is.null(station_id)) {
        stop('If resource argument provided, a station id must be provided')
    }




    query_params <- list(type = type,
                         #TODO: Setr up expand so its not in the url if not used.
                         expand = paste(expand, collapse = ','),
                         radius = radius,
                         bin = bin,
                         application = "noaaoceans")
    url <- httr::parse_url(base_url)

    query_url <- httr::modify_url(url, path = c(url$path, station_id, resource), query = query_params)
    print(query_url)
    api_response <- httr::GET(query_url)
    return(api_response)

    }
