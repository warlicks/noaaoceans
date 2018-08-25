library(NOAATides)

context('Test Returned Data Types')

test_that('Expect that a properly formed query returns a data frame', {
    expect_is(query_tides_data('9414290',
                               '20170101',
                               '20170201',
                               data_product = 'predictions',
                               interval = 'hilo',
                               datum = 'MLLW'),
                    'data.frame')

})

test_that('Test that the function can properly parse an error message', {
    expect_error(query_tides_data('9414290',
                                  '20170101',
                                  '20170101',
                                  'water_level')
                )
})
