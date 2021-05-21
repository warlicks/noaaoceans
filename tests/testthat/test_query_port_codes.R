context("Test That Port Codes Query Returns Data Frame")

test_that("Test That Data Frame Returned With No Codes", {
    expect_is(query_port_stations(), 'data.frame')

})

test_that("Test That Data Frame Returned With a Code", {
    expect_is(query_port_stations('ak'), 'data.frame')

})

test_that("Test That List Port Codes Returns a Data Frame",
          {expect_is(list_port_codes(), 'data.frame')
})
