# 0.2.0
## New Features 
* Added function `coops_station_inventory()` to gather historical data availability for a CO-OPS station.

## Bug Fixes
* Added bin argument to `query_coops_data()` to provide complete functionality with the CO-OPS API. 
* Set encoding to UTF-8 to stop `No encoding supplied: defaulting to UTF-8.` from appearing when using `query_coops_data()`

## Minor Improvments 
* For better world wide compatibility Greenwich Mean Time (GMT) is now the default for the *time_zone* argument in `query_coops_data()`
* `query_coops_data()` is a better citizen and now provides **noaaoceans** as the Application Name when querying the CO-OPS API.

* Fixed typos in vignette. 

# 0.1.0
* First release of the package.
* Functions to find NOAA's CO-OPS stations and query the [CO-OPS API](https://tidesandcurrents.noaa.gov/api/).



