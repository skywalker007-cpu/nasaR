#' Get Mars Rover Photos
#' Fetches image URLs from NASA’s Curiosity Rover for a given sol or Earth date.
#'
#' @param api_key NASA API key.
#' @param sol Integer for Martian sol (day), optional.
#' @param earth_date Date (YYYY-MM-DD) or Date object, optional.
#' @return Vector of image URLs, or NULL if fetch fails.
#' @export
get_mars_rover_photos <- function(api_key, sol = NULL, earth_date = NULL) {
  if (!require(httr)) install.packages("httr")
  if (!require(jsonlite)) install.packages("jsonlite")
  library(httr)
  library(jsonlite)
  get_latest_sol <- function(api_key) {
    url <- "https://api.nasa.gov/mars-photos/api/v1/manifests/curiosity"
    response <- GET(url, query = list(api_key = api_key))  # Missing in original code

    if (status_code(response) == 200) {
      data <- content(response, as = "text", encoding = "UTF-8")
      manifest <- fromJSON(data)
      return(manifest$photo_manifest$max_sol)
    } else {
      print("Error fetching latest sol from NASA API")
      return(NULL)
    }
  }
  sol_validation_check <- function(sol, latest_sol) {
    if (is.null(latest_sol)) return(NULL)
    if (sol > latest_sol) {
      print(paste("Requested sol", sol, "is greater than the latest sol available:", latest_sol))
      return(NULL)
    }
    return(sol)
  }
  convert_earth_date_to_sol <- function(earth_date) {
    if (!inherits(earth_date, "Date")) {
      print("Invalid earth_date format. Please provide a valid Date object or YYYY-MM-DD string")
      return(NULL)
    }
    landing_date <- as.Date("2012-08-06")  # Curiosity landing date
    days_since_landing <- as.numeric(earth_date - landing_date)
    sol <- round(days_since_landing / 1.027491)
    return(sol)
  }


  if (is.null(sol) && is.null(earth_date)) {
    sol <- get_latest_sol(api_key)  # Get latest sol if nothing provided
  } else if (!is.null(earth_date)) {
    earth_date <- as.Date(earth_date)  # Ensure correct format
    sol <- convert_earth_date_to_sol(earth_date)
  }


  latest_sol <- get_latest_sol(api_key)
  sol <- sol_validation_check(sol, latest_sol)

  if (is.null(sol)) return(NULL)

  url <- "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
  params <- list(sol = sol, api_key = api_key)

  response <- GET(url, query = params)

  if (status_code(response) == 200) {
    data <- content(response, as = "text", encoding = "UTF-8")
    photos <- fromJSON(data)
    return(photos$photos$img_src)
  } else {
    print("Error fetching Mars photos from NASA API")
    return(NULL)
  }
}

api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

# Example Calls
photos_sol <- get_mars_rover_photos(api_key, sol = 1000)  # Fetch photos by sol
print(photos_sol)
