library(rgdal)
library(raster)

path <- "/media/ede/tims_ex/marburg_las"
setwd(path)

# dem_fls <- list.files("dsm", pattern = glob2rx("*.tif"),
#                       full.names = TRUE)
#
# dems_rst <- lapply(seq(dem_fls), function(i) {
#   raster(dem_fls[i])
# })
#
# dem_all_rst <- Reduce(function(x, y) mosaic(x, y, fun = mean),
#                       dems_rst)
#
# writeRaster(dem_all_rst, paste("dsm", "MR_DSM_GRS80.tif", sep = "/"),
#             overwrite = TRUE)

dem <- raster("dem/MR_DEM_GRS80_all.tif")
dsm <- raster("dsm/MR_DSM_GRS80_all.tif")

tst <- dsm - dem
plot(tst)
writeRaster(tst, "mr_rel_heights.tif", overwrite = TRUE)
