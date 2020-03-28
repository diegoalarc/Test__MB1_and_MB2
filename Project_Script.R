#######################################################
# Download and display the Area of water and look the diminish of the Aculeo Lagoon, Paine, Chile.
# Created just for teaching purpose - not for scientific analysis! 100% accuracy not ensured
# Learning goal: download data, convert them, analyse spatio-temporal data and display them in differents forms.
#######################################################

# Idea triggered by these news, videos and personal experience:
# https://twitter.com/copernicusems/status/1178001302829375490
# https://www.youtube.com/watch?v=aEi-itbg4bs
# https://earthobservatory.nasa.gov/images/144836/lake-aculeo-dries-up
# https://www.straitstimes.com/world/americas/drought-wipes-chiles-popular-lake-aculeo-from-the-map
# https://chiletoday.cl/site/how-chile-should-prepare-for-a-future-without-water/

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
if(!require(snow)){
  install.packages("snow")
  library(snow)
}
if(!require(ClusterR)){
  install.packages("ClusterR")
  library(ClusterR)
}
if(!require(devtools)){
  install.packages("devtools")
  library(devtools)
}
if(!require(svDialogs)){
  install.packages(c("svGUI", "svDialogs"))
  library(svDialogs)
}
#######################################################
# It is necessary to set and create the folders 
# the folders before hand to storage the data

# dlg_dir() #######################################################
# Here you can define the path where all the information will be stored
setwd(dlg_dir(default = getwd())$res)

#######################################################

dir.create("Data")# Create folder
setwd("/Data/")# Setting path
dir.create("GIF")# Create folder
dir.create("Permanent_Water")# Create folder
dir.create("Seasonal_Water")# Create folder
dir.create("Total_Water")# Create folder
dir.create("Zona_Study")# Create folder
dir.create("Data_Bruto")# Create folder
dir.create("Seasonal_Water_Color")# Create folder
dir.create("Permanent_Water_Color")# Create folder
dir.create("Total_Water_Color")# Create folder

#######################################################

tempdl <- file.path(getwd(),"Chile_all.zip")


# The data necessary for this project will be automatically download
# It is also possible just changing the /Chile_all.zip to another country download the data
fileURL <- "https://storage.googleapis.com/global-surface-water-stats/zips/Chile_all.zip"

# Here is necessary to check if the data was downloaded and then unzip the content body water .Tiff in Chile
if (!file.exists(tempdl)) {
  download.file(fileURL ,tempdl, mode="wb")
  unzip(tempdl, exdir = file.path(getwd(),"Data_Bruto"),overwrite = TRUE)
} else {
  unzip(tempdl, exdir = file.path(getwd(),"Data_Bruto"),overwrite = TRUE)
}

#######################################################
# Don't forget to change the name if you change the study area
# This is the name for the Lagoon for the study
Lagoon <- "Aculeo Lagoon"

#######################################################
# Here is one of the most important step depending of the water body do you want to study
# you should look at the shapefile after running the code in order to be secure
# that the script is working for you and then you could select a new water body if you want to make a study
# of a different area.

# PLEASE ERASE THE SYMBOL # FROM THE CODE IF YOU WANT TO USE THIS PART OF THE SCRIPT

#dir.create("Shapefile")# Create folder

# This is the name from the column "NOMBRE" in the following shapefile we need to download for the study
#shape_lagoon <- "LAGUNA DE ACULEO"

# It is also possible just changing the /Masas_Lacustres.zip whish contain all the body water shape in Chile
#fileURL_1 <- "http://www.dga.cl/estudiospublicaciones/mapoteca/Inventarios/catastro_de_lagos.zip"

# Here is necessary to check if the data was downloaded and then unzip the content body water shape in Chile
#if (!file.exists(tempdl)) {
#  download.file(fileURL_1 ,tempdl, mode="wb")
#  unzip(tempdl, exdir = file.path(getwd(),"Shapefile"),overwrite = TRUE)
#} else {
#  unzip(tempdl, exdir = file.path(getwd(),"Shapefile"),overwrite = TRUE)
#}

