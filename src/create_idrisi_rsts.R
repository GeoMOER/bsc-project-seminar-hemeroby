library(raster)

path <- "/media/ede/tims_ex/marburg_las"
setwd(path)

tifs <- stack(list.files("MR_landcover_data_collection2",
                         full.names = TRUE))

writeRaster(tifs, "rsts/rst", suffix = "names", bylayer = TRUE,
            format = "IDRISI")
