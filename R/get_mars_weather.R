#' Get Mars Weather Data
#' Fetches weather data from NASA’s InSight mission for recent Martian sols.
#'
#' @param api_key NASA API key, defaults to "DEMO_KEY".
#' @param version API version number, defaults to 1.0.
#' @return Data frame with weather details (temperature, pressure, wind) per sol.
#' @export
get_mars_weather <- function(
    api_key = "DEMO_KEY",
    version = 1.0
) {
  if (!require(httr)) install.packages("httr")
  if (!require(jsonlite)) install.packages("jsonlite")
  if (!require(tidyr)) install.packages("tidyr")
  if (!require(dplyr)) install.packages("dplyr")
  library(httr)
  library(jsonlite)
  library(tidyr)
  library(dplyr)

  feedtype = "json"
  base_url <- "https://api.nasa.gov/insight_weather/"

  if (tolower(feedtype) != "json") {
    warning("The API only supports 'json' as the feedtype. Setting feedtype to 'json'.")
    feedtype <- "json"
  }
  query_params <- list(
    ver = version,
    feedtype = feedtype,
    api_key = api_key
  )
  response <- GET(
    url = base_url,
    query = query_params
  )
  if (status_code(response) != 200) {
    stop("Error: Failed to retrieve data. HTTP Status Code: ", status_code(response), "\n",
         content(response, "text"))
  }
  weather_data <- fromJSON(content(response, "text", encoding = "UTF-8"))
  sol_keys <- names(weather_data)[!names(weather_data) %in% c("sol_hours_with_data", "validity_checks")]

  if (length(sol_keys) == 0) {
    stop("No sol data available in the response.")
  }

  sol_list <- list()
  for (sol in sol_keys) {
    sol_num <- as.numeric(sol)
    if (is.na(sol_num)) next
    sol_data <- as.list(weather_data[[sol]])
    sol_row <- list(sol = as.numeric(sol))

    if ("AT" %in% names(sol_data)) {
      sol_row$AT_avg <- sol_data$AT$av
      sol_row$AT_min <- sol_data$AT$mn
      sol_row$AT_max <- sol_data$AT$mx
      sol_row$AT_ct <- sol_data$AT$ct
    } else {
      sol_row$AT_avg <- NA
      sol_row$AT_min <- NA
      sol_row$AT_max <- NA
      sol_row$AT_ct <- NA
    }
    if ("PRE" %in% names(sol_data)) {
      sol_row$PRE_avg <- sol_data$PRE$av
      sol_row$PRE_min <- sol_data$PRE$mn
      sol_row$PRE_max <- sol_data$PRE$mx
      sol_row$PRE_ct <- sol_data$PRE$ct
    } else {
      sol_row$PRE_avg <- NA
      sol_row$PRE_min <- NA
      sol_row$PRE_max <- NA
      sol_row$PRE_ct <- NA
    }
    if ("HWS" %in% names(sol_data)) {
      sol_row$HWS_avg <- sol_data$HWS$av
      sol_row$HWS_min <- sol_data$HWS$mn
      sol_row$HWS_max <- sol_data$HWS$mx
      sol_row$HWS_ct <- sol_data$HWS$ct
    } else {
      sol_row$HWS_avg <- NA
      sol_row$HWS_min <- NA
      sol_row$HWS_max <- NA
      sol_row$HWS_ct <- NA
    }

    if ("WD" %in% names(sol_data) && "most_common" %in% names(sol_data$WD)) {
      wd_most_common <- sol_data$WD$most_common
      sol_row$WD_most_common_compass_degrees <- wd_most_common$compass_degrees
      sol_row$WD_most_common_compass_point <- wd_most_common$compass_point
      sol_row$WD_most_common_ct <- wd_most_common$ct
    } else {
      sol_row$WD_most_common_compass_degrees <- NA
      sol_row$WD_most_common_compass_point <- NA
      sol_row$WD_most_common_ct <- NA
    }

    sol_row$First_UTC <- if ("First_UTC" %in% names(sol_data)) sol_data$First_UTC else NA
    sol_row$Last_UTC <- if ("Last_UTC" %in% names(sol_data)) sol_data$Last_UTC else NA
    sol_row$Season <- if ("Season" %in% names(sol_data)) sol_data$Season else NA
    sol_list[[sol]] <- sol_row
  }

  if (!is.null(sol_data$AT)) {
    sol_row$AT_avg <- as.numeric(sol_data$AT$av) %||% NA
    sol_row$AT_min <- as.numeric(sol_data$AT$mn) %||% NA
    sol_row$AT_max <- as.numeric(sol_data$AT$mx) %||% NA
  } else {
    sol_row$AT_avg <- NA
    sol_row$AT_min <- NA
    sol_row$AT_max <- NA
  }

  weather_df <- bind_rows(sol_list)
  return(weather_df)
}

api_key <- "XFsDPHBjdABhXfquwqnJSfhwEY4rCZI2ev2NDU0K"

weather_df <- get_mars_weather(
  api_key = api_key,
  version = 1.0
)

print("Weather data as a data frame:")
print(head(weather_df))