# read shape (Lake`s in Chile)
#shape <- readOGR(dsn=file.path(getwd(),"Shapefile"), layer="catastro_de_lagos")

# Subset from the shape (Lake`s in Chile)
#shape_water_body <- subset(shape, NOMBRE == shape_lagoon)
# Reprojection of the shape
#shape_water_body_wgs84 <- spTransform(shape_water_body, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

#######################################################

# If you are going to use the Shapefile you must place the symbol # in front of 
# each line of code in this section of the script

# Create an object with the coordenate
# Here it is create the replace of the shape file with a SpatialPolygons that has extent area as well
x_coord <- c(-70.94622,  -70.87834, -70.87834, -70.94622, -70.94622)
y_coord <- c(-33.87002, -33.87002, -33.82135, -33.82135, -33.87002)
xym <- cbind(x_coord, y_coord)
p = Polygon(xym)
ps = Polygons(list(p),1)
sps = SpatialPolygons(list(ps))
proj4string(sps) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
data = data.frame(f=99.9)
spdf = SpatialPolygonsDataFrame(sps,data)
shape_water_body_wgs84 <- spdf

#######################################################

# Identify the folders
setwd("/Data/")# Setting path
toFolder <- file.path(getwd(),"Zona_Study/")

#######################################################

# Change path to folder containing rasters
rasdir <- file.path(getwd(),"Data_Bruto/")

# List all GeoTIFF files in folder, change extension in pattern if different format
fllst <- list.files(path=rasdir, pattern=c("^Chile_classes_(.*).tif$"), full.names=T)

# New vector for storing file names of intersecting rasters
newlst <- c()

# Activation of the cores in the device and focus these in the following process
beginCluster()

# Loop through files
for (fl in fllst){
  r <- raster(fl)
  # Transform shapefile to match crs of raster
  shape_water_body_wgs84 <- spTransform(shape_water_body_wgs84, crs(r))
  # Check if raster intersects shapefile
  # Suppress warnings from function is optional
  if (suppressWarnings(!(is.null(intersect(shape_water_body_wgs84, extent(r))))))
  {
    # If raster intersects, add file name to vector
    newlst <- c(newlst, fl)
  }
}

# Copy the files to the toFolder
file.copy(file.path(newlst), toFolder, overwrite=TRUE)

# Delete the directory "Data_Bruto"
unlink("./Data_Bruto", recursive = TRUE, force = TRUE)

# Create the path where are all the *.tiff images we will use.
Water_IMAGE_path <- file.path(getwd(),"Zona_Study/")

# Load all the images in one list.
Water_all_IMAGE <- list.files(Water_IMAGE_path,
                              full.names = TRUE,
                              pattern = ".tif$")

# Create a stack of Raster Files with all the *.tiff Water_all_IMAGE
water_aculeo_raster <- stack(Water_all_IMAGE)

#######################################################

# Create a List of the crop list
crop_list <- list()

# For-loop to crop the raster in order to obtain the study area
for (i in 1:nlayers(water_aculeo_raster)){
  crop_list[[i]] <- crop(water_aculeo_raster[[i]],shape_water_body_wgs84)
}

#Create the vector with the name file
names_file <- vector(mode="character")

#For-loop to obtain the name file for all the raster in one vector file
#which will be used when the rasters file will be saved
for (i in 1:length(crop_list)){
  names_file[[i]] <- names(crop_list[[i]])
}

#Create a stack of Raster Files with all the *.tiff cropped
Water <- stack(crop_list)

#######################################################

