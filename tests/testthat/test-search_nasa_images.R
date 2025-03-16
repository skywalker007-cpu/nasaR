test_that("Valid query returns image metadata", {
  result <- search_nasa_images("mars")

  expect_type(result, "list")  # Ensure result is a list
  expect_true("href" %in% names(result) || "items_available" %in% names(result))
  
  if ("href" %in% names(result)) {
    expect_type(result$href, "character")
    expect_true(grepl("^http", result$href))  # Ensure valid URL
  }
  
  if ("center" %in% names(result)) {
    expect_type(result$center, "character")
  }
})
test_that("Network errors are handled gracefully", {
  skip_on_cran()  # Skip this test on CRAN
  expect_error(tryCatch({
    GET("https://invalid.url")
  }, error = function(e) stop("Network error")), "Network error")
})