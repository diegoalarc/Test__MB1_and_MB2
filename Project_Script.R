# ###########
# download and display Area of water and look the diminish of the Aculeo Lake, Paine, Chile.
# created just for teaching purpose - not for scientific analysis! 100% accuracy not ensured
# learning goal: download data, convert them, analyse spatio-temporal data and display them in differents forms.
# ###########
# 
# idea triggered by these news, videos and personal experience:
# https://twitter.com/copernicusems/status/1178001302829375490
# https://www.youtube.com/watch?v=aEi-itbg4bs
# https://earthobservatory.nasa.gov/images/144836/lake-aculeo-dries-up
# https://www.straitstimes.com/world/americas/drought-wipes-chiles-popular-lake-aculeo-from-the-map
# https://chiletoday.cl/site/how-chile-should-prepare-for-a-future-without-water/
# 
# Originally written by Diego Alonso Alarc?n D?az in January 2020, latest Version: March 2020
# Code is good to go!

#To keep the created code in order, it is suggested to use the following package:
#https://cran.r-project.org/web/packages/styler/styler.pdf
if(!require(styler)){
  install.packages("styler")
  library(styler)
}

#It is necessary to check if the packages are install in  RStudio
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
if(!require(devtools)){
  install.packages("devtools", dependencies = TRUE)
  library(devtools)
}

#######################################################

#It is necessary to set and create the folders before 
#hand to storage the data
setwd("c:/")#Setting path
dir.create("Data")#Create folder

setwd("c:/Data/")#Setting path
dir.create("GIF")#Create folder
dir.create("Permanent_Water")#Create folder
dir.create("Seasonal_Water")#Create folder
dir.create("Total_Water")#Create folder
dir.create("Zona_Study")#Create folder
dir.create("Data_Bruto")#Create folder
dir.create("Seasonal_Water_Color")#Create folder
dir.create("Permanent_Water_Color")#Create folder
dir.create("Total_Water_Color")#Create folder

#######################################################

tempdl <- "c:/Data/Chile_all.zip"
setwd("c:/Data/Data_Bruto/")

#The data necessary for this project will be automatically download
#It is also possible just changing the /Chile_all.zip to another country download the data
fileURL <-
  "https://storage.googleapis.com/global-surface-water-stats/zips/Chile_all.zip"

#Here is necessary to check if the data was downloaded and then unzip the content
if (!file.exists(tempdl)) {
  download.file(fileURL ,tempdl, mode="wb") 
  unzip(tempdl,exdir = ".",overwrite = TRUE)
} else {
  unzip(tempdl,exdir = ".",overwrite = TRUE)
}

#Identify the folders
fromFolder <- "c:/Data/Data_Bruto/"
toFolder <- "c:/Data/Zona_Study/"

#Find the list of files to copy
list.of.files <- list.files(fromFolder, pattern=c("^Chile_classes_(.*)_0000000000-0000128000.tif$"))

#Copy the files to the toFolder  - THIS DOES NOT WORK WHILE EVERYTHING PRIOR HAS WORKED
file.copy(file.path(fromFolder,list.of.files), toFolder, overwrite=TRUE)

#Create the path where are all the *.tiff images we will use.
Water_IMAGE_path <- "C:/Data/Zona_Study/"

#Load all the images in one list.
Water_all_IMAGE <- list.files(Water_IMAGE_path,
                              full.names = TRUE,
                              pattern = ".tif$")

#Create a List of Raster Files
water_aculeo_raster <- list()

#For-loop to create a Raster Files with all the *.tiff images
for (i in 1:length(Water_all_IMAGE)){ 
  water_aculeo_raster[[i]] <- raster(Water_all_IMAGE[i])
}

#######################################################

#In case you want to use a shape file, the following code would be useful:

#Create a List of Raster Files
#water_aculeo_raster <- list()
#tmp <- list()

#For-loop to create a Raster Files with all the *.tiff images
#for (i in 1:length(Water_all_IMAGE)){ 
#  water_aculeo_raster <- raster(Water_all_IMAGE[i])
#  tmp <- append(tmp,water_aculeo_raster)  
#}