# For-loop to create a brick of differents types of water
for (i in 1:nlayers(Water)){
  
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
  t_Seasonal <- clusterR(Water[[i]], reclassify, args = list(rcl = c(0, 1, NA, 1, 2, 1, 2, 3, NA)), progress = "text")
  
  # Extract Country
  Country <- substr(names(Water[[i]]), start=1, stop=5)
  
  # Extract year of the data
  yr <- substr(names(Water[[i]]), start=15, stop=18)
  
  # Save the Raster with a specific name
  s_list <- writeRaster(t_Seasonal, filename=file.path(getwd(),"Seasonal_Water",paste0("Seasonal_Water_for ",Lagoon,"_",yr,"_",Country)), format='GTiff', overwrite=T)
  
  # Remove lists
  rm(t_Seasonal)
  
  # The raster files will be classified according to what is indicated on the website
  t_Permanent <- clusterR(Water[[i]], reclassify, args = list(rcl = c(0, 2, NA, 2, 3, 1)), progress = "text")
  
  # Save the Raster with a specific name
  s_list <- writeRaster(t_Permanent, filename=file.path(getwd(),"Permanent_Water",paste0("Permanent_Water_for_",Lagoon,"_",yr,"_",Country)), format='GTiff', overwrite=T)
  
  # Remove lists
  rm(t_Permanent)
  
  # The raster files will be classified according to what is indicated on the website
  t_water <- clusterR(Water[[i]], reclassify, args = list(rcl = c(0, 1, NA, 1, 3, 1)), progress = "text")
  
  # Save the Raster with a specific name
  s_list <- writeRaster(t_water, filename=file.path(getwd(),"Total_Water",paste0("Total_Water_for_",Lagoon,"_",yr,"_",Country)), format='GTiff', overwrite=T)
  
  # Remove lists
  rm(t_water)
}

# Remove lists
rm(Country,yr)

#######################################################

# Create the path where Seasonal *.tiff images we will use.
IMAGE_path2 <- file.path(getwd(),"Seasonal_Water")

# Load all the images in one list.
all_IMAGE2 <- list.files(IMAGE_path2,
                         full.names = TRUE,
                         pattern = ".tif$")

# Temporal Stack for all the Seasonal *.tiff images
tmp_Stack1 <- stack(all_IMAGE2)

# Create the path where Permanent *.tiff images we will use.
IMAGE_path3 <- file.path(getwd(),"Permanent_Water")

# Load all the images in one list.
all_IMAGE3 <- list.files(IMAGE_path3,
                         full.names = TRUE,
                         pattern = ".tif$")

# Second Temporal Stack for all the Seasonal *.tiff images
tmp_Stack2 <- stack(all_IMAGE3)

# Load all the images in one list.
IMAGE_path4 <- file.path(getwd(),"Total_Water")

# Load all the images in one list.
all_IMAGE4 <- list.files(IMAGE_path4,
                         full.names = TRUE,
                         pattern = ".tif$")

# Third Temporal Stack for all the Seasonal *.tiff images
tmp_Stack3 <- stack(all_IMAGE4)

#######################################################

# Define dataframe and fill it with the Year, Type and Area 
# for the difference types of water
#Create the vector with the name file
my_years <- vector(mode="character")

# Subtract the characters from the names vector and add them to the dataframe
my_years <- substr(names_file, start=15, stop=18)


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
  area_Seasonal <- cellStats(tmp_Stack1[[i]], 'sum', progress = "text")
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project) 
  # and divided into 1e-6 to obtain the square Kilometers, which are an 
  # easier measure to read in dimension.
  my_df[i,3] <- ((area_Seasonal*9)/10000)
  
  # Extracting the quantity of pixel with the value 1 and sum them
  area_Permanent <- cellStats(tmp_Stack2[[i]], 'sum', progress = "text")
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project) 
  # and divided into 1e-6 to obtain the square Kilometers, which are an 
  # easier measure to read in dimension.  
  my_df1[i,3] <- ((area_Permanent*9)/10000)
  
  # Multiplied by 30m * 30m (Images obtained from the Copernicus project) 
  # and divided into 1e-6 to obtain the square Kilometers, which are an 
  # easier measure to read in dimension.
  area_total <- (((area_Seasonal+area_Permanent)*9)/10000)
  
  # Sum of the values obtained for both Seasonal and Permanent area
  my_df2[i,3] <- area_total
  
  # Clean the values for the loop
  rm(area_Seasonal,area_Permanent,area_total,i)
}

