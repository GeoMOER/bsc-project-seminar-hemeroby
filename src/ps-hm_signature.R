library(raster)
library(sp)
library(rgdal)
library(corrplot)
library(RColorBrewer)


working_directory <- "D:/active/moc/ps-hemeroby/examples/"
in_path <- paste0(working_directory,"data/procd/")
out_path <- paste0(working_directory,"data/procd/")
raster_path <- paste0(working_directory, "data/procd/raster/")
idrisi_path <- paste0(working_directory, "idrisi/")
setwd(working_directory)


# layer <- ogrListLayers(paste0(in_path, "ps-hm-ws_all_polygons_epsg25832.shp"))
# trn <- readOGR(paste0(in_path, "ps-hm-ws_all_polygons_epsg25832.shp"), layer)
# 
# raster_files <- 
#   list.files(raster_path, pattern = glob2rx("*.tif"), full.names = TRUE)
# bands <- stack(raster_files)
# 
# signatures <- extract(bands, trn)
# 
# sig_df <- do.call("rbind", signatures)
# sig_df_cov <- cov(sig_df)
# sig_df_cor <- cor(sig_df)
# 
# length(sig_df_cov[sig_df_cov <= 0.00001 & sig_df_cov >= 0.00001])
# 
# length(sig_df_cor[sig_df_cor <= 0.00001 & sig_df_cor >= -0.00001])
# length(sig_df_cor[sig_df_cor >= 0.99999])
# length(sig_df_cor[sig_df_cor <= -0.99999])
# 
# sig_df_cor_df <- data.frame(sig_df_cor)
# sig_df_cor_df[sig_df_cor_df == 1, ]

raster_files <- 
  list.files(idrisi_path, pattern = glob2rx("cbase_01_sig_*.rst"), 
             full.names = TRUE)
raster_files <- raster_files[1:4]
lcc <- stack(raster_files)

for(i in seq(4)){
  plt <- spplot(lcc[[i]], zcol = "Class_name", 
                main = strsplit(basename(lcc[[i]]@file@name), "\\.")[[1]][1],
                col.regions = colorRampPalette(brewer.pal(9,"Set1"))(19))
  print(plt)
}