#STUDY_extent <- readOGR("C:/Users/JELG02/OneDrive/Uni-Wue/1er_Semestre/MB2_Introduction_to_Programming_and_Geostatistics/Final_Project/Study_Area.shp")
#STUDY_extent <- spTransform(STUDY_extent, crs(tmp[[1]]))

#######################################################

#Create an object with the coordenate

#Here it is create the replace of the shape file with a SpatialPolygons that has extent area as well
x_coord <- c(-70.94622,  -70.87834)
y_coord <- c(-33.87002, -33.82135)
xym <- cbind(x_coord, y_coord)
p = Polygon(xym)
ps = Polygons(list(p),1)
sps = SpatialPolygons(list(ps))
proj4string(sps) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
aculeo_extent <- sps

#Create a List of the crop list
crop_list <- list()

#For-loop to crop the raster in order to obtain the study area
for (i in 1:length(water_aculeo_raster)){
  crop_list[[i]] <- crop(water_aculeo_raster[[i]],aculeo_extent)
}

#For-loop to continue use a shape file, the following code would be useful:
#for (i in 1:length(tmp)){
#  crop_list[[i]] <- crop(tmp[[i]],STUDY_extent)
#}

#Create the vector with the name file
names_file <- vector(mode="character")

#For-loop to obtain the name file for all the raster in one vector file
#which will be used when the rasters file will be saved
for (i in 1:length(crop_list)){
  names_file[[i]] <- names(crop_list[[i]])
}

#Create a List of the brick
brick_list <- list()

#For-loop to create a brick of the crops areas from the raster files
for (i in 1:length(crop_list)){
  brick_list[[i]] <- brick(crop_list[[i]])
}

#######################################################

#For-loop to create a brick of differents types of water
for (i in 1:length(brick_list)){
  
  #Create a List of differents types of water
  t_Seasonal <- list()
  t_Permanent <- list()
  t_water <- list()
  water <- list()
  
  #Create a brick of water bodies
  Water <- brick(brick_list[i])
    
  #https://www.sdg661.app/data-products/data-downloads
  #Classifications 2000-2018. One file per year. This Yearly Seasonality Classification 
  #collection contains annula seasonality maps. Each file has one band with 3 possible values:
  #Values  Description data
  #1  Not water (i.e. Land)
  #2  Seasonal water
  #3  Permanent water
    
  #The raster files will be classified according to what is indicated on the website  
  t_Seasonal <- reclassify(Water, c(0, 1, NA, 1, 2, 1, 2, 3, NA))
  
  #Setting path for Seasonal Water
  setwd("C:/Data/Seasonal_Water/")
  
  #Extract Country
  Country <- substr(names_file[i], start=1, stop=5)
  
  #Extract year of the data
  yr <- substr(names_file[i], start=15, stop=18)
  
  #Save the Raster with a specific name
  s_list <- writeRaster(t_Seasonal, filename=paste0(Country," Seasonal Aculeo Lagoon ",yr), format='GTiff', overwrite=T)
  
  #Remove lists
  rm(Country,yr,t_Seasonal)
  
  #The raster files will be classified according to what is indicated on the website
  t_Permanent <- reclassify(Water, c(0, 2, NA, 2, 3, 1))
  
  #Setting path for Permanent Water
  setwd("C:/Data/Permanent_Water/")
  
  #Extract Country
  Country <- substr(names_file[i], start=1, stop=5)
  
  #Extract year of the data
  yr <- substr(names_file[i], start=15, stop=18)
  
  #Save the Raster with a specific name
  s_list <- writeRaster(t_Permanent, filename=paste0(Country," Permanent Aculeo Lagoon ",yr), format='GTiff', overwrite=T)
  
  #Remove lists
  rm(Country,yr,t_Permanent)
  
  #The raster files will be classified according to what is indicated on the website
  t_water <- reclassify(Water, c(0, 1, NA, 1, 3, 1))
  
  #Setting path for Total Water (Permanent + Seasonal)
  setwd("C:/Data/Total_Water/")
  
  #Extract Country
  Country <- substr(names_file[i], start=1, stop=5)
  
  #Extract year of the data
  yr <- substr(names_file[i], start=15, stop=18)
  
  #Save the Raster with a specific name
  s_list <- writeRaster(t_water, filename=paste0(Country," Total Aculeo Lagoon ",yr), format='GTiff', overwrite=T)
  
  #Remove lists
  rm(Country,yr,t_water,water)
}

