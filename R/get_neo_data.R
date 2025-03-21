#' Get Near-Earth Object Data
#' Fetches NEO details from NASA’s API for a date range.
#'
#' @param start_date Start date (YYYY-MM-DD).
#' @param end_date End date (YYYY-MM-DD), max 7 days from start.
#' @param api_key NASA API key, defaults to a demo key.
#' @return Data frame with NEO details, or empty if none found.
#' @export
get_neo_data <- function(start_date, end_date, api_key = "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K") {
  library(lubridate)
  library(httr)
  library(purrr)
  # Validate input dates
  start <- ymd(start_date)
  end <- ymd(end_date)

  # Check if dates are in valid YYYY-MM-DD format
  if (is.na(start) || is.na(end)) {
    stop("Dates must be in YYYY-MM-DD format")
  }

  # Ensure start_date is not after end_date
  if (start > end) {
    stop("start_date must be before or equal to end_date")
  }

  # Check if date range exceeds 7 days (API limit)
  if (as.numeric(end - start) > 6) {
    stop("Date range cannot exceed 7 days")
  }

  # Ensure dates are within API's valid range (1900-2200)
  if (start < ymd("1900-01-01") || end > ymd("2200-12-31")) {
    stop("Dates must be between 1900-01-01 and 2200-12-31")
  }

  # Construct the API URL
  url <- paste0(
    "https://api.nasa.gov/neo/rest/v1/feed?start_date=", start_date,
    "&end_date=", end_date,
    "&api_key=", api_key
  )

  # Make the GET request to the NASA NEO Feed API
  response <- GET(url)

  # Check if the request was successful (status code 200)
  if (status_code(response) != 200) {
    stop("API request failed with status code ", status_code(response))
  }

  # Parse the JSON response
  data <- content(response, "parsed")

  # Extract the near_earth_objects list from the response
  neo_list <- data$near_earth_objects

  # If no NEOs are returned, return an empty data frame
  if (is.null(neo_list) || length(neo_list) == 0) {
    return(data.frame())
  }

  # Transform the nested JSON into a flat data frame
  neo_df <- map_dfr(names(neo_list), function(date) {
    neos <- neo_list[[date]]
    map_dfr(neos, function(neo) {
      # Extract the first (and typically only) close approach data for this date
      cad <- neo$close_approach_data[[1]]
      data.frame(
        date = date,                                    # Date of close approach
        id = neo$id,                                    # NEO identifier
        name = neo$name,                                # NEO name
        absolute_magnitude_h = neo$absolute_magnitude_h, # Absolute magnitude
        estimated_diameter_min_km = neo$estimated_diameter$kilometers$estimated_diameter_min, # Min diameter (km)
        estimated_diameter_max_km = neo$estimated_diameter$kilometers$estimated_diameter_max, # Max diameter (km)
        is_potentially_hazardous_asteroid = neo$is_potentially_hazardous_asteroid, # Hazard status
        close_approach_date = cad$close_approach_date,  # Close approach date
        relative_velocity_km_per_sec = as.numeric(cad$relative_velocity$kilometers_per_second), # Velocity (km/s)
        miss_distance_km = as.numeric(cad$miss_distance$kilometers), # Miss distance (km)
        orbiting_body = cad$orbiting_body,              # Orbiting body (e.g., Earth)
        stringsAsFactors = FALSE                        # Prevent factor conversion
      )
    })
  })

  # Return the resulting data frame
  return(neo_df)
}

neo_data <- get_neo_data("2023-01-01", "2023-01-02")
print(neo_data)

library(ggplot2)
neo_df <- get_neo_data("2025-03-10", "2025-03-15")
ggplot(neo_df, aes(x = miss_distance_km, y = relative_velocity_km_per_sec)) +
  geom_point() + labs(title = "Asteroid Speed vs. Distance")