# Create a final dataframe with information of Seasonal, Permanent and Total values
# for the area of the water body for each year
my_mat3 <- matrix(data = NA, nrow = (length(my_years)*3), ncol = 3)
my_df3 <- data.frame(my_mat3,stringsAsFactors=FALSE)
names(my_df3) <- c("Year", "Type", "Area")
my_df3 <- rbind.data.frame(my_df,my_df1,my_df2)

# For-loop to define the maximum digits which will be available in the column Area
for (i in 1:nrow(my_df3)){
  my_df3[i, 3] <- (round(as.numeric(my_df3[i, 3]), digits = 4))
}

# Create a final dataframe with information of Seasonal, Permanent and Total values
# for the area of the water body for each year plot in the Table for Shiny App with the unit Km^2
my_mat4 <- matrix(data = NA, nrow = (length(my_years)*3), ncol = 3)
my_df4 <- data.frame(my_mat3,stringsAsFactors=FALSE)
names(my_df4) <- c("Year", "Type", "Area [Km^2]")
my_df4 <- rbind.data.frame(my_df,my_df1,my_df2)

#######################################################
# Units were placed in the data frame but cannot be displayed in the Shiny App table

# It is necessary to check if the packages are install in  RStudio
if(!require(units)){
  install.packages("units")
  library(units)
}

# Placement of units in the Area column corresponding to square Kilometers
b <- data.frame(Area = set_units(as.numeric(my_df4[, 3]), K^2))
my_df4[,3] <- rbind.data.frame(b)
names(my_df4) <- c("Year", "Type", "Area [K^2]")

#######################################################

# It is necessary to check if the packages are install in  RStudio
if(!require(maps)){
  install.packages("maps")
  library(maps)
}
if(!require(GISTools)){
  install.packages("GISTools")
  library(GISTools)
}

setwd("/Data/")# Setting path
# Save a path where the *.GIF file will be save
color_image_path <- file.path(getwd())
# Save a path where the *.PNG file will be save
reswd <- file.path(getwd(),"GIF")
# Here it will be check out if the .GIF was created otherwise the code will run
if(!file.exists(paste0(reswd,"/Seasonal.gif"))) {
  # Set the folder where the *.png files will be created
  setwd(file.path(getwd(),"Seasonal_Water_Color/"))
  # For-loop to create *.png files for Seasonal Water
  for (i in 1:dim(tmp_Stack1)[3]){
    # Extract Country
    Country <- substr(names(Water[[i]]), start=1, stop=5)
    # Extract year of the data
    yr <- substr(names(Water[[i]]), start=15, stop=18)
    # Setting the name for the *.png image
    png(filename=paste0("Seasonal Water for ",Lagoon," ",yr," ",Country,".png"), width = 680, height = 600)
    # Plot of rasters reclassified data
    plot(tmp_Stack1[[i]],
         main = paste0("Seasonal Water for ",Lagoon," ",yr,", ",Country),
         legend = FALSE,
         col = c("green", "blue"),
         breaks=c(0,.000000000000000000001,1))
    maps::map.scale(x=-70.945, y=-33.865, relwidth=0.15, metric = TRUE, ratio=FALSE)  
    north.arrow(xb=-70.882, yb=-33.827, len=0.0009, lab="N") 
    
    dev.off()
  }
  # Set the folder where the *.GIF file will be created
  setwd("/Data/GIF/")
  # Creation of the * .GIF file listing different * .png files in order of name (sorted by years)
  list.files(path = file.path(color_image_path,"Seasonal_Water_Color/"), pattern = '*.png', full.names = TRUE) %>% 
    image_read() %>% # reads each path file
    image_join() %>% # joins image
    image_animate(fps=1) %>% # animates, can opt for number of loops
    image_write("Seasonal.gif") # write to current dir
}

