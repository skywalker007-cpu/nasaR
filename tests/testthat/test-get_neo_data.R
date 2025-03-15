test_that("get_neo_data returns valid data", {
  key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"
  result <- get_neo_data("2023-01-01", "2023-01-02", api_key = key)
  expect_s3_class(result, "data.frame")
  expected_columns <- c(
    "date", "id", "name", "absolute_magnitude_h", "estimated_diameter_min_km",
    "estimated_diameter_max_km", "is_potentially_hazardous_asteroid",
    "close_approach_date", "relative_velocity_km_per_sec", "miss_distance_km",
    "orbiting_body"
  )
  expect_named(result, expected_columns)
  if (nrow(result) > 0) {
    expect_type(result$date, "character")
    expect_type(result$id, "character")
    expect_type(result$name, "character")
    expect_type(result$absolute_magnitude_h, "double")
    expect_type(result$estimated_diameter_min_km, "double")
    expect_type(result$estimated_diameter_max_km, "double")
    expect_type(result$is_potentially_hazardous_asteroid, "logical")
    expect_type(result$close_approach_date, "character")
    expect_type(result$relative_velocity_km_per_sec, "double")
    expect_type(result$miss_distance_km, "double")
    expect_type(result$orbiting_body, "character")
  }
})