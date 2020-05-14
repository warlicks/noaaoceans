
query_meta_data <- function(station_id = NULL,
                            resource = NULL,
                            type = NULL) {

    base_url <- "http://tidesandcurrents.noaa.gov/mdapi/v1.0/webapi/stations/{station_id}/{resource}.json"

    if (!is.null(resource) & is.null(station_id)) {
        stop('If resource argument provided, a station id must be provided')
    }

    # Prepare URL for API call
    if (!is.null(station_id)) {
       base_url <- sub('{station_id}', station_id, base_url, fixed = TRUE)

       if (!is.null(resource)) {
           base_url <- sub('{resource}', resource, base_url, fixed = TRUE)
       } else {
           base_url <- sub('/{resource}', '', base_url, fixed = TRUE)
       }

    } else {
        base_url <- sub('/{station_id}/{resource}', '', base_url, fixed = TRUE)
    }

    query_params <- list(type = type,
                         application = "noaaoceans")

    query_url <- httr::modify_url(base_url, query = query_params)

    api_response <- httr::GET(query_url)
    return(api_response)

    }
    # # Set name of the product as returned by the API so we can access the
    # # the data by name in the list returned by parsing the data.
    # if (product_name == "toptenwaterlevels") {
    #     list_name <- "topTenWaterLevels"
    # } else if (product_name == "annualflooddays") {
    #     list_name <- "annualFloodDays"
    # } else if (product_name == "extremewaterlevels") {
    #     list_name <- "ExtremeWaterLevels"
    # } else if (product_name == "sealeveltrends") {
    #     list_name <- "SeaLvlTrends"
    #     base_url <- "https://tidesandcurrents.noaa.gov/dpapi/latest/webapi/product/sealvltrends.json"
    # } else {
    #     stop(paste('Invalid Product Name. Should be one of:',
    #                paste(c('toptenwaterlevels', 'annualFloodDays',
    #                        'extremewaterlevels', 'sealeveltrends'),
    #                      collapse = ', '),
    #                sep = ' ')
    #         )
    # }
    #
    #
    #
    # # Prepare the query & make the request.
    # query_params <- list(station = station_id,
    #                      name = product_name,
    #                      year = year,
    #                      affil = toupper(affil),
    #                      units = units,
    #                      application = "noaaoceans")
    #
    # query_url <- httr::modify_url(base_url, query = query_params)
    #
    # api_response <- httr::GET(query_url)
    #
    # # Parsed the returned content as text
    # parsed <- httr::content(api_response, as = "text", encoding = "UTF-8")
    #
    # # Convert the parsed text to a list
    # df_list <- jsonlite::fromJSON(parsed,
    #                               simplifyDataFrame = TRUE,
    #                               flatten = TRUE)
    #
    #
    # if (length(df_list[[list_name]]) == 0) {
    #     warning(paste('No data was returned.',
    #                   'Station ID may be invalid.',
    #                   'Check Station ID and Try Again',
    #                   sep = ' ')
    #             )
    # }
    #
    # return(df_list[[list_name]])

    # }
