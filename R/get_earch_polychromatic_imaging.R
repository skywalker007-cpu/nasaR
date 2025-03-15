#' Get EPIC Earth Imagery
#' Fetches EPIC imagery metadata or downloads an image by endpoint and date.
#'
#' @param api_key NASA API key, defaults to "DEMO_KEY".
#' @param endpoint EPIC endpoint (e.g., "natural"), defaults to "natural".
#' @param date Date (YYYY-MM-DD), optional unless using /date endpoint.
#' @param download_image Save image for /date endpoints, defaults to FALSE.
#' @return Data frame with metadata or dates, or NULL if no data.
#' @export
get_earch_polychromatic_imaging <- function(
    api_key = "DEMO_KEY",
    endpoint = "natural",
    date = NULL,
    download_image = FALSE
) {
  if (!require(httr)) install.packages("httr")
  if (!require(jsonlite)) install.packages("jsonlite")
  if (!require(dplyr)) install.packages("dplyr")
  library(httr)
  library(jsonlite)
  library(dplyr)

  base_url <- "https://api.nasa.gov/EPIC/api/"

  # Validate endpoint
  valid_endpoints <- c("natural", "natural/date", "natural/all", "natural/available",
                       "enhanced", "enhanced/date", "enhanced/all", "enhanced/available")
  if (!endpoint %in% valid_endpoints) {
    stop("Invalid endpoint. Must be one of: ", paste(valid_endpoints, collapse = ", "))
  }

  # Construct the full URL based on endpoint
  url <- paste0(base_url, endpoint)

  # Handle date parameter
  query_params <- list(api_key = api_key)
  if (grepl("/date$", endpoint) && is.null(date)) {
    stop("Date parameter is required for /date endpoints (e.g., natural/date or enhanced/date).")
  }
  if (!is.null(date)) {
    if (!grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", date)) {
      stop("Date must be in YYYY-MM-DD format (e.g., 2019-05-30).")
    }
    query_params$date <- date
  }

  response <- GET(
    url = url,
    query = query_params
  )
  if (status_code(response) != 200) {
    stop("Error: Failed to retrieve metadata. HTTP Status Code: ", status_code(response), "\n",
         content(response, "text"))
  }
  epic_data <- fromJSON(content(response, "text", encoding = "UTF-8"))

  if (endpoint %in% c("natural", "enhanced")) {
    if (length(epic_data) == 0) {
      warning("No data available for the most recent imagery.")
      return(NULL)
    }
    epic_df <- as.data.frame(epic_data, stringsAsFactors = FALSE)
  } else if (endpoint %in% c("natural/date", "enhanced/date")) {
    if (length(epic_data) == 0) {
      warning("No data available for the specified date.")
      return(NULL)
    }
    epic_df <- as.data.frame(epic_data, stringsAsFactors = FALSE)
    if (download_image && nrow(epic_df) > 0) {
      # Download the first image as an example
      first_image <- epic_df[1, ]
      image_date <- as.Date(substr(first_image$date, 1, 10))  # Extract date part (YYYY-MM-DD)
      image_name <- first_image$image
      image_type <- ifelse(grepl("^natural", endpoint), "natural", "enhanced")

      # Construct the image URL
      image_url <- sprintf(
        "https://api.nasa.gov/EPIC/archive/%s/%s/png/%s.png?api_key=%s",
        image_type,
        format(image_date, "%Y/%m/%d"),
        image_name,
        api_key
      )

      # Print the URL for debugging
      message("Attempting to download image from: ", image_url)

      # Attempt to download the image
      image_file <- paste0(image_name, ".png")
      response_img <- tryCatch({
        GET(image_url, write_disk(image_file, overwrite = TRUE))
      }, error = function(e) {
        warning("Error downloading image: ", e$message)
        return(NULL)
      })

      if (is.null(response_img)) {
        warning("Failed to download image due to a network or file error.")
      } else if (status_code(response_img) == 200) {
        message("Image successfully downloaded as ", image_file)
      } else {
        warning("Failed to download image. HTTP Status Code: ", status_code(response_img), "\n",
                content(response_img, "text"))
      }
    }
  } else if (endpoint %in% c("natural/all", "natural/available", "enhanced/all", "enhanced/available")) {
    if (length(epic_data) == 0) {
      warning("No available dates found.")
      return(NULL)
    }
    epic_df <- data.frame(date = unlist(epic_data), stringsAsFactors = FALSE)
  } else {
    stop("Unsupported endpoint type for data processing.")
  }
  return(epic_df)
}

api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"
natural_date <- get_earch_polychromatic_imaging(
  endpoint = "natural/date",
  date = "2019-05-30",
  api_key = api_key,
  download_image = TRUE
)

