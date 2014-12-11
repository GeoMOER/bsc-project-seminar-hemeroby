library(rgdal)
library(raster)
library(maptools)

path <- "/media/ede/tims_ex/marburg_las"
setwd(path)

input.path <- "/media/ede/tims_ex/marburg_las/level_1"
output.path <- "/media/ede/tims_ex/marburg_las/level_2"
src.filepath <- "/home/ede/software/lidar"
liblas.path <- "/usr/bin"

source(paste(src.filepath, "pts2raster.R", sep = "/"))

rst <- raster("/media/ede/tims_ex/marburg_las/rapideye/2010-10-11T112917_RE2_3A-NAC_4499606_94930/2010-10-11T112917_RE2_3A-NAC_4499606_94930.tif")
dem_fls <- list.files(output.path, pattern = glob2rx("*cid02.shp"),
                      recursive = TRUE, full.names = TRUE)

dems <- lapply(seq(dem_fls), function(i) {
  lyr <- ogrListLayers(dem_fls[i])
  dem <- readOGR(dem_fls[i], layer = lyr)
#   tmp <- pts2raster(dem, rst)
  return(dem)
})

dem_all_pts <- Reduce(function(x, y) spRbind(x, y),
                      dems)

tmp <- pts2raster(dem_all_pts, rst)

# nm <- gsub(".shp", ".tif", basename(dem_fls))

writeRaster(tmp, filename = paste("dem", "MR_DEM_GRS80_all.tif", sep = "/"),
            overwrite = TRUE)

# lapply(seq(dems), function(i) {
#   writeRaster(dems[[i]], filename = paste("dsm", nm[[i]], sep = "/"),
#               overwrite = TRUE)
# })
