#######################################################
# Download and display the Area of water and look at them.
# Created just for teaching purpose - not for scientific analysis! 100% accuracy not ensured
# Learning goal: download data, convert them, analyse spatio-temporal data and display them in differents forms.
#######################################################

# Originally written by Diego Alonso Alarcon Diaz in January 2020, latest Version: March 2020
# Code is good to go!

# To keep the created code in order, it is suggested to use the following package:
# https://cran.r-project.org/web/packages/styler/styler.pdf
#if(!require(styler)){
#  install.packages("styler")
#  library(styler)
#}

# It is necessary to check if the packages are install in  RStudio

if(!require(gganimate)){
  install.packages("gganimate")
  library(gganimate)
}
if(!require(rasterVis)){
  install.packages("rasterVis")
  library(rasterVis)
}
if(!require(animation)){
  install.packages("animation")
  library(animation)
}
if(!require(RStoolbox)){
  install.packages("RStoolbox")
  library(RStoolbox)
}
if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}
if(!require(magrittr)){
  install.packages("magrittr")
  library(magrittr)
}
if(!require(magick)){
  install.packages("magick")
  library(magick)
}
if(!require(rgdal)){
  install.packages("rgdal")
  library(rgdal)
}
if(!require(rgeos)){
  install.packages("rgeos")
  library(rgeos)
}
if(!require(devtools)){
  install.packages("devtools", dependencies = TRUE)
  library(devtools)
}
#######################################################
# Activation of the cores in the device and focus these in the following process
beginCluster()

#####################################################
# Define the only data you need to change

Shape_file <- shapefile('C:/Users/JELG02/OneDrive/Uni-Wue/1er_Semestre/MB2_Introduction_to_Programming_and_Geostatistics/Final_Project/Study_Area.shp')

shape_path <- "C:/Users/JELG02/OneDrive/Uni-Wue/1er_Semestre/MB2_Introduction_to_Programming_and_Geostatistics/Final_Project/Study_Area.shp"

# This is the name for the Lagoon for the study
Lagoon <- "Aculeo_Lagoon"

Lagoon1 <- "Aculeo Lagoon"

hard_drive <- "B:/"

####################################################

#It is necessary to set and create the folders before
#hand to storage the data
setwd(hard_drive)#Setting path
dir.create(paste0("Data/",Lagoon))#Create folder

setwd(paste0(hard_drive,"Data/"))
dir.create("Data_Frame")
dir.create(paste0("Data_Frame/",Lagoon))

setwd(paste0(hard_drive,"Data/",Lagoon))#Setting path
dir.create("Permanent_Water")#Create folder
dir.create("Seasonal_Water")#Create folder
dir.create("Total_Water")#Create folder
dir.create("Zona_Study")#Create folder
dir.create("Data_Bruto")#Create folder
dir.create("Crop_data")# Create folder
dir.create("Mask_data")# Create folder
dir.create("Mosaic")# Create folder


#######################################################

tempdl <- paste0(hard_drive,"Data/Chile_all.zip")
setwd(paste0(hard_drive,"Data/",Lagoon,"/Data_Bruto/"))


# The data necessary for this project will be automatically download
# It is also possible just changing the /Chile_all.zip to another country download the data
fileURL <- "https://storage.googleapis.com/global-surface-water-stats/zips/Chile_all.zip"


# Here is necessary to check if the data was downloaded and then unzip the content
if (!file.exists(tempdl)) {
  download.file(fileURL ,tempdl, mode="wb")
  unzip(tempdl,exdir = ".",overwrite = TRUE)
} else {
  unzip(tempdl,exdir = ".",overwrite = TRUE)
}

#######################################################

#Identify the folders
fromFolder <- paste0(hard_drive,"Data/",Lagoon,"/Data_Bruto/")
toFolder <- paste0(hard_drive,"Data/",Lagoon,"/Zona_Study/")

#######################################################

# Change path to folder containing rasters
rasdir <- paste0(hard_drive,"Data/",Lagoon,"/Data_Bruto/")

# List all GeoTIFF files in folder, change extension in pattern if different format
fllst <- list.files(path=rasdir, pattern=c("^Chile_classes_(.*).tif$"), full.names=T)

# New vector for storing file names of intersecting rasters
newlst <- c()

# Loop through files
for (fl in fllst){
  r <- raster(fl)
  # Transform shapefile to match crs of raster
  Shape_file <- spTransform(Shape_file, crs(r))
  # Check if raster intersects shapefile
  # Suppress warnings from function is optional
  if (suppressWarnings(!(is.null(intersect(Shape_file, extent(r))))))
  {
    # If raster intersects, add file name to vector
    newlst <- c(newlst, fl)
  }
}