setwd("/Data/")# Setting path

# Here it will be check out if the .GIF was created otherwise the code will run
if(!file.exists(paste0(reswd,"/Permanent.gif"))) {
  # Set the folder where the *.png files will be created
  setwd(file.path(getwd(),"Permanent_Water_Color/"))
  # For-loop to create *.png files for Permanent Water
  for (i in 1:dim(tmp_Stack1)[3]){
    # Extract Country
    Country <- substr(names(Water[[i]]), start=1, stop=5)
    # Extract year of the data
    yr <- substr(names(Water[[i]]), start=15, stop=18)
    # Setting the name for the *.png image
    png(filename=paste0("Permanent Water for ",Lagoon," ",yr," ",Country,".png"), width = 680, height = 600)
    # Plot of rasters reclassified data
    plot(tmp_Stack2[[i]],
         main = paste0("Permanent Water for ",Lagoon," ",yr,", ",Country),
         legend = FALSE,
         col = c("green", "blue"),
         breaks=c(0,.000000000000000000001,1))
    maps::map.scale(x=-70.945, y=-33.865, relwidth=0.15, metric = TRUE, ratio=FALSE)  
    north.arrow(xb=-70.882, yb=-33.827, len=0.0009, lab="N") 
    
    dev.off()
  }
  # Set the folder where the *.GIF file will be created
  setwd("/Data/GIF/")
  # Creation of the * .GIF file listing different * .png files in order of name (sorted by years)
  list.files(path = file.path(color_image_path,"Permanent_Water_Color/"), pattern = '*.png', full.names = TRUE) %>% 
    image_read() %>% # reads each path file
    image_join() %>% # joins image
    image_animate(fps=1) %>% # animates, can opt for number of loops
    image_write("Permanent.gif") # write to current dir
}

setwd("/Data/")# Setting path

# Here it will be check out if the .GIF was created otherwise the code will run
if(!file.exists(paste0(reswd,"/Total.gif"))) {
  # Set the folder where the *.png files will be created
  setwd(file.path(getwd(),"Total_Water_Color/"))
  # For-loop to create *.png files for Total Water
  for (i in 1:dim(tmp_Stack3)[3]){
    # Extract Country
    Country <- substr(names(Water[[i]]), start=1, stop=5)
    # Extract year of the data
    yr <- substr(names(Water[[i]]), start=15, stop=18)
    # Setting the name for the *.png image
    png(filename=paste0("Total Water for ",Lagoon," ",yr," ",Country,".png"), width = 680, height = 600)
    # Plot of rasters reclassified data
    plot(tmp_Stack3[[i]],
         main = paste0("Total Water for ",Lagoon," ",yr,", ",Country),
         legend=FALSE,
         col = c("green", "blue"),
         breaks=c(0,.000000000000000000001,1))
    maps::map.scale(x=-70.945, y=-33.865, relwidth=0.15, metric = TRUE, ratio=FALSE)  
    north.arrow(xb=-70.882, yb=-33.827, len=0.0009, lab="N") 
    
    dev.off()
  }
  # Set the folder where the *.GIF file will be created
  setwd("/Data/GIF/")
  # Creation of the * .GIF file listing different * .png files in order of name (sorted by years)
  list.files(path = file.path(color_image_path,"Total_Water_Color/"), pattern = '*.png', full.names = TRUE) %>% 
    image_read() %>% # reads each path file
    image_join() %>% # joins image
    image_animate(fps=1) %>% # animates, can opt for number of loops
    image_write("Total.gif") # write to current dir
}

# Disabling the cores on the device when the process ends
endCluster()

setwd("/Data/")# Setting path

#######################################################
# Creation and display of a Shiny App in RStudio