#######################################################

#Create a List for a temporal Stack
tmp_Stack1 <- list()

#Create the path where Seasonal *.tiff images we will use.
IMAGE_path2 <- "C:/Data/Seasonal_Water/"

#Load all the images in one list.
all_IMAGE2 <- list.files(IMAGE_path2,
                         full.names = TRUE,
                         pattern = ".tif$")
#Temporal Stack for all the Seasonal *.tiff images
tmp_Stack1 <- stack(all_IMAGE2)


#Create a List for a second temporal Stack
tmp_Stack2 <- list()

#Create the path where Permanent *.tiff images we will use.
IMAGE_path3 <- "C:/Data/Permanent_Water/"

#Load all the images in one list.
all_IMAGE3 <- list.files(IMAGE_path3,
                         full.names = TRUE,
                         pattern = ".tif$")
#Second Temporal Stack for all the Seasonal *.tiff images
tmp_Stack2 <- stack(all_IMAGE3)


#Create a List for a third temporal Stack
tmp_Stack3 <- list()

#Load all the images in one list.
IMAGE_path4 <- "C:/Data/Total_Water/"
#Load all the images in one list.
all_IMAGE4 <- list.files(IMAGE_path4,
                         full.names = TRUE,
                         pattern = ".tif$")
#Third Temporal Stack for all the Seasonal *.tiff images
tmp_Stack3 <- stack(all_IMAGE4)

#######################################################

# Define dataframe and fill it with the Year, Type and Area 
#for the difference types of water

#Subtract the characters from the names vector and add them to the dataframe
my_years <- substr(names_file, start=15, stop=18)

#Create a matrix with the data "Seasonal" prior to the creation of the dataframe
my_mat <- matrix(data = "Seasonal", nrow = length(my_years), ncol = 3)

#Create a vector with the years
my_mat[,1] <- my_years

#Create the data frame with the data for "Seasonal"
my_df <- data.frame(my_mat,stringsAsFactors=FALSE)

#Create a matrix with the data "Permanent" prior to the creation of the dataframe
my_mat1 <- matrix(data = "Permanent", nrow = length(my_years), ncol = 3)

#Create a vector with the years
my_mat1[,1] <- my_years

#Create the data frame with the data for "Permanent"
my_df1 <- data.frame(my_mat1,stringsAsFactors=FALSE)

#Create a matrix with the data "Total" prior to the creation of the dataframe
my_mat2 <- matrix(data = "Total", nrow = length(my_years), ncol = 3)

#Create a vector with the years
my_mat2[,1] <- my_years

#Create the data frame with the data for "Total"
my_df2 <- data.frame(my_mat2,stringsAsFactors=FALSE)

#Name the headers of the created dataframes
names(my_df) <- c("Year", "Type", "Area")
names(my_df1) <- c("Year", "Type", "Area")
names(my_df2) <- c("Year", "Type", "Area")

