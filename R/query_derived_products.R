#' Query Data From NOAA's CO-OPS Derived Product API
#'
#' Provides access to data available from NOAA's CO-OPS \href{https://tidesandcurrents.noaa.gov/dpapi/latest/#intro}{Derived Product API}. Four derived data products are available through the API: 1) Top Ten Water Levels, 2) Annual Flood Days, 3) Extreme Water Levels and 4) Sea Level Trends.  More detail about each data product is available with the \href{https://tidesandcurrents.noaa.gov/dpapi/latest/#intro}{API's documentation}
#'
#' @param station_id an optional string that provides the a 7 character station
#' id. If omitted the derived product API returns data for all stations.
#'
#' @param product_name a string providing the name of the derived data product.
#' Derived products include Top Ten Water Levels (\code{'toptenwaterlevels'}),
#' Annual Flood Days (\code{'annualflooddays'}), Extreme Water Levels
#' (\code{'extremewaterlevels'}) and Sea Level Trends (\code{'sealeveltrends'}).
#'
#' @param year an optional string used to limit the results from the annual
#' flood days endpoint to the indicated year. The argument is ignored if used
#' with other data products.
#'
#' @param affil an argument used to limit the results to U.S. (\code{'US'}) or
#' Global stations (\code{'Global'}). The argument is ignored if used with
#' other data products.
#'
#' @param units a character string specifying if the data should be returned
#' using metric or English units. Defaults to \code{'english'}
#'
#' @return a data frame
#'
#' @export
#'
#' @examples

query_derived_products <- function(station_id = NULL,
                                   product_name = NULL,
                                   year = NULL,
                                   affil = NULL,
                                   units = "english") {

    base_url <- "https://tidesandcurrents.noaa.gov/dpapi/latest/webapi/product.json"

    # Set name of the product as returned by the API so we can access the
    # the data by name in the list returned by parsing the data.
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
                         affil = toupper(affil),
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
