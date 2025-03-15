#' Get NASA Earth Imagery
#' Fetches and displays a satellite image for given coordinates and date.
#'
#' @param api_key Your NASA API key.
#' @param lat Latitude (-90 to 90).
#' @param lon Longitude (-180 to 180).
#' @param date Date (YYYY-MM-DD), defaults to today.
#' @param dim Image size in degrees, defaults to 0.1.
#' @return List with the saved image file path.
#' @export
get_earth_image <- function(api_key, lat, lon, date = Sys.Date(), dim = 0.1) {
  url <- "https://api.nasa.gov/planetary/earth/imagery"

  response <- httr::GET(url, query = list(
    lat = lat,
    lon = lon,
    date = as.character(date),
    dim = dim,
    api_key = api_key
  ))

  httr::stop_for_status(response)

  # Save the image to a temp file
  temp_file <- tempfile(fileext = ".png")
  writeBin(httr::content(response, as = "raw"), temp_file)

  # Display the image
  img <- png::readPNG(temp_file, native = TRUE)
  grid::grid.raster(img)

  # Return the file path in a list
  return(list(image_path = temp_file))
}


get_earth_image('XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K', lat = 37.7749, lon = -122.4194)
