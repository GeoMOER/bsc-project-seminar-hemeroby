library(raster)

path <- "/media/ede/tims_ex/marburg_las"
setwd(path)


### RapidEye
stck_re_orig <- stack("rapideye/2010-10-11T112917_RE2_3A-NAC_4499606_94930/2010-10-11T112917_RE2_3A-NAC_4499606_94930.tif")
fls_re <- list.files("MR_landcover_data_collection",
                     pattern = glob2rx("rapid*.tif"),
                     full.names = TRUE)

rsts_re <- lapply(1:length(fls_re), function(i) {
  tmp <- raster(fls_re[i])
  mstr <- raster(fls_re[1])
  if (projection(tmp) != projection(mstr)) {
    tmp <- projectRaster(tmp, mstr)
  } else {
    tmp <- tmp
  }
  return(tmp)
})

stck_re <- stack(rsts_re)
stck_re_all <- stack(stck_re, stck_re_orig)


### LiDAR
stck_li_orig <- stack("MR_DEM_GRS80_all.tif", "MR_DSM_GRS80_all.tif")

fls_li <- list.files("MR_landcover_data_collection",
                     pattern = glob2rx("lidar*.tif"),
                     full.names = TRUE)

rsts_li <- lapply(1:length(fls_li), function(i) {
  tmp <- raster(fls_li[i])
  mstr <- raster(fls_li[1])
  if (projection(tmp) != projection(mstr)) {
    tmp <- projectRaster(tmp, mstr)
  } else {
    tmp <- tmp
  }
  return(tmp)
})

stck_li <- stack(rsts_li)

stck_li_all <- stack(stck_li, stck_li_orig)

### reproject RapidEye to LiDAR
stck_re_all_grs <- projectRaster(stck_re_all, stck_li_all)

stck_all_grs <- stack(stck_li_all, stck_re_all_grs)
names(stck_all_grs)[15] <- "lidar_dsm"
names(stck_all_grs)[14] <- "lidar_dem"
names(stck_all_grs)[41:45] <- paste("rapid_eye_b", 1:5, sep = "")

writeRaster(stck_all_grs, file = "mr.tif", suffix = "names", bylayer = TRUE)
