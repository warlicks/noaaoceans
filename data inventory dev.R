all_coops <- noaaoceans::list_coops_stations()

names(all_coops)

storage <- list()
for(i in 1:5) {
    all_station_id <- all_coops$station_id

    all_inventory <- lapply(all_station_id,
                        coops_station_inventory)


    check_index <- which(lapply(all_inventory, class) == 'character')

    missing <- all_station_id[check_index]

    storage[[i]] <- missing
}
