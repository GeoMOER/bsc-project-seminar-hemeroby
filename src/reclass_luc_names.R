library(Rdym)
library(rgdal)

path <- "/media/ede/tims_ex/marburg_las"
path <- "D:/active/moc/ps-hemeroby/examples/"
in_path <- "D:/active/moc/ps-hemeroby/examples/data/procd/"
scr_path <- "D:/active/moc/ps-hemeroby/examples/scripts/bsc-hemeroby/src/"
setwd(path)

lut <- read.csv(paste0(scr_path, "lookup_classes.csv"), 
                stringsAsFactors = FALSE)

lyr <- ogrListLayers(paste0(in_path, "ps-hm-ws_all_polygons_epsg25832.shp"))
shp <- readOGR(paste0(in_path, "ps-hm-ws_all_polygons_epsg25832.shp"),
               layer = lyr, stringsAsFactors = FALSE)

shp@data$LU_ID <- NA
shp@data$LU_NAME <- NA

for(i in 1:nrow(lut)){
  class_id_old <- lut$ID_OLD[i]
  class_id_new <- lut$ID_NEW[i]
  class_name <- lut$CLASS[i]
  shp@data$LU_ID[shp@data$LU == class_id_old] <- class_id_new
  shp@data$LU_NAME[shp@data$LU_ID == class_id_new] <- class_name
}

writeOGR(shp, paste0(in_path, "ps-hm-ws_all_polygons_new_epsg25832.shp"),
         "ps-hm-ws_all_polygons_new_epsg25832", driver = "ESRI Shapefile")