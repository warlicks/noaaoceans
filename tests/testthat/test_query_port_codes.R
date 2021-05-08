context("Test That Port Codes Query Returns Data Frame")

test_that("Test That Data Frame Returned With No Codes", {
    expect_is(query_port_codes(), 'data.frame')

})

test_that("Test That Data Frame Returned With No Codes", {
    expect_is(query_port_codes('ak'), 'data.frame')

})