#For-loop calculating mean of each raster and save it in a dataframe
for (i in 1:length(my_years)){
  
  #Extracting the quantity of pixel with the value 1 and sum them
  area_Seasonal <- cellStats(tmp_Stack1[[i]], 'sum')
  
  #Multiplied by 30m * 30m (Images obtained from the Copernicus project) 
  #and divided into 1e-6 to obtain the square Kilometers, which are an 
  #easier measure to read in dimension.
  my_df[i,3] <- ((area_Seasonal*9)/10000)
  
  #Extracting the quantity of pixel with the value 1 and sum them
  area_Permanent <- cellStats(tmp_Stack2[[i]], 'sum')
  
  #Multiplied by 30m * 30m (Images obtained from the Copernicus project) 
  #and divided into 1e-6 to obtain the square Kilometers, which are an 
  #easier measure to read in dimension.  
  my_df1[i,3] <- ((area_Permanent*9)/10000)
  
  #Multiplied by 30m * 30m (Images obtained from the Copernicus project) 
  #and divided into 1e-6 to obtain the square Kilometers, which are an 
  #easier measure to read in dimension.
  area_total <- (((area_Seasonal+area_Permanent)*9)/10000)
  
  #Sum of the values obtained for both Seasonal and Permanent area
  my_df2[i,3] <- area_total
  
  #Clean the values for the loop
  rm(area_Seasonal,area_Permanent,area_total,i)
}

#Create a final dataframe with information of Seasonal, Permanent and Total values
#for the area of the water body for each year
my_mat3 <- matrix(data = NA, nrow = (length(my_years)*3), ncol = 3)
my_df3 <- data.frame(my_mat3,stringsAsFactors=FALSE)
names(my_df3) <- c("Year", "Type", "Area")
my_df3 <- rbind.data.frame(my_df,my_df1,my_df2)

#For-loop to define the maximum digits which will be available in the column Area
for (i in 1:nrow(my_df3)){
  my_df3[i, 3] <- (round(as.numeric(my_df3[i, 3]), digits = 4))
}

#######################################################
#Units were placed in the data frame but cannot be displayed in the Shiny App table

#It is necessary to check if the packages are install in  RStudio
if(!require(units)){
  install.packages("units")
  library(units)
}

#Placement of units in the Area column corresponding to square Kilometers
b <- data.frame(Area = set_units(as.numeric(my_df3[, 3]), K^2))
my_df3[,3] <- rbind.data.frame(b)

#######################################################

#It is necessary to check if the packages are install in  RStudio
if(!require(maps)){
  install.packages("maps")
  library(maps)
}
if(!require(GISTools)){
  install.packages("GISTools")
  library(GISTools)
}

#Save a path where the *.GIF file will be save
reswd <- "c:/Data/GIF/"
#Here it will be check out if the .GIF was created otherwise the code will run
if(!file.exists(paste0(reswd,"Seasonal.gif"))) {
  #Set the folder where the *.png files will be created
  setwd("c:/Data/Seasonal_Water_Color/")
  ##For-loop to create *.png files for Seasonal Water
  for (i in 1:dim(tmp_Stack1)[3]){
    png(filename=paste0(names(tmp_Stack1)[i],".png"), width = 680, height = 600)
    #Plot of rasters reclassified data
    plot(tmp_Stack1[[i]],
         main=names(tmp_Stack1)[i],
         legend=FALSE,
         col = c("green", "blue"),
         breaks=c(0,.000000000000000000001,1))
    maps::map.scale(x=-70.945, y=-33.865, relwidth=0.15, metric = TRUE, ratio=FALSE)  
    north.arrow(xb=-70.882, yb=-33.827, len=0.0009, lab="N") 
    
    dev.off()
  }
  #Set the folder where the *.GIF file will be created
  setwd("c:/Data/GIF/")
  #Creation of the * .GIF file listing different * .png files in order of name (sorted by years)
  list.files(path="c:/Data/Seasonal_Water_Color/", pattern = '*.png', full.names = TRUE) %>% 
    image_read() %>% # reads each path file
    image_join() %>% # joins image
    image_animate(fps=1) %>% # animates, can opt for number of loops
    image_write("Seasonal.gif") # write to current dir
}