# It is necessary to check if the packages are install in  RStudio
if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}
if(!require(shiny)){
  install.packages("shiny")
  library(shiny)
}
if(!require(DT)){
  install.packages("DT")
  library(DT)
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

# Add the CSS property white-space: nowrap to the cells in the columns, thus defining a CSS
# class and assigning it to the columns with className in the columnDefs option.
css <- ".nowrap {
  white-space: nowrap;
}"

#######################################################

# Shiny app
ui <- fluidPage(
  # Title and invitation for Shiny App
  navbarPage("Time Series of Surface Water Body in Aculeo Lagoon",
             #######################################################
             
             # First tabPanel with a sidebarpanel composed by sliderInput, radio Buttons, download
             # Button and at the mainpanel it is plot the data from the dataframe
             tabPanel("Area v/s Years",
                      sidebarLayout(position = "left",
                                    sidebarPanel(
                                      sliderInput("yearsInput", "Choose Years between:", 2000, 2018, c(2000, 2001)),
                                      radioButtons("typeInput", "Choose a type of water:",
                                                   choices = c("Permanent", "Seasonal", "Total"),
                                                   selected = "Total"),
                                      downloadButton('download_plot')
                                    ),
                                    mainPanel(plotOutput("coolplot")
                                    ))
             ),
             #######################################################
             
             # Second tabPanel with a sidebarpanel composed by sliderInput, radio Buttons
             # and at the mainpanel it is plot a *.GIF image
             tabPanel("Timeseries representation in a GIF",
                      sidebarLayout(position = "left",
                                    sidebarPanel(
                                      radioButtons("typeInput1", "Choose a type of water:",
                                                   choices = c("Permanent", "Seasonal", "Total"),
                                                   selected = "Total")
                                    ),
                                    mainPanel(plotOutput(outputId="preImage", width="480px",height="400px")))
             ),
             #######################################################
             
             # Second tabPanel with a sidebarpanel composed by sliderInput, radio Buttons
             # and at the mainpanel it is plot a *.png image
             tabPanel("Image for the Year and Type",
                      sidebarLayout(position = "left",
                                    sidebarPanel(
                                      sliderInput("yearsInput2", "Choose Years between:", 2000, 2018, value = 2000),
                                      radioButtons("typeInput2", "Choose a type of water:",
                                                   choices = c("Permanent", "Seasonal", "Total"),
                                                   selected = "Total")
                                    ),
                                    mainPanel(plotOutput(outputId="Image", width="480px",height="400px")))
             ),
             #######################################################
             
             # Second tabPanel with a sidebarpanel composed by sliderInput, radio Buttons
             # and at the mainpanel it is plot the dataframe created
             tabPanel("Table of Data",
                      sidebarLayout(position = "left",
                                    sidebarPanel(
                                      sliderInput("yearsInput3", "Choose Years between:", 2000, 2018, c(2000, 2001)),
                                      radioButtons("typeInput3", "Choose a type of water:",
                                                   choices = c("Permanent", "Seasonal", "Total"),
                                                   selected = "Total"),
                                      downloadButton("download_data")),
                                    mainPanel(DT::dataTableOutput("table")))
             ))
)

#######################################################

