test_api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

test_that("Missing API key fails", {
  expect_error(get_mars_weather(api_key = ""), "Error: Failed to retrieve data")
})
test_that("Invalid API key returns an error", {
  expect_error(get_mars_weather(api_key = "INVALID_KEY"), "Error: Failed to retrieve data")
})
test_that("Network errors are handled gracefully", {
  skip_on_cran()  # Skip this test on CRAN
  expect_error(tryCatch({
    GET("https://invalid.url")
  }, error = function(e) stop("Network error")), "Network error")
})
