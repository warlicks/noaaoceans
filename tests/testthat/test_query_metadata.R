context("Test Data Types for Metadata Function")

test_that("Data Frame is Returned for Non Resource Call", {
    expect_is(query_metadata('9414290'), 'data.frame')
})

test_that("Data Frame is Returned for Datums Call", {
    expect_is(query_metadata('9414290', 'datums'), 'data.frame')
})

test_that("Data Frame is Returned for Superseded datums Resource Call", {
    expect_is(query_metadata('9075065', 'supersededdatums'), 'data.frame')
})

test_that("Data Frame is Returned for harcon Resource Call", {
    expect_is(query_metadata('1611400', 'harcon'), 'data.frame')
})

test_that("Data Frame is Returned for sensors Resource Call", {
    expect_is(query_metadata('9414290', 'sensors'), 'data.frame')
})

test_that("Data Frame is Returned for details Resource Call", {
    expect_is(query_metadata('9075065', 'details'), 'data.frame')
})

test_that("Data Frame is Returned for notices Resource Call", {
    skip('Skipping until I can find a station with a notice')
    expect_is(query_metadata('1611400', 'notices'), 'data.frame')
})

test_that("Data Frame is Returned for disclaimers Resource Call", {
    skip('Skipping until I can find a station with a notice')
    expect_is(query_metadata('1611400', 'disclaimers'), 'data.frame')
})

test_that("Data Frame is Returned for benchmarks Resource Call", {
    expect_is(query_metadata('9414290', 'benchmarks'), 'data.frame')
})

test_that("Data Frame is Returned for tide prediction offset Resource Call", {
    expect_is(query_metadata('9075065', 'tidepredoffsets'), 'data.frame')
})

test_that("Data Frame is Returned for floodlevels Resource Call", {
    expect_is(query_metadata('9075065', 'floodlevels'), 'data.frame')
})