# Copy the files to the toFolder
file.copy(file.path(newlst), toFolder, overwrite=TRUE)

#Create the path where are all the *.tiff images we will use.
IMAGE_path <- paste0(hard_drive,"Data/",Lagoon,"/Zona_Study/")

#Load all the images in one list.
all_IMAGE <- list.files(IMAGE_path,
                        full.names = TRUE,
                        pattern = ".tif$")

#Create a List of Raster Files
aculeo_names <- list()

#For-loop to create a Raster Files with all the *.tiff images
for (i in 1:length(all_IMAGE)){
  aculeo_names[[i]] <- raster(all_IMAGE[i])
}

my_years <- vector(mode="character")

for (i in 1:length(aculeo_names)) {
  my_years[[i]] <- substr(names(aculeo_names[[i]]), start=15, stop=18)
}

###############################################################
# Calling Gdal by R to create a mosaic into a .vrt, Clipped with a Shapefile and transform to a Geotiff compress = LZW
# It is necessary to check the QGIS folder on the computer this code will run

rasdir <- paste0(hard_drive,"Data/",Lagoon,"/Zona_Study/")

if(!require(sf)){
  install.packages("sf")
  library(sf)
}

for (i in 1:length(my_years)) {
  output <- paste0(hard_drive,"Data/",Lagoon,"/Mosaic/Chile_classes_",my_years[[i]],".vrt")
  input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_", my_years[[i]],"(.*).tif$"), full.names=T)
  system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
          args = paste('gdalbuildvrt', output, input1[i]))
}

for (i in 1:length(my_years)) {
  output2 <- paste0(hard_drive,"Data/",Lagoon,"/Crop_data/Chile_classes_",my_years[[i]],".vrt")
  input2 <- paste0(hard_drive,"Data/",Lagoon,"/Mosaic/Chile_classes_",my_years[[i]],".vrt")
  system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
          args = paste('gdalwarp -cutline',shape_path,
                       '-crop_to_cutline',input2 ,output2))
}

for (i in 1:length(my_years)) {
  output4 <- paste0(hard_drive,"Data/",Lagoon,"/Mask_data/Chile_classes_",my_years[[i]],".tif")
  input4 <- paste0(hard_drive,"Data/",Lagoon,"/Crop_data/Chile_classes_",my_years[[i]],".vrt")
  system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
          args = paste('gdal_translate -a_srs EPSG:4326 -ot Byte -of VRT -co COMPRESS=LZW -co PREDICTOR=2 -co TILED=YES ', input4, output4))
}
#########################################################

# Create the path where are all the *.tiff images we will use.
Water_IMAGE_path <- paste0(hard_drive,"Data/",Lagoon,"/Mask_data/")

# Load all the images in one list.
Water_all_IMAGE <- list.files(Water_IMAGE_path,
                              full.names = TRUE,
                              pattern = ".tif$")

# Create a List of Raster Files
Water <- list()

# For-loop to create a Raster Files with all the *.tiff images
for (i in 1:length(Water_all_IMAGE)){
  Water[[i]] <- raster(Water_all_IMAGE[i])
}

#Create the vector with the name file
names_file <- vector(mode="character")

#For-loop to obtain the name file for all the raster in one vector file
#which will be used when the rasters file will be saved
for (i in 1:length(Water)){
  names_file[[i]] <- names(Water[[i]])
}

