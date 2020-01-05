#' Title
#'
#' @param station_id
#' @param product_name
#' @param year
#' @param units
#'
#' @return
#' @export
#'
#' @examples

query_derived_products <- function(station_id = NULL,
                                   product_name = NULL,
                                   year = NULL,
                                   affil = NULL,
                                   units = "metric") {
    base_url <- "https://tidesandcurrents.noaa.gov/dpapi/latest/webapi/product.json"

    if (product_name == "toptenwaterlevels") {
        list_name <- "topTenWaterLevels"
    } else if (product_name == "annualflooddays") {
        list_name <- "annualFloodDays"
    } else if (product_name == "extremewaterlevels") {
        list_name <- "ExtremeWaterLevels"
    } else if (product_name == "sealeveltrends") {
        list_name <- "SeaLvlTrends"
        base_url <- "https://tidesandcurrents.noaa.gov/dpapi/latest/webapi/product/sealvltrends.json"
    }



    # Prepare the query & make the request.
    query_params <- list(station = station_id,
                         name = product_name,
                         year = year,
                         affil = affil,
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
