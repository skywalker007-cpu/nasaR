test_that("get_earth_image returns valid data", {
  key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"
  result <- get_earth_image(key, lat = 37.7749, lon = -122.4194, date = "2022-01-01")
  expect_type(result, "list")
  expect_true("image_path" %in% names(result))
  expect_true(file.exists(result$image_path))
  unlink(result$image_path)
})