# For-loop to create a brick of differents types of water
for (i in 1:length(Water)){
  
  # Create a List of differents types of water
  t_Seasonal <- list()
  t_Permanent <- list()
  t_water <- list()
  
  # https://www.sdg661.app/data-products/data-downloads
  # Classifications 2000-2018. One file per year. This Yearly Seasonality Classification
  # collection contains annula seasonality maps. Each file has one band with 3 possible values:
  # Values  Description data
  # 1  Not water (i.e. Land)
  # 2  Seasonal water
  # 3  Permanent water
  
  # The raster files will be classified according to what is indicated on the website
  t_Seasonal <- reclassify(Water[[i]], c(0, 1, NA, 1, 2, 1, 2, 3, NA))
  
  # Setting path for Seasonal Water
  setwd(paste0(hard_drive,"Data/",Lagoon,"/Seasonal_Water/"))
  
  # Extract Country
  Country <- substr(names(Water[[i]]), start=1, stop=5)
  
  # Extract year of the data
  yr <- substr(names(Water[[i]]), start=15, stop=18)
  
  # Save the Raster with a specific name
  s_list <- writeRaster(t_Seasonal, filename=paste0("Seasonal_Water_for_",Lagoon,"_",yr), format='GTiff', overwrite=T)
  
  # Remove lists
  rm(t_Seasonal)
  
  # The raster files will be classified according to what is indicated on the website
  t_Permanent <- reclassify(Water[[i]], c(0, 2, NA, 2, 3, 1))
  
  # Setting path for Permanent Water
  setwd(paste0(hard_drive,"Data/",Lagoon,"/Permanent_Water"))
  
  # Save the Raster with a specific name
  s_list <- writeRaster(t_Permanent, filename=paste0("Permanent_Water_for_",Lagoon,"_",yr), format='GTiff', overwrite=T)
  
  # Remove lists
  rm(t_Permanent)
  
  # The raster files will be classified according to what is indicated on the website
  t_water <- reclassify(Water[[i]], c(0, 1, NA, 1, 3, 1))
  
  # Setting path for Total Water (Permanent + Seasonal)
  setwd(paste0(hard_drive,"Data/",Lagoon,"/Total_Water"))
  
  # Save the Raster with a specific name
  s_list <- writeRaster(t_water, filename=paste0("Total_Water_for_",Lagoon,"_",yr), format='GTiff', overwrite=T)
  
  # Remove lists
  rm(t_water)
  
}
####################################
# Erase the Temporal file

erase_path <- list.files("C:/Users/JELG02/AppData/Local/Temp/", pattern=c("^R(.*)"), full.names=T)
unlink(erase_path, recursive = T)

#######################################################
# Calling Gdal by R to create a mosaic, Clipped with a Shape
# It is necessary to set the direction of QGis and it version

for (i in 1:length(my_years)) {
  
  output5 <- paste0(hard_drive,"Data/Data_Frame/",Lagoon,"/Seasonal_Water_for_",Lagoon,"_",my_years[[i]],".gpkg")
  input5 <- paste0(hard_drive,"Data/",Lagoon,"/Seasonal_Water/Seasonal_Water_for_",Lagoon,"_",my_years[[i]],".tif")
  
  system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
          args = paste('gdal_translate -a_srs EPSG:4326 -ot UInt16 -of GPKG ', input5, output5))
  
}
for (i in 1:length(my_years)) {
  
  output6 <- paste0(hard_drive,"Data/Data_Frame/",Lagoon,"/Permanent_Water_for_",Lagoon,"_",my_years[[i]],".gpkg")
  input6 <- paste0(hard_drive,"Data/",Lagoon,"/Permanent_Water/Permanent_Water_for_",Lagoon,"_",my_years[[i]],".tif")
  
  system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
          args = paste('gdal_translate -a_srs EPSG:4326 -ot UInt16 -of GPKG ', input6, output6))
}

for (i in 1:length(my_years)) {
  
  output7 <- paste0(hard_drive,"Data/Data_Frame/",Lagoon,"/Total_Water_for_",Lagoon,"_",my_years[[i]],".gpkg")
  input7 <- paste0(hard_drive,"Data/",Lagoon,"/Total_Water/Total_Water_for_",Lagoon,"_",my_years[[i]],".tif")
  
  system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
          args = paste('gdal_translate -a_srs EPSG:4326 -ot UInt16 -of GPKG ', input7, output7))
}

#################################333

# Create a List for a temporal Stack
tmp_Stack1 <- list()

# Create the path where Seasonal *.tiff images we will use.
IMAGE_path2 <- paste0(hard_drive,"Data/",Lagoon,"/Seasonal_Water/")

# Load all the images in one list.
all_IMAGE2 <- list.files(IMAGE_path2,
                         full.names = TRUE,
                         pattern = ".tif$")
# Temporal Stack for all the Seasonal *.tiff images
tmp_Stack1 <- stack(all_IMAGE2)


# Create a List for a second temporal Stack
tmp_Stack2 <- list()

# Create the path where Permanent *.tiff images we will use.
IMAGE_path3 <- paste0(hard_drive,"Data/",Lagoon,"/Permanent_Water/")

# Load all the images in one list.
all_IMAGE3 <- list.files(IMAGE_path3,
                         full.names = TRUE,
                         pattern = ".tif$")
# Second Temporal Stack for all the Seasonal *.tiff images
tmp_Stack2 <- stack(all_IMAGE3)


# Create a List for a third temporal Stack
tmp_Stack3 <- list()

# Load all the images in one list.
IMAGE_path4 <- paste0(hard_drive,"Data/",Lagoon,"/Total_Water/")
# Load all the images in one list.
all_IMAGE4 <- list.files(IMAGE_path4,
                         full.names = TRUE,
                         pattern = ".tif$")
