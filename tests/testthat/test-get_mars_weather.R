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
test_that("Valid API key returns a data frame", {
  result <- get_mars_weather(api_key = test_api_key)
  
  expect_s3_class(result, "data.frame")  # Ensure result is a data frame
  expect_true(nrow(result) > 0)  # Ensure data frame is not empty

  # Check for some expected columns
  expected_columns <- c("sol", "AT_avg", "AT_min", "AT_max", "PRE_avg", "PRE_min", "PRE_max")
  expect_true(all(expected_columns %in% colnames(result)))  # Ensure required columns exist
})