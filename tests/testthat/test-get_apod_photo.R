test_that("get_apod returns valid data", {
  key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"
  result <- get_apod_photo(key, show_image = FALSE)
  expect_type(result, "list")
  expect_true(is.character(result$image_url))
})