# Third Temporal Stack for all the Seasonal *.tiff images
tmp_Stack3 <- stack(all_IMAGE4)

#######################################################

# Define dataframe and fill it with the Year, Type and Area
# for the difference types of water

# Subtract the characters from the names vector and add them to the dataframe
my_years <- vector(mode="character")

for (i in 1:length(aculeo_names)) {
  my_years[[i]] <- substr(names(aculeo_names[[i]]), start=15, stop=18)
}

# Create a matrix with the data "Seasonal" prior to the creation of the dataframe
my_mat <- matrix(data = "Seasonal", nrow = length(my_years), ncol = 3)

# Create a vector with the years
my_mat[,1] <- my_years

# Create the data frame with the data for "Seasonal"
my_df <- data.frame(my_mat,stringsAsFactors=FALSE)

# Create a matrix with the data "Permanent" prior to the creation of the dataframe
my_mat1 <- matrix(data = "Permanent", nrow = length(my_years), ncol = 3)

# Create a vector with the years
my_mat1[,1] <- my_years

# Create the data frame with the data for "Permanent"
my_df1 <- data.frame(my_mat1,stringsAsFactors=FALSE)

# Create a matrix with the data "Total" prior to the creation of the dataframe
my_mat2 <- matrix(data = "Total", nrow = length(my_years), ncol = 3)

# Create a vector with the years
my_mat2[,1] <- my_years

# Create the data frame with the data for "Total"
my_df2 <- data.frame(my_mat2,stringsAsFactors=FALSE)

# Name the headers of the created dataframes
names(my_df) <- c("Year", "Type", "Area")
names(my_df1) <- c("Year", "Type", "Area")
names(my_df2) <- c("Year", "Type", "Area")

# For-loop calculating mean of each raster and save it in a dataframe
for (i in 1:length(my_years)){
  
  # Extracting the quantity of pixel with the value 1 and sum them
  area_Seasonal <- cellStats(tmp_Stack1[[i]], 'sum',na.rm=TRUE)
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project)
  # and divided into 1e-6 to obtain the square Kilometers, which are an
  # easier measure to read in dimension.
  my_df[i,3] <- as.numeric((area_Seasonal*9)/10000)
  
  # Extracting the quantity of pixel with the value 1 and sum them
  area_Permanent <- cellStats(tmp_Stack2[[i]], 'sum',na.rm=TRUE)
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project)
  # and divided into 1e-6 to obtain the square Kilometers, which are an
  # easier measure to read in dimension.
  my_df1[i,3] <- as.numeric((area_Permanent*9)/10000)
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project)
  # and divided into 1e-6 to obtain the square Kilometers, which are an
  # easier measure to read in dimension.
  area_total <- as.numeric(((area_Seasonal+area_Permanent)*9)/10000)
  
  # Sum of the values obtained for both Seasonal and Permanent area
  my_df2[i,3] <- area_total
  
  # Clean the values for the loop
  rm(area_Seasonal,area_Permanent,area_total,i)
}

tempdir()
dir.create(tempdir())

setwd(paste0(hard_drive,"Data/Data_Frame/",Lagoon))
# SAving the data as Data Frame
write.csv(my_df, file= paste0(Lagoon,"_Seasonal",".csv"), row.names = F)
write.csv(my_df1, file= paste0(Lagoon,"_Permanent",".csv"), row.names = F)
write.csv(my_df2, file= paste0(Lagoon,"_Total",".csv"), row.names = F)

rm(my_df, my_df1, my_df2)

sea <- " Seasonal"
perm <- " Permanent"
tot <- " Total"

# Reading the data saved the data as Data Frame
my_df = read.csv(paste0(Lagoon,"_Seasonal",".csv"), header=TRUE, sep=",")
my_df1 = read.csv(paste0(Lagoon,"_Permanent",".csv"), header=TRUE)
my_df2 = read.csv(paste0(Lagoon,"_Total",".csv"), header=TRUE)


my_df3 <- rbind.data.frame(my_df,my_df1,my_df2)

for (i in 1:nrow(my_df3)){
  my_df3[i, 3] <- (round(as.numeric(my_df3[i, 3]), digits = 2))
}

all_tg <- " all "

#######################################################

# It is necessary to check if the packages are install in  RStudio
if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}
if(!require(mgcv)){
  install.packages("mgcv")
  library(mgcv)
}
if(!require(ggpmisc)){
  install.packages("ggpmisc")
  library(ggpmisc)
}
if(!require(glue)){
  install.packages("glue")
  library(glue)
}

