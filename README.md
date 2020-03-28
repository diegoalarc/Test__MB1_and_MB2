!["Uni Wuerzburg"](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Total_Water/EAGLE_logo.png?raw=true "EAGLE Msc")

# *Codes for the approval of the MB1 and MB2 [Master EAGLE](http://eagle-science.org/) courses at the Julius-Maximilians-Universität Würzburg, Germany.*

***
## [MB2](http://eagle-science.org/project/programming-and-geostatistical-analysis/) course: *First Script*

Corresponds to the project for the [MB2 course Introduction to Programming and Geostatistics](http://eagle-science.org/project/programming-and-geostatistical-analysis/).

Through this first script an easy and fast way is proposed to observe the decrease over time of the water level of the Acualeo Lagoon in Chile. It is also possible to modify this code to observe other gaps in the world, using the data provided by [Global SDG database](https://www.sdg661.app/data-products/data-downloads) and a a preset georeferenced area (which can be changed by a Shapefile).

[Link to download the water bodies of Chile by Global SDG database](https://storage.googleapis.com/global-surface-water-stats/zips/Chile_all.zip)

One of the most important characteristics of this script is that it is generic, therefore it can be used for any type of body of water in the world while its extent is known. For this, within the code between lines 121 and 153 is the option to download a shapefile that makes up the cadastre of lakes in Chile obtained from the official page of the [General direction of waters](https://dga.mop.gob.cl/Paginas/default.aspx) in Chile. Which can be used to facilitate the understanding of how to use a database such as a shapefile in this script.

[Link to download the cadastre of lakes in Chile](http://www.dga.cl/estudiospublicaciones/mapoteca/Inventarios/catastro_de_lagos.zip)

## [MB1](http://eagle-science.org/project/digital-image-analysis-and-gis/) course: *Second Script and Map* 

Corresponds to the project for the [MB1 course Digital Image Analysis and GIS](http://eagle-science.org/project/digital-image-analysis-and-gis/).

This second script was intended to work with mosaics at the country level and cut entire regions with memory efficiency. Within this, you can find a higher rating with reference to the previous code for images and mosaics, and a direct way to save plotted graphics for each type of water body. The products of this script. Using the [OTB toolbox](https://www.orfeo-toolbox.org/) by [QGIS](https://www.qgis.org/en/site/) it was used for change detection making an iteration of the different tiff image created by the R Script. It was possible to made a unique Tiff where was differenced by its Digital Number for each unique year which represent the state of the art of Permanet and Seasonal water to generate a final map that shows the decrease in the body of water of the Aculeo lagoon between 2010 and 2018. It is necessary to add that by means of the histogram visualization of the digital pixel values of the new TIFF created with change detection, the ranges of each year were obtained and classified with different colors for an easier visual representation for the users.

In parallel [LandSat 8](https://www.usgs.gov/land-resources/nli/landsat/landsat-8) images were used with which the Normalized Difference Water Index was calculated using the McFeeters Method, 1996. This is based on the substitution of the SWIR band by the visible green band, highlighting the water masses. In this case, the relation of analysis of multispectral bands will be:

![equation](http://www.sciweavers.org/tex2img.php?eq=NDWI%3D%5Cfrac%7B%28GREEN-NIR%29%7D%7B%28GREEN%2BNIR%29%7D%0A&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0)

With the above, a Time Series analysis was generated between 2015 and 2019 with a temporal resolution of approximately 15 day to be able to observe the behavior of the body of water using data from another satellite and at the same time obtain the vacuum between 2018 and 2019. It could be observed that after the lagoon dried up it was not observed again that it reappeared.

***
## *Scripts Overviews*

### [MB2](http://eagle-science.org/project/programming-and-geostatistical-analysis/) course:

The main __script__ that concerns us in this project is called [Project_Script.R](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Project_Script.R) which corresponds to the [MB2](http://eagle-science.org/project/programming-and-geostatistical-analysis/) course of the [Master EAGLE](http://eagle-science.org/).

Within this code we can find:

 - Raster Data of [Water Bodies](https://www.sdg661.app/data-products/data-downloads).
 - Copy files to other folders.
 - Tiff files selected by match of a Shapefile or an object extend made in R in it extent.
 - Select of Tiff images in an automatic form and copy to another folder.
 - Use [Shiny App](https://shiny.rstudio.com/).

### [MB1](http://eagle-science.org/project/digital-image-analysis-and-gis/) course:

The second __script__ that is called [Project_QGIS_Script.R](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Project_QGIS_Script.R) and [LandSat8_Script.R](https://github.com/diegoalarc/Test__MB1_and_MB2/blob/master/LandSat8_Script.R). Both were generated to obtain the images and charts that were used for the [QGIS](https://www.qgis.org/en/site/) project which corresponds to the [MB1 course Digital Image Analysis and GIS](http://eagle-science.org/project/digital-image-analysis-and-gis/) of the [Master EAGLE](http://eagle-science.org/) to create an explicative and visually attractive map.

Within the codes we can find:

 - Command to call [GDAL](https://gdal.org/) in [QGIS](https://www.qgis.org/en/site/) from [RStudio](https://rstudio.com/)
 - Crop the area from a shapefile without using the temporary file from RStudio through [GDAL](https://gdal.org/).
 - Plot generation and saved directly in a route pre-established by the code.

***
## *Script and QGIS products*

### [MB2](http://eagle-science.org/project/programming-and-geostatistical-analysis/) course: Created using [Project_Script.R](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Project_Script.R) it is possible to obtain Graphs, Images, GIF and Tables.

!["TimeSeries of Aculeo Lagoon Chile between 2000 - 2018 "](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Total_Water/TimeSeries%20of%20Aculeo%20Lagoon%20%20all%20%20%20Chile%20.png?raw=true "TimeSeries of Aculeo Lagoon Chile between 2000 - 2018")

 - TimeSeries of Permanent Water body for Aculeo Lagoon between 2000 - 2018.

![](https://github.com/diegoalarc/Code_Test_MB2/blob/master/GIF/Permanent.gif)

#### Here you can see some examples of the images that were generated by applying the [Project_Script.R](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Project_Script.R) for the project of [QGIS](https://www.qgis.org/en/site/):
 
 - [i.e. Images for the total water body of the Aculeo Lagoon, which represent the sum of Seasonal and Permanent water bodies](https://github.com/diegoalarc/Code_Test_MB2/tree/master/Total_Water).

 - [i.e. Images NDWI of the Aculeo Lagoon from 2015 to 2019](https://github.com/diegoalarc/Test__MB1_and_MB2/tree/master/NDWI_LandSat8_2015_2019).

---

### [MB1](http://eagle-science.org/project/digital-image-analysis-and-gis/) course: Created using [Project_QGIS_Script.R](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Project_QGIS_Script.R), [OTB toolbox](https://www.orfeo-toolbox.org/) inside of [QGIS](https://www.qgis.org/en/site/) and [LandSat 8](https://www.usgs.gov/land-resources/nli/landsat/landsat-8) images was possible generated the information need it to elaborate the following map using [QGIS](https://www.qgis.org/en/site/):

#### Here you can see the __Change Detection images__ that were generated by applying the [OTB toolbox](https://www.orfeo-toolbox.org/) by QGIS

 - [Pemanent Water - Change detection from 2010 to 2018.](https://github.com/diegoalarc/Test__MB1_and_MB2/blob/master/Change_detection/Change_detection_Permanent_2010_2018.tif)
 
![Pemanent Water - Change detection from 2010 to 2018](https://github.com/diegoalarc/Test__MB1_and_MB2/blob/master/Change_detection/Change_detection_Permanent_2010_2018.png?raw=true "Pemanent Water - Change detection from 2010 to 2018")

 - [Seasonal Water - Change detection from 2010 to 2018.](https://github.com/diegoalarc/Test__MB1_and_MB2/blob/master/Change_detection/Change_detection_Seasonal_2010_2018.tif)
 
![Seasonal Water - Change detection from 2010 to 2018](https://github.com/diegoalarc/Test__MB1_and_MB2/blob/master/Change_detection/Change_detection_Seasonal_2010_2018.png?raw=true "Seasonal Water - Change detection from 2010 to 2018")

 - NDWI - Example of 2015-11-28.
 
![NDWI - Example of 2015-11-28](https://github.com/diegoalarc/Test__MB1_and_MB2/blob/master/NDWI_LandSat8_2015_2019/NDWI_2015-11-28.png?raw=true "NDWI - Example of 2015-11-28")

 - Click in the following link to download the final file in the total resolution of the map ["Aculeo Lagoon TimeSeries drought map from 2010 - 2018"](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Map_QGIS_Generated/QGIS_EAGLE_Msc.pdf).

!["Aculeo Lagoon TimeSeries drought map from 2010 - 2018"](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Map_QGIS_Generated/QGIS_EAGLE_Msc_compressed.png?raw=true "Aculeo Lagoon TimeSeries drought map from 2010 - 2018")

## [Download the map by clicking here](https://github.com/diegoalarc/Code_Test_MB2/blob/master/Map_QGIS_Generated/QGIS_EAGLE_Msc.pdf)

***
## *Contact references:*
### *Phone: 01525 5311223*
### *Email: diego.alarcondiaz@gmail.com*
### *LinkedIn: www.linkedin.com/in/diegoalarcóndíaz/*

***
### *GNU General Public License v2.0 - Copyright (C)*

This script was made for testing purposes and can be used and modified in the future by those who deem it convenient.
