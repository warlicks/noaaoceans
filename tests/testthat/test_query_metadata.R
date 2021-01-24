context("Test Data Types for Metadata Function")
# Check that each resource call returns a data frame. ----

## We need to make this check because some resources have a
## slightly differnt JSON structure.
test_that("Data Frame is returned for all stations", {
    expect_is(query_metadata(), 'data.frame')
})

test_that("Data Frame is Returned for Non Resource Call", {
    expect_is(query_metadata('9414290'), 'data.frame')
})

test_that("Data Frame is Returned for Datums Call", {
    expect_is(query_metadata('9414290', 'datums'), 'data.frame')
})

test_that("Data Frame is Returned for Superseded datums Resource Call", {
    expect_is(query_metadata('1611347', 'supersededdatums'), 'data.frame')
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
    expect_is(query_metadata('1610367', 'tidepredoffsets'), 'data.frame')
})

test_that("Data Frame is Returned for floodlevels Resource Call", {
    expect_is(query_metadata('1611400', 'floodlevels'), 'data.frame')
})

# Test that data frame is returned when we specify type. ----
test_that("Data Frame is returned for call with type specified", {
    expect_is(query_metadata(type='waterlevels'), 'data.frame')
})

# Test that data frame is returned when ports is specified ----
test_that("Data Frame is returned for call with ports specified", {
    expect_is(query_metadata(ports='ca'), 'data.frame')
})

# Check that error is returned when appropriate ----
test_that("Error for a fake station", {
    expect_error(query_metadata('fake'))
})

test_that("Error for a fake resource", {
    expect_error(query_metadata('9414290', resource = 'fake'))
})

test_that('Error when resource provided but no station id', {
    expect_error(query_metadata(resource='details'))
})
