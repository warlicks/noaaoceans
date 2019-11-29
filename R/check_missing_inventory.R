#' Title
#'
#' @param processed_html
#'
#' @return
#' @keywords internal
#' @noRd
#'
#'
check_missing_inventory <- function(processed_html){
    disabled_nodes <- processed_html %>%
        rvest::html_node(xpath="//ul[@class='dropdown-menu']") %>%
        rvest::html_nodes(xpath = "//li/a[@class='disabled']") %>%
        rvest::html_text()

    return(("Data Inventory" %in% disabled_nodes))
}
