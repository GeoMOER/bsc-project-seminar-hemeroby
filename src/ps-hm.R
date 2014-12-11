library(raster)
library(sp)
library(rgdal)

setwd("C:/Users/tnauss/Desktop/vector")
test <- readOGR("test.shp", "test")

vector <- readOGR("ps-hm-ws_all_polygons_utm_32n.shp", "ps-hm-ws_all_polygons_utm_32n")

vector_neu <- spTransform(vector, CRS("+proj=utm +zone=32 +ellps=GRS80 +units=m +no_defs"))

vector_neu@data$LU_New <- vector_neu@data$LU
sort(unique(vector_neu@data$LU_New))
vector_neu@data$LU_New[vector_neu@data$LU_New == 14] <- 13
vector_neu@data$LU_New[vector_neu@data$LU_New == 15] <- 14
vector_neu@data$LU_New[vector_neu@data$LU_New == 16] <- 15
vector_neu@data$LU_New[vector_neu@data$LU_New == 51] <- 16
vector_neu@data$LU_New[vector_neu@data$LU_New == 52] <- 17
vector_neu@data$LU_New[vector_neu@data$LU_New == 53] <- 18
vector_neu@data$LU_New[vector_neu@data$LU_New == 54] <- 19
vector_neu@data$LU_New[vector_neu@data$LU_New == 400] <- 20
vector_neu@data$LU_New[vector_neu@data$LU_New == 401] <- 21
vector_neu@data$LU_New[vector_neu@data$LU_New == 402] <- 22
vector_neu@data$LU_New[vector_neu@data$LU_New == 403] <- 23
sort(unique(vector_neu@data$LU_New))

vector_neu@data$Classname <- NA
vector_neu@data$Classv <- as.integer(vector_neu@data$LU_New)
vector_neu@data$Classname <- paste0("Class", as.character(vector_neu@data$Classv))
vector_neu@data$RED <- 1
vector_neu@data$GREEN <- 1
vector_neu@data$BLUE <- 1
vector_neu@data$Count <- as.integer(1)
  
# vector_neu@data$Id <- NULL
# vector_neu@data$LU <- NULL
# vector_neu@data$HEM <- NULL
# vector_neu@data$LUn <- NULL
# vector_neu@data$LU_New <- NULL



writeOGR(vector_neu, "ps-hm-ws_all_polygons_utm_32n_etrs89.shp", 
         "ps-hm-ws_all_polygons_utm_32n_etrs89", driver = "ESRI Shapefile")

