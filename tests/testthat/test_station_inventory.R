context("Check Station Data Inventory")

test_that('A data frame is returned', {
    skip_on_cran()
    expect_is(coops_station_inventory('9414290'), 'data.frame')
})

test_that('Error is returned with bad station id', {
    skip_on_cran()
    expect_warning(coops_station_inventory('1234'))
})
