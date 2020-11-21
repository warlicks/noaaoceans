
query_metadata <- function(station_id = NULL,
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

    if (is.null(resource)) {
        resource_name <- 'stations'
    } else {
        resource_name <- resource
    }


    query_params <- list(type = type,
                         #TODO: Setr up expand so its not in the url if not used.
                         expand = paste(expand, collapse = ','),
                         radius = radius,
                         bin = bin,
                         application = "noaaoceans")
    url <- httr::parse_url(base_url)

    query_url <- httr::modify_url(url,
                                  path = c(url$path, station_id, resource),
                                  query = query_params)



    api_response <- httr::GET(query_url)

    # Convert response to json/text then to a data frame.
    content <- httr::content(api_response, as = "text",encoding = "UTF-8")
    df <- jsonlite::fromJSON(content,
                             flatten = TRUE,
                             simplifyDataFrame = TRUE)[[resource_name]]

    return(df)

    }
