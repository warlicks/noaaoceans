library(dplyr)
all_coops <- noaaoceans::list_coops_stations()

names(all_coops)

storage <- list()
for (i in 1:5) {
    all_station_id <- all_coops$station_id

    all_inventory <- lapply(all_station_id,
                        coops_station_inventory)


    check_index <- which(lapply(all_inventory, class) == 'character')

    missing <- all_station_id[check_index]

    storage[[i]] <- missing
}

# How many lstations didn't have data on each itteration?
lapply(storage, length)

# Combine the vectors and convert to a data frame
df <- unlist(storage) %>% as.data.frame(stringsAsFactors = FALSE)
names(df) <- c('station_id')

# Count the number of times each station is missing
station_counts <- df %>%
    group_by(station_id) %>%
    summarise(cnt = n())

station_counts %>%
    filter(cnt > 4)

station_counts %>% filter(cnt <= 4)

write.csv(station_counts,
          './no_inventory.csv',
          quote = FALSE,
          row.names = FALSE)


# create a new list with the station id of staiotns where the code didn't error
# every time.  We will run them again using the function above and a modified
# function the uses rvest.

rerun <- station_counts %>%
    filter(cnt <= 4) %>%
    pull(station_id)

# Define new process inventory function using rvest
process_inventory_table2 <- function(query_url){
    # Call the url and read the html from the response.
    station_xml <- xml2::read_html(query_url)

    #station_xml <- xml2::read_html(response)

    # Find the body of the html
    station_body <- rvest::html_node(station_xml, 'body')

    # Find the table node in the body.
    station_table <- rvest::html_node(station_body, 'table')

    # Convert the table to a data frame
    inventory_df <- rvest::html_table(station_table)

    # Return data frame
    return(inventory_df)
}

# Define function for getting inventory.
coops_station_inventory2 <- function(id){

        # Set Up URL for the data inventory
        base_url <-   "https://tidesandcurrents.noaa.gov/inventory.html"

        # Modifiy the station for the current URL
        query_params <- list(id = id)
        query_url <- httr::modify_url(base_url, query = query_params)

        # Call the url and read the html from the response.
        inventory_df <- process_inventory_table2(query_url)

        # Check if data was returned.  Try one more time
        if (nrow(inventory_df) == 0) {
            message('First Call Returned No Data. Trying Call Again')
            Sys.sleep(3)
            inventory_df2 <- process_inventory_table(query_url)

            if (nrow(inventory_df2) == 0) {

                warning(paste("No Data Returned for Station Id:", id),
                        call. = FALSE)
            } else {
                return(inventory_df2)
            }

        } else{
            # Return the station data inventory as a data frame.
            return(inventory_df)
        }
    }

storage_httr <- list()
for (i in 1:5) {
    all_inventory <- lapply(rerun,
                            coops_station_inventory)


    check_index <- which(lapply(all_inventory, class) == 'character')

    missing <- rerun[check_index]

    storage_httr[[i]] <- missing
}

storage_rvest <- list()
for (i in 1:5) {

    all_inventory <- lapply(rerun,
                            coops_station_inventory2)


    check_index <- which(lapply(all_inventory, class) == 'character')

    missing <- rerun[check_index]

    storage_rvest[[i]] <- missing
}

lapply(storage_httr, length)
lapply(storage_rvest, length)

df_httr <- unlist(storage_httr) %>% as.data.frame(stringsAsFactors = FALSE)
names(df_httr) <- c('station_id')

df_rvest <- unlist(storage_rvest) %>% as.data.frame(stringsAsFactors = FALSE)
names(df_rvest) <- c('station_id')

# Count the number of times each station is missing
station_counts_httr <- df_httr %>%
    group_by(station_id) %>%
    summarise(cnt = n())

station_counts_rvest <- df_rvest %>%
    group_by(station_id) %>%
    summarise(cnt = n())
