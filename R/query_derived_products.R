query_derived_products <- function(station_id=NULL, product_name=NULL, units="metric") {

    if (product_name == "toptenwaterlevels"){
        list_name <- "topTenWaterLevels"
    }

    base_url <- "https://tidesandcurrents.noaa.gov/dpapi/latest/webapi/product.json"

    # Prepare the query & make the request.
    query_params <- list(station = station_id,
                         name = product_name,
                         units = units,
                         application = "noaaoceans")

    query_url <- httr::modify_url(base_url, query = query_params)

    api_response <- httr::GET(query_url)

    # Parsed the returned content as text
    parsed <- httr::content(api_response, as = "text", encoding = "UTF-8")

    # Convert the parsed text to a list
    df_list <- jsonlite::fromJSON(parsed,
                                  simplifyDataFrame = TRUE,
                                  flatten = TRUE)

    return(df_list[[list_name]])

    }
