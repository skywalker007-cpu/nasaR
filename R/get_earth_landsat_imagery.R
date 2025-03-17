#' Get Landsat Earth Imagery
#' Fetches Landsat imagery for a location and date, with optional save.
#'
#' @param api_key NASA API key, defaults to "DEMO_KEY".
#' @param lat Latitude (-90 to 90), required.
#' @param lon Longitude (-180 to 180), required.
#' @param dim Image size in degrees, defaults to 0.025.
#' @param date Date (YYYY-MM-DD), defaults to today.
#' @param cloud_score Include cloud score, defaults to FALSE.
#' @param download_image Save image, defaults to FALSE.
#' @return List with message, file path, and raw image data.
#' @export
get_earth_landsat_imagery <- function(
    api_key = "DEMO_KEY",
    lat = NA,
    lon = NA,
    dim = 0.025,
    date = Sys.Date(),
    cloud_score = FALSE,
    download_image = FALSE
) {
  if (!require(httr)) install.packages("httr")
  if (!require(jsonlite)) install.packages("jsonlite")
  library(httr)
  library(jsonlite)

  base_url <- "https://api.nasa.gov/planetary/earth/imagery"

  if (is.na(lat) || is.na(lon)) {
    stop("Both 'lat' and 'lon' must be provided.")
  }


  if (is.character(date)) {
    date <- as.Date(date)
  } else {
    date <- as.Date(date, origin = "1970-01-01")
  }
  formatted_date <- format(date, "%Y-%m-%d")
  query_params <- list(
    lat = lat,
    lon = lon,
    dim = dim,
    date = formatted_date,
    cloud_score = tolower(as.character(cloud_score)),
    api_key = api_key
  )
  response <- GET(
    url = base_url,
    query = query_params
  )
  if (status_code(response) != 200) {
    stop("Error: Failed to retrieve image. HTTP Status Code: ", status_code(response), "\n",
         content(response, "text"))
  }

  image_data <- content(response, "raw")

  if (download_image) {
    image_file <- paste0("nasa_earth_image_", formatted_date, ".png")
    writeBin(image_data, image_file)
  }

  return(list(
    message = if (download_image) paste("Image saved as:", image_file) else "Image not saved",
    file_path = if (download_image) image_file else NULL,
    raw_data = image_data
  ))
}

api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

result <- get_earth_landsat_imagery(api_key = api_key, lat = 49.93944, lon = -119.39476, date = "2024-06-26", dim = 0.1, download_image = TRUE)
result
