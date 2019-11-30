#' Gather Co-OPS Station Data History
#'
#' Find the historical data availability for a CO-OPS station.  This data is
#' obtained by scraping the data inventory page for the station. See the page
#' for the#'
#' \href{https://tidesandcurrents.noaa.gov/inventory.html?id=9761115}{Barbuda(station_id=9761115)}
#' as an example.
#'
#' In the returned data frame each row represents a particular oceanographic or
#' meteorological measurement. The name of the measurement is provided in the
#' first column (\strong{Type}). The second column, \strong{From}, provides a
#' timestamp indicating the earliest available data for the measurement. The
#' third column, \strong{To}, provides the last date and time when the
#' measurement is available. When there are gaps in availability there will be
#' two rows from a given measurement. See the table below as an example.
#'
#' \tabular{lcc}{ \strong{Type}  \tab  \strong{From}  \tab  \strong{To}  \cr
#' Wind  \tab  2011-06-10 21:06  \tab  2019-11-30 06:36  \cr Air Temperature
#' \tab  2011-06-10 20:48  \tab  2019-11-30 06:36  \cr Water Temperature  \tab
#' 2011-06-10 20:48  \tab  2013-03-10 03:48  \cr Water Temperature  \tab
#' 2015-04-03 13:06  \tab  2019-11-30 06:36  \cr }
#'
#' As of the release of version 0.20.0 there are thirteen stations where the
#' data inventory is missing and an \strong{Error} will be returned if queried
#' with \code{coops_station_inventory()}. The list of stations without a data
#' inventory can be accessed by calling
#' \code{noaaoceans:::known_missing_inventory()}. Due to heavy use of JavaScript
#' on data inventory pages and a desire to keep package dependencies to a
#' minimum the list of known stations has been hard coded. Please create an
#' \href{https://github.com/warlicks/noaaoceans/issues}{Issue} or
#' \href{https://github.com/warlicks/noaaoceans/pulls}{Pull Request} to update
#' the list stations missing data inventory.
#'
#' @param station_id is a character string that provides the a 7 character
#'   station id.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \donttest{
#'  # Working station to show results.
#'  inventory_df<- coops_station_inventory(station_id=9761115)
#'  print(inventory_df)
#'
#'  # Station with known missing data inventory
#'  coops_station_inventory(station_id=8517986)
#' }
#'

coops_station_inventory <- function(station_id) {
    # Set Up URL for the data inventory
    base_url <- "https://tidesandcurrents.noaa.gov/inventory.html"

    # Modifiy the station for the current URL
    query_params <- list(id = station_id)
    query_url <- httr::modify_url(base_url, query = query_params)

    # Check if station is among those without data inventory.  As of 11/19/19
    # there are 19 stations with missing data inventory. This list was manaually
    # created during development and testing of the package.  I was unable to
    # automate these checks due to heavy use of Java Script on the website.
    if (station_id %in% known_missing_inventory()) {
        warning(paste("Data Inventory Not available For Station ID:",
                      station_id),
                call. = TRUE)
    } else {
        # Call URL and parse the data
        inventory_df <- process_inventory_table(query_url)

        # Check if data was returned.  Try one more time
        if (nrow(inventory_df) == 0) {

            message("First Call Returned No Data. Trying Call Again")
            Sys.sleep(1)
            inventory_df <- process_inventory_table(query_url)

            if (nrow(inventory_df) == 0) {

                warning(paste("No Data Returned for Station Id:",
                              station_id,
                              "\n Manually Check URL in Your Browswer\n",
                              query_url),
                        call. = FALSE)
            } else {
                return(inventory_df)
            }

        } else {
            # Return the station data inventory as a data frame.
            return(inventory_df)
        }
    }
}
