### load necessary libraries ----------------------------------------------
library(rgdal)
library(maptools)
# -------------------------------------------------------------------------



### specify whether to reproject the data to EPSG 25832 -------------------
reproject <- FALSE
# -------------------------------------------------------------------------




### path where all .zip files are stored ----------------------------------
path <- "/media/windows/tappelhans/uni/marburg/lehre/2014/ws/VPPS/field_work_data"
setwd(path)
# -------------------------------------------------------------------------




### list and unzip all .zip files -----------------------------------------
fls_zip <- list.files("students", recursive = TRUE, full.names = TRUE)

for (i in fls_zip) {
  unzip(i, exdir = "shapes")
}
# -------------------------------------------------------------------------




### list and read extracted files -----------------------------------------
fls <- list.files("shapes", recursive = TRUE, full.names = TRUE,
                  pattern = glob2rx("*.shp"))

dat <- lapply(seq(fls), function(i) {
  lyr <- ogrListLayers(fls[i])
  shp <- readOGR(fls[i], layer = lyr)
  shp@proj4string <- CRS("+init=epsg:3857")
  if(reproject) {
    shp <- spTransform(shp, CRS("+init=epsg:25832"))
  }
  ids <- sapply(slot(shp, "polygons"), function(x) slot(x, "ID"))
  newids <- as.character(as.numeric(ids) + i * 100)
  shp1 <- spChFIDs(shp, newids)
  return(shp1)
})
# -------------------------------------------------------------------------




### clean up one of the shapefiles (column names and column order) --------
dat[[3]]@data <- dat[[3]]@data[, -c(1, 2)]
dat[[3]]@data <- dat[[3]]@data[, c(1, 3, 2)]
names(dat[[3]]@data)[1] <- "Id"
# -------------------------------------------------------------------------


### join all files together into one --------------------------------------
dat_all <- Reduce(function(x, y) spRbind(x, y), dat)
# -------------------------------------------------------------------------




### write final shapefile -------------------------------------------------
if(!reproject) {
writeOGR(dat_all, dsn = "final/ps-hm-ws_all_polygons_epsg3857.shp", 
         layer = "ps-hm-ws_all_polygons_epsg3857", 
         driver = "ESRI Shapefile")
}

if(reproject) {
  writeOGR(dat_all, dsn = "final/ps-hm-ws_all_polygons_epsg25832.shp", 
           layer = "ps-hm-ws_all_polygons_epsg25832", 
           driver = "ESRI Shapefile")
}
# -------------------------------------------------------------------------  
