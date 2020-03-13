# Code Test MB2
Here is the project for the MB2 course Introduction to Programming and Geostatistics

Through this script an easy and fast way is proposed to observe the decrease over time of the water level of the Acualeo Lagoon in Chile. It is also possible to modify this code to observe other gaps in the world, using the data provided by [Global SDG database](https://www.sdg661.app/data-products/data-downloads) and a a preset georeferenced area (which can be changed by a Shapefile).

# Scrips

The main __script__ that concerns us in this project is called __Project_Script.R__ 
Within this we can find code for:

 - Raster Data
 - Copy files to other folders
 - Tiff files selected by means of a Shape
 - Shiny App
 
The second script that can be seen is called __Project_QGIS_Script.R__ which was generated to obtain the images that were used for the __QGIS__ project of the [Master EAGLE](http://eagle-science.org/) and was intended to work with mosaics at the country level and cut entire regions with memory efficiency. Within this you can find the main up grade with reference to the previous code:

 - Command to call __GDAL__ in __QGIS__ from __RStudio__
 - Plot generation and saved directly in a route pre-established by the code.

This script was made for testing purposes and can be used and modified in the future by those who deem it convenient.
