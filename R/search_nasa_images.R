#' Search NASA Images
#' Searches NASA’s image database for a given query.
#'
#' @param query Character string to search for.
#' @return List with image metadata (e.g., href, description), or error if failed.
#' @export
search_nasa_images <- function(query) {
  if (!require(httr)) {
    install.packages("httr")
  }
  library(httr)

  url <- "https://images-api.nasa.gov/search"
  query_params <- list(q = query)
  response <- GET(url, query = query_params)
  result <- list()

  if (status_code(response) == 200) {
    content <- content(response, as = "parsed", type = "application/json")
    if (length(content$collection$items) > 0) {
      first_item <- content$collection$items[[1]]
      result$href <- first_item$href

      # Process data if available
      if (length(first_item$data) > 0) {
        data <- first_item$data[[1]]
        result$center <- data$center
        result$date_created <- data$date_created
        result$description <- data$description

        if (!is.null(data$keywords)) {
          result$keywords <- data$keywords
        }
      } else {
        result$data_available <- FALSE
      }
    } else {
      result$items_available <- FALSE
    }
  } else {
    result$error <- paste("Failed to retrieve data. Status code:", status_code(response))
  }
  return(result)
}

result <- search_nasa_images("mars")
result
