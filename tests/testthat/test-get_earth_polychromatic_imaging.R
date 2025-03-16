test_api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

test_that("Function returns a data frame for valid endpoints", {
    result <- get_earth_polychromatic_imaging(api_key = test_api_key, endpoint = "natural")
    expect_s3_class(result, "data.frame")
})
test_that("Invalid endpoint triggers an error", {
  expect_error(
    get_earth_polychromatic_imaging(api_key = test_api_key, endpoint = "invalid_endpoint"),
    "Invalid endpoint"
  )
})
test_that("Missing date for /date endpoints triggers an error", {
  expect_error(
    get_earth_polychromatic_imaging(api_key = test_api_key, endpoint = "natural/date"),
    "Date parameter is required"
  )
})
test_that("Invalid date format triggers an error", {
  expect_error(
    get_earth_polychromatic_imaging(api_key = test_api_key, endpoint = "natural/date", date = "20230530"),
    "Date must be in YYYY-MM-DD format"
  )
})
test_that("Image is downloaded when download_image = TRUE", {
  skip_on_cran() # Skip this test on CRAN
  result <- get_earth_polychromatic_imaging(
    api_key = test_api_key,
    endpoint = "natural/date",
    date = "2019-05-30",
    download_image = TRUE
  )
  expect_true(file.exists(paste0(result$image[1], ".png")))
  unlink(paste0(result$image[1], ".png")) # Clean up downloaded image
})