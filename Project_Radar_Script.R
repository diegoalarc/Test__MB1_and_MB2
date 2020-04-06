#######################################################
# Download and display the Area of water and look at them.
# Created just for teaching purpose - not for scientific analysis! 100% accuracy not ensured
# Learning goal: download data, convert them, analyse spatio-temporal data and display them in differents forms.
#######################################################

# Originally written by Diego Alonso Alarcon Diaz in January 2020, latest Version: March 2020
# Code is good to go!

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


# This is the name for the Lagoon for the study
Lagoon <- "Aculeo_Lagoon"

Lagoon1 <- "Aculeo Lagoon"

hard_drive <- "B:/"

# Create the path where are all the *.tiff images we will use.
Water_IMAGE_radar <- paste0(hard_drive,"Radar_data/",Lagoon,"/Geotiff/Image")

# Load all the images in one list.
Water_all_radar <- list.files(Water_IMAGE_radar,
                              full.names = TRUE,
                              pattern = ".tif$")

#Create a stack of Raster Files of radar fixed images with all the *.tiff Water_all_radar
radar <- stack(Water_all_radar)

#Create the vector with the name file
names_radar <- vector(mode="character")

# Setting path for Seasonal Water
setwd(paste0("B:/Radar_data/",Lagoon,"/Geotiff/Image_reclassify/"))

#For-loop to obtain the name file for all the raster in one vector file
#which will be used when the rasters file will be saved
for (i in 1:nlayers(radar)){
  names_radar[[i]] <- names(radar[[i]])
}

# For-loop to create a brick of differents types of water
for (i in 1:nlayers(radar)){
  
  # Create a List of differents types of water
  radar_list <- list()

  # The raster files will be classified according to what is indicated on the website
  radar_list <- reclassify(radar[[i]], c(-Inf, -18, 1, -18, +Inf, NA))
  
  #Extract year
  yr <- substr(names(radar[[i]]), start=8, stop=11)
  
  #Extract month of year
  mt <- substr(names(radar[[i]]), start=5, stop=6)
  
  #Extract day of year
  dy <- substr(names(radar[[i]]), start=2, stop=3)
  
  # Save the Raster with a specific name
  radar_list_wr <- writeRaster(radar_list, filename=paste0("Radar_",yr,'-',mt,'-',dy), format='GTiff', overwrite=T)
  
  # Remove lists
  rm(radar_list)
}
####################################

# Create the path where radar process *.tiff images we will use.
IMAGE_radar_process <- paste0(hard_drive,"Radar_data/",Lagoon,"/Geotiff/Image_reclassify")

# Load all the images in one list.
stack_radar_process <- list.files(IMAGE_radar_process,
                         full.names = TRUE,
                         pattern = ".tif$")

# Temporal Stack for all the radar process *.tiff images
radar_process <- stack(radar_process)

# Make a filter from the clarely image created (no moisture present)
radar_process[is.na(radar_process[[8]])] <- NA

# Subtract the characters from the names vector and add them to the dataframe
yr <- vector(mode="character")
mt <- vector(mode="character")
dy <- vector(mode="character")
my_date <- vector(mode="character")

for (i in 1:nlayers(radar_process)) {
  n <- radar_process[[i]]
  yr[i] <- substr(names(n), start=7, stop=10)
  mt[i] <- substr(names(n), start=12, stop=13)
  dy[i] <- substr(names(n), start=15, stop=16)
  my_date[i] <- paste0(yr[i],'-',mt[i],'-',dy[i])
}

# Create a matrix with the data "Seasonal" prior to the creation of the dataframe
my_mat <- matrix(data = "RADAR", nrow = nlayers(radar_process), ncol = 6)

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
for (i in 1:nlayers(radar_process)){
  
  # Extracting the quantity of pixel with the value 1 and sum them
  Radar_values <- cellStats(radar_process[[i]], 'sum',na.rm=TRUE)
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project)
  # and divided into 1e-6 to obtain the square Kilometers, which are an
  # easier measure to read in dimension.
  my_df[i,6] <- as.numeric((Radar_values*9)/10000)
  
  # Clean the values for the loop
  rm(Radar_values,i)
}

setwd("B:/")

setwd(paste0(hard_drive,"Radar_data/",Lagoon,"/Geotiff/Image_reclassify"))

# SAving the data as Data Frame
write.csv(my_df, "Radar.csv", row.names = F)

rm(my_df)

# Reading the data saved the data as Data Frame
my_df = read.csv(paste0(hard_drive,"Radar_data/",Lagoon,"/Geotiff/Image_reclassify/Radar.csv"), header=TRUE, sep=",")


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
               label.x = "left", label.y = "bottom",
               parse = TRUE) +
  labs(title = paste0("TimeSeries of Aculeo Lagoon between April 2017 - April 2018, Chile"),
       caption = "Sentinel 1") +
  xlab("Date") + ylab("Area"~Km^2) +
  theme(axis.text.x = element_text(face="bold", color="#993333",
                                   size=5, angle=270),
        axis.text.y = element_text(face="bold", color="#993333",
                                   size=7, angle=0))
# Saving the plot
ggsave(paste("TimeSeries of Aculeo Lagoon between April 2017 - 2018, Chile",".png"), plot = p, width = 20, height = 10, units = "cm")

# Disabling the cores on the device when the process ends
endCluster()

