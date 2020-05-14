
context("Test Returned Data Types")

# Query Coops Function ----
test_that("Expect that predictions data prodcut query returns a data frame", {
    skip_on_cran()
    expect_is(query_coops_data("9414290",
                               "20170101",
                               "20170201",
                               data_product = "predictions",
                               interval = "hilo",
                               datum = "MLLW"),
              "data.frame")

})

test_that("Test that the function returns a data frame
          for non-prediction data products", {
    skip_on_cran()
    expect_is(query_coops_data("9444900",
                               "20180601 15:00",
                               "20180601 17:00",
                               data_product = "water_temperature",
                               interval = "h"),
              "data.frame")
})

test_that("Test that the function can properly parse an error message", {
    skip_on_cran()
    expect_error(query_coops_data("9414290",
                                  "20170101",
                                  "20170101",
                                  "water_level")
                )
})

# List coops station function ----
test_that("Test that station list returns a data frame", {
    skip_on_cran()
    expect_is(list_coops_stations(), "data.frame")
})

# Derived products api ----
test_that("Derived products function returns a data frame", {
    skip_on_cran()

    # Water levels with and without station ID
    expect_is(query_derived_products(product_name = "toptenwaterlevels"),
              "data.frame")

    expect_is(query_derived_products(product_name = "toptenwaterlevels",
                                     station_id = "1611400"),
              "data.frame")

    # Annual Flood Days
    expect_is(query_derived_products(product_name = "annualflooddays"),
              "data.frame")

    expect_is(query_derived_products(product_name = "annualflooddays",
                                     station_id = "1611400"),
              "data.frame")

    expect_is(query_derived_products(product_name = "annualflooddays",
                                     station_id = "1611400",
                                     year = 2018),
              "data.frame")

    # Extreme Water Levels
    expect_is(query_derived_products(product_name = "extremewaterlevels"),
              "data.frame")

    expect_is(query_derived_products(product_name = "extremewaterlevels",
                                     station_id = "1611400"),
              "data.frame")

    # Sea level trends
    expect_is(query_derived_products(product_name = "sealeveltrends"),
              "data.frame")

    expect_is(query_derived_products(product_name = "sealeveltrends",
                                     station_id = "1611400"),
              "data.frame")
})

test_that('Errors Are Returned With Invalid Opitons', {
    expect_error(query_derived_products(station_id = '1611400',
                                        product_name = 'fake')
                 )
    expect_warning(query_derived_products(station_id = 'notreal',
                                          product_name = 'toptenwaterlevels')
                   )
})
