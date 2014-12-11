library(Rdym)
library(rgdal)

path <- "/media/ede/tims_ex/marburg_las"
setwd(path)

lyr <- ogrListLayers("training/ps-hm-ws_all_polygons_utm_32n_etrs89.shp")
shp <- readOGR("training/ps-hm-ws_all_polygons_utm_32n_etrs89.shp",
               layer = lyr, stringsAsFactors = FALSE)


lut <- read.csv("~/software/lehre/bsc-hemeroby/src/lookup_classes.csv",
                stringsAsFactors = FALSE)

  for(i in 1:nrow(lut)){
  value <- lut[i, 1]
  name <- lut[i, 2]
  shp@data$Classname[shp@data$Classv == value] <- name
}