#Here it will be check out if the .GIF was created otherwise the code will run
if(!file.exists(paste0(reswd,"Permanent.gif"))) {
  #Set the folder where the *.png files will be created
  setwd("c:/Data/Permanent_Water_Color/")
  ##For-loop to create *.png files for Permanent Water
  for (i in 1:dim(tmp_Stack2)[3]){
    png(filename=paste0(names(tmp_Stack2)[i],".png"), width = 680, height = 600)
    #Plot of rasters reclassified data
    plot(tmp_Stack2[[i]],
         main=names(tmp_Stack2)[i],
         legend=FALSE,
         col = c("green", "blue"),
         breaks=c(0,.000000000000000000001,1))
    maps::map.scale(x=-70.945, y=-33.865, relwidth=0.15, metric = TRUE, ratio=FALSE)  
    north.arrow(xb=-70.882, yb=-33.827, len=0.0009, lab="N") 
    
    dev.off()
  }
  #Set the folder where the *.GIF file will be created
  setwd("c:/Data/GIF/")
  #Creation of the * .GIF file listing different * .png files in order of name (sorted by years)
  list.files(path="c:/Data/Permanent_Water_Color/", pattern = '*.png', full.names = TRUE) %>% 
    image_read() %>% # reads each path file
    image_join() %>% # joins image
    image_animate(fps=1) %>% # animates, can opt for number of loops
    image_write("Permanent.gif") # write to current dir
}

#Here it will be check out if the .GIF was created otherwise the code will run
if(!file.exists(paste0(reswd,"Total.gif"))) {
  #Set the folder where the *.png files will be created
  setwd("c:/Data/Total_Water_Color/")
  ##For-loop to create *.png files for Total Water
  for (i in 1:dim(tmp_Stack3)[3]){
    png(filename=paste0(names(tmp_Stack3)[i],".png"), width = 680, height = 600)
    #Plot of rasters reclassified data
    plot(tmp_Stack3[[i]],
         main=names(tmp_Stack3)[i],
         legend=FALSE,
         col = c("green", "blue"),
         breaks=c(0,.000000000000000000001,1))
    maps::map.scale(x=-70.945, y=-33.865, relwidth=0.15, metric = TRUE, ratio=FALSE)  
    north.arrow(xb=-70.882, yb=-33.827, len=0.0009, lab="N") 
    
    dev.off()
  }
  #Set the folder where the *.GIF file will be created
  setwd("c:/Data/GIF/")
  #Creation of the * .GIF file listing different * .png files in order of name (sorted by years)
  list.files(path="c:/Data/Total_Water_Color/", pattern = '*.png', full.names = TRUE) %>% 
    image_read() %>% # reads each path file
    image_join() %>% # joins image
    image_animate(fps=1) %>% # animates, can opt for number of loops
    image_write("Total.gif") # write to current dir
}

#######################################################
#Creation and display of a Shiny App in RStudio

#It is necessary to check if the packages are install in  RStudio
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

#add the CSS property white-space: nowrap to the cells in the columns, thus defining a CSS
#class and assigning it to the columns with className in the columnDefs option.
css <- ".nowrap {
  white-space: nowrap;
}"

#######################################################

