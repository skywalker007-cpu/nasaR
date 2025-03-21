% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_earth_polychromatic_imaging.R
\name{get_earth_polychromatic_imaging}
\alias{get_earth_polychromatic_imaging}
\title{Get EPIC Earth Imagery
Fetches EPIC imagery metadata or downloads an image by endpoint and date.}
\usage{
get_earth_polychromatic_imaging(
  api_key = "DEMO_KEY",
  endpoint = "natural",
  date = NULL,
  download_image = FALSE
)
}
\arguments{
\item{api_key}{NASA API key, defaults to "DEMO_KEY".}

\item{endpoint}{EPIC endpoint (e.g., "natural"), defaults to "natural".}

\item{date}{Date (YYYY-MM-DD), optional unless using /date endpoint.}

\item{download_image}{Save image for /date endpoints, defaults to FALSE.}
}
\value{
Data frame with metadata or dates, or NULL if no data.
}
\description{
Get EPIC Earth Imagery
Fetches EPIC imagery metadata or downloads an image by endpoint and date.
}
