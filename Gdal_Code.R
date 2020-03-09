
setwd("c:/")# Setting path
dir.create("Data")# Create folder

setwd("c:/Data/")# Setting path
dir.create("Test")# Create folder
dir.create("Chile_Mosaic")# Create folder

rasdir <- 'C:/Data/Data_Bruto/'

input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2000(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2000.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))






input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2001(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2001.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))





input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2002(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2002.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))




input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2003(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2003.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))



input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2004(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2004.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))



input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2005(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2005.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))






input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2006(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2006.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))





input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2007(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2007.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))




input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2008(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2008.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))




input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2009(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2009.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))




input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2010(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2010.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))






input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2011(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2011.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))









input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2012(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2012.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))







input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2013(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2013.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))









input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2014(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2014.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))








input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2015(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2015.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))










input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2016(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2016.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))







input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2017(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2017.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))








input1 <- list.files(path=rasdir, pattern=c("^Chile_classes_2018(.*).tif$"), full.names=T)

input2 <- input1[1]
input3 <- input1[2]
input4 <- input1[3]
input5 <- input1[4]
input6 <- input1[5]
input7 <- input1[6]
input8 <- input1[7]
input9 <- input1[8]
input10 <- input1[9]

output <- "C:/Data/Test/Test.vrt"

output_translate <- "C:/Data/Chile_Mosaic/Chile_classes_2018.tif"


system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdalbuildvrt', output, input2,input3,input4,input5,input6,input7,input8,input9,input10))



system2(command = "C:/Program Files/QGIS 3.10/OSGeo4W.bat",
        args = paste('gdal_translate -of Gtiff', output, output_translate))








#############################################################

system2(command = 'C:/Program Files/QGIS 3.10/OSGeo4W.bat',
        args = 'gdalbuildvrt C:/results2/1/blend/part1_blend.vrt
C:/results2/1/blend/*.PNG')

system2(command = 'C:/Program Files/QGIS 3.4/OSGeo4W.bat',
        args = 'gdal_translate C:/results2/1/blend/part1_blend.vrt
C:/results2/1/blend/part1_blend.tif')

