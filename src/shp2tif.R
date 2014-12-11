library(raster)
library(rgdal)

lyr <- ogrListLayers("/media/ede/tims_ex/marburg_las/level_2/U4825626_cid13/U4825626_cid13.shp")
tile <- readOGR("/media/ede/tims_ex/marburg_las/level_2/U4825626_cid13/U4825626_cid13.shp",
                layer = lyr)

#tile_dem <- subset(tile, CfN == 2)

ext <- extent(bbox(tile))
tmplt <- raster("/media/ede/tims_ex/marburg_las/rapideye/2010-10-11T112917_RE2_3A-NAC_4499606_94930/2010-10-11T112917_RE2_3A-NAC_4499606_94930.tif")
tmplt <- crop(tmplt, ext)
tmplt_grs <- projectRaster(tmplt, crs = proj4string(tile))

rst <- rasterize(tile, tmplt_grs, "Z", fun = mean)
wndw <- matrix(rep(1, 9), 3, 3)

#rst_foc <- focal(rst, wndw, fun = mean, NAonly = TRUE)

repeat {
  na_before <- summary(rst)[6]
  rst <- focal(rst, wndw, fun = mean, NAonly = TRUE)
  na_after <- summary(rst)[6]
  if(na_after == na_before) break
}

writeRaster(rst - rst_dem, "../test.tif")
