library(testthat)
library(vcr)
library(nasaR)

test_api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

vcr_configure(
  dir = "fixtures",
  filter_sensitive_data = list("<NASA_API_KEY>" = test_api_key),
  record = "all"
)

test_that("get_apod_photo fetches Astronomy Picture of the Day", {
  skip_on_cran()

  vcr::use_cassette("get_apod_photo_integration", {
    result <- get_apod_photo(test_api_key, show_image = FALSE)
    expect_type(result, "list")
    expect_true(is.character(result$image_url))
    expect_true(grepl("^http", result$image_url))
  })
})

test_that("get_earth_image fetches satellite imagery", {
  skip_on_cran()

  vcr::use_cassette("get_earth_image_integration", {
    result <- get_earth_image(test_api_key, lat = 37.7749, lon = -122.4194, date = "2022-01-01")
    expect_type(result, "list")
    expect_true("image_path" %in% names(result))
    expect_true(file.exists(result$image_path))
    unlink(result$image_path)
  })
})

test_that("get_mars_weather fetches Mars weather data", {
  skip_on_cran()

  vcr::use_cassette("get_mars_weather_integration", {
    result <- get_mars_weather(test_api_key)
    expect_s3_class(result, "data.frame")
    expect_true(nrow(result) > 0)
    expect_true("sol" %in% names(result))
  })
})

test_that("get_mars_rover_photos fetches rover images", {
  skip_on_cran()

  vcr::use_cassette("get_mars_rover_photos_integration", {
    result <- get_mars_rover_photos(test_api_key, sol = 1000)
    expect_type(result, "character")
    expect_true(length(result) > 0)
    expect_true(grepl("^http", result[1]))
  })
})

test_that("get_earth_polychromatic_imaging fetches EPIC imagery", {
  skip_on_cran()

  vcr::use_cassette("get_earth_polychromatic_integration", {
    # Delete old cassette if it exists: file.remove("fixtures/get_earth_polychromatic_integration.yml")
    result <- get_earth_polychromatic_imaging(test_api_key, endpoint = "natural/date", date = "2019-05-30")
    expect_s3_class(result, "data.frame")
    expect_true(nrow(result) > 0)
    expect_true("image" %in% names(result))
  })
})

test_that("search_nasa_images fetches image metadata", {
  skip_on_cran()

  vcr::use_cassette("search_nasa_images_integration", {
    result <- search_nasa_images("mars")
    expect_type(result, "list")
    expect_true("href" %in% names(result))
    expect_true(grepl("^http", result$href))
  })
})

test_that("get_neo_data fetches asteroid data", {
  skip_on_cran()

  vcr::use_cassette("get_neo_data_integration", {
    result <- get_neo_data("2023-01-01", "2023-01-02", api_key = test_api_key)
    expect_s3_class(result, "data.frame")
    expect_true("id" %in% names(result))
    if (nrow(result) > 0) {
      expect_type(result$relative_velocity_km_per_sec, "double")
    }
  })
})

test_that("get_earth_landsat_imagery fetches Landsat imagery", {
  skip_on_cran()

  vcr::use_cassette("get_earth_landsat_imagery_integration", {
    result <- get_earth_landsat_imagery(test_api_key, lat = 37.7749, lon = -122.4194,
                                        date = "2022-01-01", download_image = FALSE)
    expect_type(result, "list")
    expect_true("raw_data" %in% names(result))
  })
})
