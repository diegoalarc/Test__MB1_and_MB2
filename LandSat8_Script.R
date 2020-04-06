library(tidyverse)
library(dplyr)
library(raster)
library(rgdal)
library(reshape)
library(scales)
library(rgeos)
library(RStoolbox)
library(lattice)
library(ggplot2)

setwd("B:/")
dir.create("Image_Landsat")

setwd("B:/Image_Landsat/")
dir.create("NDWI")

beginCluster()

##create the path where are all the images Landsat8 we will use.
IMAGE_path <- "B:/Image_Landsat/TIF_Image"
##Load all the images Landsat8 in one list.
all_IMAGE <- list.files(IMAGE_path,
                        full.names = TRUE,
                        pattern = ".tif$")
##Create a List of Raster Files
tmp <- list()

for (i in 1:length(all_IMAGE)){ 
  aculeo_raster <- raster(all_IMAGE[i])
  tmp <- append(tmp,aculeo_raster)
}

##import the vector boundary in the study area.
STUDY_extent <- readOGR("C:/Users/JELG02/OneDrive/Uni-Wue/1er_Semestre/MB2_Introduction_to_Programming_and_Geostatistics/Final_Project/Study_Area.shp")
STUDY_extent <- spTransform(STUDY_extent, crs(tmp[[1]]))

##Create a List of the ROI.
tmp2 <- list()
roi_list <- list()

for (i in 1:length(tmp)){
  tmp2 <- crop(tmp[[i]],STUDY_extent)
  roi_list <- append(roi_list,tmp2)
}

tmp3 <- vector(mode="character")
names <- vector(mode="character")

for (i in 1:length(roi_list)){
  tmp3 <- names(roi_list[[i]])
  names <- append(names,tmp3)
}


sequence <- seq(1,length(tmp)-9,10)
brick_list <- list()
tmp4 <- list()


for (i in sequence){
  tmp4 <- brick(roi_list[[i]],roi_list[[i+1]],roi_list[[i+2]],roi_list[[i+3]],roi_list[[i+4]],roi_list[[i+5]],
                roi_list[[i+6]],roi_list[[i+7]],roi_list[[i+8]],roi_list[[i+9]])
  brick_list <- append(brick_list, tmp4)
}

ndwi <- list()
n_list <- list()
esp <- list()
water_img <- list()

for (i in 1:length(brick_list)){
  esp <- brick(brick_list[i])  
  ndwi <- ((esp[[6]]-esp[[8]])/(esp[[6]]+esp[[8]]))
  ndwi[ndwi>1] <- 1; ndwi[ndwi< (-1)] <- (-1)
  ####Water classfy####
  water_img <- clusterR(ndwi, reclassify, args = list(rcl = c(-Inf, 0, NA, 0, +Inf, 1)), progress = "text")
  
  ###########
  n_list <- append(n_list, water_img)
}

tmp9 <- sort(names[sequence])
names(n_list) <- names[sequence]
n_list = n_list[order(names(n_list))]

###############################
setwd("B:/Image_Landsat/NDWI/")

for (i in 1:length(n_list)){
  #Sample image name
  nm <- n_list[i]
  #Extract year
  yr <- substr(names(nm), start=18, stop=21)
  #Extract month of year
  mt <- substr(names(nm), start=22, stop=23)
  #Extract day of year
  dy <- substr(names(nm), start=24, stop=25)
  
  s_list <- writeRaster(n_list[[i]], filename=paste0("NDWI_",yr,'-',mt,'-',dy), format='GTiff', overwrite=T) 
  
  rm(nm,yr,mt,dy)
}

######################
# Load all the images in one list.
IMAGE_path4 <- "B:/Image_Landsat/NDWI/"
# Load all the images in one list.
all_IMAGE4 <- list.files(IMAGE_path4,
                         full.names = TRUE,
                         pattern = ".tif$")
# Third Temporal Stack for all the Seasonal *.tiff images
tmp_Stack1 <- stack(all_IMAGE4)

# Make a filter from the clarely image created (no moisture present)
tmp_Stack1[is.na(tmp_Stack1[[17]])] <- NA

# Define dataframe and fill it with the Year, Type and Area
# for the difference types of water

# Subtract the characters from the names vector and add them to the dataframe
yr <- vector(mode="character")
mt <- vector(mode="character")
dy <- vector(mode="character")
my_date <- vector(mode="character")

for (i in 1:nlayers(tmp_Stack1)) {
  n <- tmp_Stack1[[i]]
  yr[i] <- substr(names(n), start=6, stop=9)
  mt[i] <- substr(names(n), start=11, stop=12)
  dy[i] <- substr(names(n), start=14, stop=15)
  my_date[i] <- paste0(yr[i],'-',mt[i],'-',dy[i])
}

# Create a matrix with the data "Seasonal" prior to the creation of the dataframe
my_mat <- matrix(data = "NDWI", nrow = nlayers(tmp_Stack1), ncol = 6)

# Create a vector with the years
my_mat[,1] <- yr
my_mat[,2] <- mt
my_mat[,3] <- mt
my_mat[,4] <- my_date

# Create the data frame with the data for "Seasonal"
my_df <- data.frame(my_mat,stringsAsFactors=FALSE)

# Name the headers of the created dataframes
names(my_df) <- c("Year", "Month", "Day", "Date", "Type", "Area")

# For-loop calculating mean of each raster and save it in a dataframe
for (i in 1:nlayers(tmp_Stack1)){
  
  # Extracting the quantity of pixel with the value 1 and sum them
  NDWI_values <- cellStats(tmp_Stack1[[i]], 'sum',na.rm=TRUE)
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project)
  # and divided into 1e-6 to obtain the square Kilometers, which are an
  # easier measure to read in dimension.
  my_df[i,6] <- as.numeric((NDWI_values*9)/10000)
  
  # Clean the values for the loop
  rm(NDWI_values,i)
}

setwd("B:/Image_Landsat/NDWI/")
# SAving the data as Data Frame
write.csv(my_df, file= "B:/Image_Landsat/NDWI/NDWI.csv", row.names = F)

rm(my_df)

# Reading the data saved the data as Data Frame
my_df = read.csv("B:/Image_Landsat/NDWI/NDWI.csv", header=TRUE, sep=",")


for (i in 1:nrow(my_df)){
  my_df[i, 6] <- (round(as.numeric(my_df[i, 6]), digits = 2))
}

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
p <- ggplot(my_df, aes(x=Date, y=as.numeric(Area), group = Type)) +
  geom_line(aes(colour = Type), size = .5) +
  geom_point(aes(colour = Type), size = 2) +
  stat_smooth(method = "lm", formula = my.formula, size = .5) +
  theme(legend.justification = "top") + 
  stat_poly_eq(formula = my.formula,
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
               label.x = "right", label.y = "top",
               parse = TRUE) +
  labs(title = paste0("TimeSeries of Aculeo Lagoon 2015 - 2019, Chile"),
       caption = "LandSat 8") +
  xlab("Date") + ylab("Area"~Km^2) +
  ylim(0, 6.5) +
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=5, angle=270),
        axis.text.y = element_text(face="bold", color="#993333",
                                   size=7, angle=0))
# Saving the plot
ggsave(paste("TimeSeries of Aculeo Lagoon 2015 - 2019, Chile",".png"), plot = p, width = 20, height = 10, units = "cm")

# Disabling the cores on the device when the process ends
endCluster()
