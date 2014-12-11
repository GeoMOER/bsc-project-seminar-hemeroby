pts2raster <- function(x, y, fill.holes = TRUE, fun = mean, clmn = "Z") {
  library(raster)
  library(rgdal)

  ext <- extent(bbox(x))
  ext@xmin <- ext@xmin + 25
  ext@xmax <- ext@xmax - 25
  ext@ymin <- ext@ymin + 25
  ext@ymax <- ext@ymax - 25
  tmplt <- crop(y, ext, snap = "in")

  if (!identical(projection(x), projection(y))) {
    warning(paste("\n", "projection of points and raster doesn't match!",
                  "\n", "reprojecting raster", "\n",
                  "this may take some time", "\n"))
    tmplt <- projectRaster(tmplt, crs = proj4string(x))
  }

  rst <- rasterize(x, tmplt, field = clmn, fun = mean)
  wndw <- matrix(rep(1, 9), 3, 3)

  #rst_foc <- focal(rst, wndw, fun = mean, NAonly = TRUE)
  if (fill.holes) {
    repeat {
      na_before <- summary(rst)[6]
      rst <- focal(rst, wndw, fun = mean, NAonly = TRUE)
      na_after <- summary(rst)[6]
      if(na_after == na_before) break
    }
  }

  return(rst)
}