server <- function(input, output, session) {
  
  output$coolplot <- renderPlot({
    # Filtering the data to create the plot by sliderInput
    (filtered <-
       my_df3 %>%
       filter(Year >= input$yearsInput[1] & Year <= input$yearsInput[2],
              Type == input$typeInput,
       ))
    # Plot the Results using the ggplot2 package
    my.formula <- y ~ x + I(x^2)
    ggplot(filtered, aes(Year, y=as.numeric(Area), group = input$typeInput)) +
      geom_line(aes(colour = Type), position = "stack", size = .5) +
      geom_point(aes(colour = Type), position = "stack", size = 2) +
      geom_smooth(method="lm", se=TRUE, formula= my.formula) +
      stat_poly_eq(formula = my.formula, 
                   aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
                   label.x = "left", label.y = "center",
                   parse = TRUE) +
      labs(title = paste("TimeSeries ",Lagoon), subtitle = glue("All data here is produced under the Copernicus Programme, free of charge, without restriction of use."),
           caption = "Source: EC JRC/Google") +
      xlab("Year") + ylab("Area"~Km^2) + 
      theme(axis.text.x = element_text(face="bold", color="#993333",
                                       size=15, angle=270),
            axis.text.y = element_text(face="bold", color="#993333",
                                       size=17, angle=0))
    
  })
  
  #######################################################
  
  plotInput = function() {
    # Plot the Results using a function and getting the this one ready for download this as a *.png
    (filtered <-
       my_df3 %>%
       filter(Year >= input$yearsInput[1] & Year <= input$yearsInput[2],
              Type == input$typeInput,
       ))
    
    my.formula <- y ~ x + I(x^2)
    ggplot(filtered, aes(Year, y=as.numeric(Area), group = input$typeInput)) +
      geom_line(aes(colour = Type), position = "stack", size = .5) +
      geom_point(aes(colour = Type), position = "stack", size = 2) +
      geom_smooth(method="lm", se=TRUE, formula= my.formula) +
      stat_poly_eq(formula = my.formula, 
                   aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
                   label.x = "left", label.y = "center",
                   parse = TRUE) +
      labs(title = paste("TimeSeries ",Lagoon), subtitle = glue("All data here is produced under the Copernicus Programme, free of charge, without restriction of use."),
           caption = "Source: EC JRC/Google") +
      xlab("Year") + ylab("Area"~Km^2) + 
      theme(axis.text.x = element_text(face="bold", color="#993333",
                                       size=15, angle=270),
            axis.text.y = element_text(face="bold", color="#993333",
                                       size=17, angle=0))
  }
  
  #######################################################
  
  output$download_plot = downloadHandler(
    # Function to download the plot made it by ggplot
    filename = paste("Choose_a_name.png", sep=''),
    content = function(file) {
      device <- function(..., width, height) {
        grDevices::png(..., width = 20, height = 10,
                       res = 500, units = "cm")
      }
      ggsave(file, plot = plotInput(), device = device)
    })
  
  #######################################################
  
  output$preImage <- renderImage({
    # Created the file name from the information of the radio Buttons in order to 
    # display the *.GIF image to the whole period of time for a type of water body
    filename <- normalizePath(file.path(getwd(),'GIF',
                                        paste(input$typeInput1, '.gif', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         alt = paste(input$typeInput1))
  }, deleteFile = FALSE)
  
  #################################################
  
  output$Image <- renderImage({
    # Created the file name from the information of the radio Buttons in order to 
    # display the *.png image for an specific period of time and type of water body
    filename <- normalizePath(file.path(getwd(),
                                        paste(input$typeInput2,"_Water_Color/",input$typeInput2," Water for Aculeo Lagoon ",input$yearsInput2," Chile",".png", sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         alt = paste(input$typeInput2))
  }, deleteFile = FALSE)
  
  #######################################################
  
  filtered_data <- reactive({
    # A reactive function to filter the Table to plot and download it
    data <- my_df4 %>%
      filter(Year >= input$yearsInput3[1] & Year <= input$yearsInput3[2],
             Type == input$typeInput3)
  })
  
  #######################################################
  
  # This is the function to render the table and order it
  output$table <- DT::renderDataTable({
    data <- filtered_data()
    datatable(data,  options = list(pageLength = length(my_years),
                                    columnDefs = list(
                                      list(className = "nowrap", targets = "_all")
                                    )
    ),rownames = FALSE) 
  })
  
  #######################################################
  
  # Function to download the Table filtered before
  output$download_data <- downloadHandler(
    
    filename = paste("Aculeo_Lagoon_Data",".csv",sep=''),
    content = function(file) {
      data <- filtered_data()
      write.csv(data, file, row.names = FALSE)
    }
  )
}
shinyApp(ui = ui, server = server)