#' Fetch NASA's Astronomy Picture of the Day
#' @param api_key Your NASA API key
#' @param show_image Logical, whether to display the image in the console. Default is TRUE.
#' @return A list with image URL and description
#' @export
get_apod_photo <- function(api_key, show_image = TRUE) {
  response <- httr::GET("https://api.nasa.gov/planetary/apod", query = list(api_key = api_key))
  httr::stop_for_status(response)
  data <- jsonlite::fromJSON(httr::content(response, "text"))

  # read the temp_file image and store it to a variable.
  # make this to skip the test phase for quick check
  if (show_image) {
    # check image extension
    file_extension <- tools::file_ext(data$url)

    # Download image and store it as a temp_file.
    temp_extension <- paste0(".", file_extension)
    temp_file <- tempfile(fileext = temp_extension)
    download.file(data$url, temp_file, mode = "wb")

    if (file_extension %in% c("jpg", "jpeg")) {
      # jpeg/jpg format
      img <- jpeg::readJPEG(temp_file, native = TRUE)
    } else if (file_extension == "png") {
      # png format
      img <- png::readPNG(temp_file, native = TRUE)
    } else {
      stop("Unsupported image format: ", file_extension)
    }
    # show image in console
    grid::grid.raster(img)
  }

  # Return the image URL and description
  list(image_url = data$url, description = data$explanation)
}


key = "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

get_apod_photo(key, show_image = FALSE)
