# cLHS Code for Sampling Spatial Data

This repository contains the R code used to perform conditioned Latin Hypercube Sampling (cLHS) on raster datasets. The cLHS method is particularly useful for selecting representative samples from spatial data for environmental modeling and other spatial analyses.

## Overview

The script in this repository demonstrates how to:
- Load and process raster data (e.g., DEM, NDVI, Slope).
- Perform conditioned Latin Hypercube Sampling (cLHS) to select sample points.
- Visualize the sampled points on a raster background.
- Save the sampled points as shapefiles and CSV files for further use.

## Dependencies

The script relies on several R packages, and the `groundhog` package is used to lock the package versions to ensure reproducibility.

### Required Packages

- **groundhog**: For managing package versions.
- **terra**: For handling raster data.
- **sf**: For handling spatial vector data.
- **clhs**: For conditioned Latin Hypercube Sampling.
- **ggplot2**: For plotting the results.

### Installing Dependencies

The required packages can be installed using the following code:

```r
if (!requireNamespace("groundhog", quietly = TRUE)) {
  install.packages("groundhog")
}
library(groundhog)

version_date <- "2023-06-01"
groundhog.library("terra", version_date)
groundhog.library("sf", version_date)
groundhog.library("clhs", version_date)
groundhog.library("ggplot2", version_date)
