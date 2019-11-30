context("Check Station Data Inventory")

known_bad <- c(8517986, 8545556, 8551911, 8574730, 8664753, 8670674, 8761847,
               8764401, 9410676, 9414304, 8519461, 8550959, 8573928, 8575432,
               8665353, 8720376, 8762002, 8767931, 9410689)

test_that("A data frame is returned", {
    skip_on_cran()
    expect_is(coops_station_inventory("9414290"), "data.frame")
})

test_that("Error is returned with bad station id", {
    skip_on_cran()
    expect_warning(coops_station_inventory("1234"))
})

test_that("No Inventory Station Error Returned", {
    skip_on_cran()
    expect_warning(all(sapply(known_bad,
                           coops_station_inventory
                           )
                    )
                )
})
