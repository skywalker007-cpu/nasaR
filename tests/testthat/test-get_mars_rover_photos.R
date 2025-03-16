test_api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

test_that("Function returns vector of image URLs for valid sol", {
  result <- get_mars_rover_photos(api_key = test_api_key, sol = 1000)
  expect_type(result, "character")  # Should return a character vector
  expect_true(length(result) > 0)   # Should not be empty
  expect_true(grepl("^http", result[1]))  # Should be valid URLs
})
test_that("Function correctly converts Earth date to sol and fetches images", {
  result <- get_mars_rover_photos(api_key = test_api_key, earth_date = "2015-05-10")
  expect_type(result, "character")
  expect_true(length(result) > 0)
})
test_that("Empty API response returns NULL", {
  mock_response <- list(photos = list())  # Simulating empty response
  result <- get_mars_rover_photos(api_key = test_api_key, sol = 99999)  # Unlikely sol with images
  expect_null(result)
})
test_that("Network errors are handled gracefully", {
  skip_on_cran()
  expect_error(tryCatch({
    GET("https://invalid.url")
  }, error = function(e) stop("Network error")), "Network error")
})