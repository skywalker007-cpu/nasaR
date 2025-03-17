<div align="center">
<h1
    style="font-size: 32px; font-weight: bold;"
>NASA R Package</h1>
<span
    style="font-size: 14px; font-weight: bold;"
>"This is the R Package about NASA API."</span>
</div>

## Table of Contents

- [Porject Description](#project-description)
- [Project Proposal](#project-proposal)

<a name="project-description"></a>

## Project Description

### nasaR: Access NASA's Space Data in R

nasaR is an R package that provides easy access to NASA’s Open APIs, allowing users to retrieve and visualize space-related data effortlessly. The package includes functions to fetch Astronomy Picture of the Day (APOD), Mars Rover photos, Near-Earth Object (NEO) data, and Earth satellite imagery.

**Key Features:**
- 📷 **get_apod_photo()** – Fetch NASA’s Astronomy Picture of the Day with descriptions.
- 🌍 **get_earth_image()** – Download NASA satellite imagery by geographic coordinates.
- 🛰 **get_earth_landsat_imagery()** – Retrieve Landsat satellite images of Earth.
- 🌎 **get_earth_polychromatic_imaging()** – Access DSCOVR EPIC images of Earth in multiple wavelengths.
- 🚀 **get_mars_rover_photos()** – Retrieve images captured by NASA’s Mars rovers (Curiosity, Perseverance, etc.).
- 🔴 **get_mars_weather()** – Get latest weather reports from NASA’s Mars missions.
- ☄️ **get_neo_data()** – Access Near-Earth Object details and visualize asteroid data.
- 🔍 **search_nasa_images()** – Search for NASA images and videos using keywords.

Built with httr and jsonlite for API requests, ggplot2 for visualizations, and testthat for robust testing, nasaR makes space data exploration simple and engaging for R users of all levels.

<a name="project-proposal"></a>

## Project Proposal

To check the full proposal, click on the link below: [Proposal](./Proposal.md)
