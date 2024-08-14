#Groundhog package
if (!requireNamespace("groundhog", quietly = TRUE)) {
  install.packages("groundhog")
}
library(groundhog)

#Lock package versions
version_date <- "2023-06-01"


# Install Packages
install.packages(c("terra", "sf", "clhs", "ggplot2"))

# Load Libraries
library(terra)        # For handling raster data
library(sf)           # For handling spatial vector data
library(clhs)         # For conditioned Latin Hypercube Sampling
library(ggplot2)      # For plotting

# Define the file paths 
raster1_path <- "path/to/DEM.tif"
raster2_path <- "path/to/NDVI.tif"
raster3_path <- "path/to/Slope.tif"

# Load rasters
raster1 <- rast(raster1_path)
raster2 <- rast(raster2_path)
raster3 <- rast(raster3_path)

# Ensure all rasters have the same CRS (Coordinate Reference System)
crs(raster2) <- crs(raster1)
crs(raster3) <- crs(raster1)

# Align the extents of all rasters to match the first raster
# Resample raster2 and raster3 to have the same extent and resolution as raster1
raster2 <- resample(raster2, raster1, method = "bilinear")
raster3 <- resample(raster3, raster1, method = "bilinear")

# Stack the rasters into a single multi-layer raster object
raster_stack <- c(raster1, raster2, raster3)

# Transform the stacked rasters to a geographic CRS (WGS84)
raster_stack_geo <- project(raster_stack, "EPSG:4326")

# Convert the raster stack to a data frame suitable for cLHS
# The data frame includes the x and y coordinates and the values of each raster layer
raster_df <- as.data.frame(raster_stack_geo, xy = TRUE, na.rm = TRUE)

# Set seed for reproducibility
set.seed(121)

# Perform conditioned Latin Hypercube Sampling (cLHS)
# num_samples specifies the number of samples to generate
num_samples <- 15
clhs_result <- clhs(raster_df, size = num_samples, iter = 1000, progress = TRUE, simple = FALSE)

# Extract the sampled points from the cLHS result
sampled_points <- clhs_result$sampled_data

# Convert the sampled points to an sf object for compatibility with ggplot2
sampled_points_sf <- st_as_sf(sampled_points, coords = c("x", "y"), crs = 4326)

# Convert the first layer of the raster stack (e.g., DEM) to a data frame for plotting
dem_df <- as.data.frame(raster_stack_geo[[1]], xy = TRUE)
colnames(dem_df) <- c("x", "y", "value")

# Plot the sampled points
ggplot() +
  geom_tile(data = dem_df, aes(x = x, y = y, fill = value)) + 
  scale_fill_viridis_c() +
  geom_sf(data = sampled_points_sf, color = "red", size = 2) +
  coord_sf() +
  theme_minimal()

# Save the sampled points as a shapefile
shapefile_path <- "path/to/sampled_points.shp"
st_write(sampled_points_sf, shapefile_path)

# Extract the coordinates of the sampled points and save as a CSV file
coords_csv_path <- "path/to/sampled_coords.csv"
write.csv(st_coordinates(sampled_points_sf), coords_csv_path, row.names = FALSE)



