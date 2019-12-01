#' List Co-Ops Stations With Missing Data Inventory
#'
#' This is an internal function that is used by
#' \code{\link{coops_station_inventory}} to check it the provided id is among
#' the stations where the data inventory is known to be missing. This list is
#' accurate as of November 29, 2019.
#'
#' It would have been preferable to have automated this check, however the heavy
#' use of JavaScript by the station inventory pages has made it difficult to
#' automate these checks without the introduction of more dependencies to the
#' package.  In order to avoid using tools like RSelenium or V8, this check is
#' hard coded this check.
#'
#' @return a vector where each item is a station id where the data inventory is
#'   missing.
#' @keywords internal
#' @noRd
#'
#'
known_missing_inventory <- function() {
    known_missing <- c(8517986, 8545556, 8551911, 8574730, 8664753, 8670674,
                       8761847, 8764401, 9410676, 9414304, 8519461, 8550959,
                       8573928, 8575432, 8665353, 8720376, 8762002, 8767931,
                       9410689)
    return(known_missing)
}