# Plotting the Seasonal Water
my.formula <- y ~ x + I(x^2)
p <- ggplot(my_df, aes(x=Year, y=as.numeric(Area), group = Type)) +
  geom_line(aes(colour = Type), size = .5) +
  geom_point(aes(colour = Type), size = 2) +
  stat_smooth(method = "lm", formula = my.formula, size = .5) +
  scale_x_continuous(breaks=seq(2000, 2018, 1)) +
  geom_vline(xintercept=2010, linetype="dashed", color = "red") +
  stat_poly_eq(formula = my.formula,
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
               label.x = "left", label.y = "top",
               parse = TRUE) +
  labs(title = paste0("TimeSeries of ",sea," Water Body in ",Lagoon1,", Chile"),
       caption = "Source: EC JRC/Google") +
  xlab("Year") + ylab("Area"~Km^2) +
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=5, angle=45),
        axis.text.y = element_text(face="bold", color="#993333",
                                   size=7, angle=0))
# Saving the plot
ggsave(paste("TimeSeries of",Lagoon1,sea," Chile",".png"), plot = p, width = 20, height = 10, units = "cm")



# Plotting the Permanent Water
my.formula <- y ~ x + I(x^2)
k <- ggplot(my_df1, aes(x=Year, y=as.numeric(Area), group = Type)) +
  geom_line(aes(colour = Type), size = .5) +
  geom_point(aes(colour = Type), size = 2) +
  stat_smooth(method = "lm", formula = my.formula, size = .5) +
  scale_x_continuous(breaks=seq(2000, 2018, 1)) +
  geom_vline(xintercept=2010, linetype="dashed", color = "red") +
  stat_poly_eq(formula = my.formula,
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
               label.x = "left", label.y = "bottom",
               parse = TRUE) +
  labs(title = paste0("TimeSeries of ",perm," Water Body in ",Lagoon1,", Chile"),
       caption = "Source: EC JRC/Google") +
  xlab("Year") + ylab("Area"~Km^2) +
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=5, angle=45),
        axis.text.y = element_text(face="bold", color="#993333",
                                   size=7, angle=0))
# Saving the plot
ggsave(paste("TimeSeries of",Lagoon1,perm," Chile",".png"), plot = k, width = 20, height = 10, units = "cm")



# Plotting the Total Water
my.formula <- y ~ x + I(x^2)
o <- ggplot(my_df2, aes(x=Year, y=as.numeric(Area), group = Type)) +
  geom_line(aes(colour = Type), size = .5) +
  geom_point(aes(colour = Type), size = 2) +
  stat_smooth(method = "lm", formula = my.formula, size = .5) +
  scale_x_continuous(breaks=seq(2000, 2018, 1)) +
  geom_vline(xintercept=2010,linetype="dashed", color = "red") +
  stat_poly_eq(formula = my.formula,
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
               label.x = "left", label.y = "bottom",
               parse = TRUE) +
  labs(title = paste0("TimeSeries of ",tot," Water Body in ",Lagoon1,", Chile"),
       caption = "Source: EC JRC/Google") +
  xlab("Year") + ylab("Area"~Km^2) +
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=5, angle=45),
        axis.text.y = element_text(face="bold", color="#993333",
                                   size=7, angle=0))
# Saving the plot
ggsave(paste("TimeSeries of",Lagoon1,tot," Chile",".png"), plot = o, width = 20, height = 10, units = "cm")



# Plotting the Total Water
my.formula <- y ~ x + I(x^2)
a <- ggplot(my_df3, aes(x=Year, y=as.numeric(Area), colour = Type)) +
  geom_line(aes(colour = Type), size = .5) +
  geom_point(aes(colour = Type), size = 2) +
  stat_smooth(method = "lm", formula = my.formula, size = .5) +
  scale_x_continuous(breaks=seq(2000, 2018, 1)) +
  geom_vline(xintercept=2010,linetype="dashed", color = "red") +
  stat_poly_eq(formula = my.formula, 
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               parse = TRUE) + 
  labs(title = paste0("TimeSeries of Water Body in ",Lagoon1,", Chile"),
       caption = "Source: EC JRC/Google") +
  xlab("Year") + ylab("Area"~Km^2) +
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=5, angle=45),
        axis.text.y = element_text(face="bold", color="#993333",
                                   size=7, angle=0))
# Saving the plot
ggsave(paste("TimeSeries of",Lagoon1,all_tg," Chile",".png"), plot = a, width = 20, height = 10, units = "cm")

# Disabling the cores on the device when the process ends
endCluster()