#Shiny app
ui <- fluidPage(
  #Title and invitation for Shiny App
  navbarPage("Time Series of Surface Water Body in Aculeo Lagoon",
             #######################################################
             
             #First tabPanel with a sidebarpanel composed by sliderInput, radio Buttons, download
             #Button and at the mainpanel it is plot the data from the dataframe
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
             
             #Second tabPanel with a sidebarpanel composed by sliderInput, radio Buttons
             #and at the mainpanel it is plot a *.GIF image
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
             
             #Second tabPanel with a sidebarpanel composed by sliderInput, radio Buttons
             #and at the mainpanel it is plot a *.png image
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
             
             #Second tabPanel with a sidebarpanel composed by sliderInput, radio Buttons
             #and at the mainpanel it is plot the dataframe created
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
    #Filtering the data to create the plot by sliderInput
    (filtered <-
       my_df3 %>%
       filter(Year >= input$yearsInput[1] & Year <= input$yearsInput[2],
              Type == input$typeInput,
       ))
    #Plot the Results using the ggplot2 package
    my.formula <- y ~ x
    ggplot(filtered, aes(Year, y=as.numeric(Area), group = input$typeInput)) +
      geom_line(aes(colour = Type), position = "stack", size = .5) +
      geom_point(aes(colour = Type), position = "stack", size = 2) +
      geom_smooth(method="loess", se=TRUE, formula= my.formula) +
      stat_poly_eq(formula = my.formula, 
                   aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
                   label.x = "left", label.y = "bottom",
                   parse = TRUE) +
      labs(title = "TimeSeries Aculeo Lagoon", subtitle = glue("All data here is produced under the Copernicus Programme, free of charge, without restriction of use."),
           caption = "Source: EC JRC/Google") +
      xlab("Year") + ylab("Area"~Km^2) + 
      theme_light()
    
  })
  
  #######################################################
  
  plotInput = function() {
    #Plot the Results using a function and getting the this one ready for download this as a *.png
    (filtered <-
       my_df3 %>%
       filter(Year >= input$yearsInput[1] & Year <= input$yearsInput[2],
              Type == input$typeInput,
       ))
    
    my.formula <- y ~ x
    ggplot(filtered, aes(Year, y=as.numeric(Area), group = input$typeInput)) +
      geom_line(aes(colour = Type), position = "stack", size = .5) +
      geom_point(aes(colour = Type), position = "stack", size = 2) +
      geom_smooth(method="loess", se=TRUE, formula= my.formula) +
      stat_poly_eq(formula = my.formula, 
                   aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
                   label.x = "left", label.y = "bottom",
                   parse = TRUE) +
      labs(title = "TimeSeries Aculeo Lagoon", subtitle = glue("All data here is produced under the Copernicus Programme, free of charge, without restriction of use."),
           caption = "Source: EC JRC/Google") +
      xlab("Year") + ylab("Area"~Km^2) + 
      theme_light()
  }
  
  #######################################################
  
  output$download_plot = downloadHandler(
    #Function to download the plot made it by ggplot
    filename = paste("Choose_a_name.png", sep=''),
    content = function(file) {
      device <- function(..., width, height) {
        grDevices::png(..., width = width, height = height,
                       res = 500, units = "in")
      }
      ggsave(file, plot = plotInput(), device = device)
    })
  
  #######################################################
  
  output$preImage <- renderImage({
    #Created the file name from the information of the radio Buttons in order to 
    #display the *.GIF image to the whole period of time for a type of water body
    filename <- normalizePath(file.path('c:/Data/GIF',
                                        paste(input$typeInput1, '.gif', sep='')))
    
    #Return a list containing the filename and alt text
    list(src = filename,
         alt = paste(input$typeInput1))
  }, deleteFile = FALSE)
  
  #################################################
  
  output$Image <- renderImage({
    #Created the file name from the information of the radio Buttons in order to 
    #display the *.png image for an specific period of time and type of water body
    filename <- normalizePath(file.path('c:/Data',
                                        paste(input$typeInput2,"_Water_Color/","Chile_",input$typeInput2,"_",input$yearsInput2, ".png", sep='')))
    
    #Return a list containing the filename and alt text
    list(src = filename,
         alt = paste(input$typeInput2))
  }, deleteFile = FALSE)
  
  #######################################################
  
  filtered_data <- reactive({
    #A reactive function to filter the Table to plot and download it
    data <- my_df3 %>%
      filter(Year >= input$yearsInput3[1] & Year <= input$yearsInput3[2],
             Type == input$typeInput3)
  })
  
  #######################################################
  
  #This is the function to render the table and order it
  output$table <- DT::renderDataTable({
    data <- filtered_data()
    datatable(data,  options = list(pageLength = length(my_years),
                                    columnDefs = list(
                                      list(className = "nowrap", targets = "_all")
                                    )
    ),rownames = FALSE) 
  })
  
  #######################################################
  
  #Function to download the Table filtered before
  output$download_data <- downloadHandler(
    
    filename = paste("Aculeo_Lagoon_Data",".csv",sep=''),
    content = function(file) {
      data <- filtered_data()
      write.csv(data, file, row.names = FALSE)
    }
  )
}
shinyApp(ui = ui, server = server)