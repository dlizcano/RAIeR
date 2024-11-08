###################################################
# `RAIeR` package to calculate relative abundance (RAI) and encounter rate (eR) from camera trap data.
# Created by: Salvador Mandujano R.
# Last modified: October 30, 2024.
###################################################

# 1. INSTALLATION

# Install the package from:
devtools::install_github("SMandujanoR/RAIeR")

# Load:
library(RAIeR)

# Check the help to see all the functions:
help(package="RAIeR")

# Cite this package as:
citation(package = "RAIeR")

####################################################
# 2. TEST DATA

# To illustrate the use of the RAIeR package, the internal files and maps contained in this package could be loaded.

# Species data in the camera traps (CTs):
data("CTs_Spp", package = "RAIeR")
View(CTs_Spp)

# Coordinate and covariate data for each of the cameras:
data("CTs_habitat", package = "RAIeR")
View(CTs_habitat)

# Camera operativity data:
data("CTs_Operativity", package = "RAIeR")
View(CTs_Operativity)

# -----
# Second data set already formatted as required by the RAIeR package, this data set is the same as the "wildlife.data2_Cb.csv" file:
data("CTs_Spp2", package = "RAIeR")
View(CTs_Spp2)

# Second covariate data set for each of the cameras:
data("CTs_habitat2", package = "RAIeR")
View(CTs_habitat2)

# -----
# To read the raster and shapefile of the study area in shapefile format:
(fpath <- system.file("extdata", "veg.shp", package="RAIeR"))
# [1] "/Users/smandujanor/Library/R/x86_64/4.4/library/RAIeR/extdata/veg.shp"

# Copy path and read with the terra package:
map <- terra::vect("/Users/smandujanor/Library/R/x86_64/4.4/library/RAIeR/extdata/veg.shp")

# Map:
terra::plot(map)

# Layer in raster format:
(fpath <- system.file("extdata", "CBVegRaster.tif", package="RAIeR"))
# [1] "/Users/smandujanor/Library/R/x86_64/4.4/library/RAIeR/extdata/CBVegRaster.tif"

# Copy path and read with terra package:
map2 <- terra::rast("/Users/smandujanor/Library/R/x86_64/4.4/library/RAIeR/extdata/CBVegRaster.tif")

# Map:
terra::plot(map2)

########################################################
# 3. DATA REFORMAT

# Function to: format dates from "mdY HM" format to "Ymd HM" format, create columns "Location", "Year" and "Season"), and generate subsets of data.frames:

# Read data of animals species:
data_Spp <- read.csv("data/CT_Spp2.csv", header = T)
View(data_Spp)

# if necessary delete the first column:
data_Spp <- data_Spp[,-1]

# -------------
# Function:
date_LYS(df_Spp = data_Spp,
         Location = "CB",
         mdY = T,
         Jan="1",
         Feb="1",
         Mar="1",
         Apr="1",
         May="1",
         Jun="2",
         Jul="2",
         Aug="2",
         Sep="2",
         Oct="2",
         Nov="2",
         Dec="1",
         Y.init = 2020,
         Y.end = 2020,
         S.init = 1,
         S.end = 2)

# -----------
# Function to format the file by grouping all the data:

# Read previously generated data.frame with the previous function:
data_Spp <- read.csv("data/Cb_Lys.csv", header = T)
View(data_Spp)

# if necessary, remove the first column:
data_Spp <- data_Spp[,-1]

# Read operativity data:
CTs <- read.csv("data/CT_operativity2.csv", header = T, sep = ";")
View(CTs)

# -------------------------
# Function:

dataFormat(Location = "Cb",
           data_Spp = data_Spp,
           data_CT = CTs,
           Problem = F)

# ------------
# Function to format separately the data.frame of each location, year and period:

dataFormatDF(dframe = "data/df/Cb_2020_1.csv",
             data_CT = CTs,
             Problem = F)

dataFormatDF(dframe = "data/df/Cb_2020_2.csv",
             data_CT = CTs,
             Problem = F)

###################################################
# 4. READING DATA IN THE FORMAT FOR RAIeR

wildlife.data <- read.csv("data/wildlife.data2_Cb.csv", header = T)
View(wildlife.data)

# if necessary delete column:
wildlife.data <- wildlife.data[,-1]

# Read coordinate and covariate data from the study area:
habitat.data <- read.csv("data/CT_habitat2.csv", header = T)
View(habitat.data)

# ------------
# Merge both data.frames by camera:
data <- merge(x = wildlife.data, y = habitat.data, by = "Camera", all = TRUE)
View(data)

# IMPORTANT: Save this new data.frame to use later in subsequent analyses with this package:
write.csv(data, "data/data.csv")

################################################
# 5. VISUALIZING CAMERAS ON MAPS

# Create results folder:
dir.create("Results")

# IMPORTANT: Whenever the RAIeR package is used, the shapefile and raster of the study area must be loaded first.

# Load the shape and raster of the study area:
map <- vect("shapes/veg.shp")
map
names(map)

# IMPORTANT: Rename the vegetation type category/column to "Veg" as required by the RAIeR package to create maps:

library(tidyterra)

# in this example the "Tipo_Suelo" category is renamed to "Veg"
map <- map %>% rename(
  Veg = tipo_Suelo)

# verify the name change:
map

# Read the raster layer of the study area:
map2 <- rast("shapes/CBVegRaster.tif")

# Object needed for several functions that create maps:
proje1 <- crs("+proj=utm +zone=14 +datum=WGS84")
###proje1 <- crs("EPSG:32614") # optional

# Object needed for 'MapEsriCTs()' function:
proje2 <- sp::CRS("+proj=utm +zone=14 +datum=WGS84 +towgs84=0,0,0")

# Reprojected map used in most functions:
mapProje <- project(map, proje1)
###mapProjeX <- project(map, crs("EPSG:32614"))

# Self-selected color palette for vegetation types in the study area: 

my_colors <- c("gold",            # Irrigated agriculture
               "deepskyblue2",    # Permanent river 
               "darkolivegreen4", # TDF Neo
               "darkolivegreen1", # TDF Mim
               "azure3",          # Saltworks
               "darkorange2"      # Scrub-cras
)

# ----------- 
# OPTIONAL. Use the following function to extract information on vegetation types in each camera trap using the raster layer of the study location, and integrate it as a new column/covariate in the data.frame "habitat.data":

Map_extract(map = map2,
            CTs = habitat.data,
            SaveFolder = "data")

# IMPORTANT: when using this function, a new covariate is created that is added and saved in the "data" folder with the name "habitat.data.csv", and read again:

habitat.data <- read.csv("data/habitat.data.csv", header = T)
View(habitat.data)

# then merge and save again:

data <- merge(x = wildlife.data, y = habitat.data, by = "Camera", all = TRUE)
View(data)
write.csv(data, "data/datos.csv")

# ---------
# Function to display CTs in the shape of the study area:

MapCT(map = mapProje,
      CTs = habitat.data,
      mapColor = 1,
      pointColor = "black",
      SaveFolder = "Results")

# -------------
# Function to project the photographic events of each CT in Esri.WorldImagery:

MapEsriCTs(CTs = habitat.data,
           Proje = proje2,
           reProje = "+proj=longlat +datum=WGS84")

# -------------
# Function for the design of field sampling according to possible systematic arrangements of the cameras:

SamplDesg(map = mapProje,
          Proje = proje1,
          n1 = 5,
          n2 = 6,
          CTx = 691000,
          CTy = 2007500,
          CTdist = 500,
          legend = "bottom", 
          colors = my_colors, SaveFolder = "Results")

################################################
# 6. RAI ESTIMATION FOR A SPECIES

# Read previously saved data:
data <- read.csv("data/datos.csv", header = T)
View(data)

# Create a folder for each species:
dir.create("Zorra")

# ---------
# Function to calculate the RAI of the species for each camera. This function must be executed before any other:

RAI_CTs(species = "Uro_cin",
        df = datos,
        SaveFolder = "Zorra")

# ---------
# Function to generate a map of the RAI of the species:

MapRAI(Location = "Cb",
       species = "Uro_cin",
       map = mapProje,
       mapColor = 1,
       pointColor = "black",
       SaveFolder = "Zorra")

# ---------
# Function to project the RAI in Esri.WorldImagery:

MapEsriRAI(Location = "Cb",
           species = "Uro_cin",
           Proje = proje2,
           reProje = "+proj=longlat +datum=WGS84",
           pointsize = 0.75,
           SaveFolder = "Zorra")

# ---------
# Function to generate raster and jpg based on the kernel density for the selected species.

#Season 1:
MapKernelSp(Location = "Cb",
            species = "Uro_cin",
            Season = 1,
            map = mapProje,
            Proje = proje1,
            my_colors = my_colors,
            S.extent = 1,
            UD95 = 95,
            UD50 = 50,
            pointSize = 0.3,
            SaveFolder = "Slut")

#Season 2:
MapKernelSp(Location = "Cb",
            species = "Uro_cin",
            Season = 2,
            map = mapProje,
            Proje = proje1,
            my_colors = my_colors,
            S.extent = 1,
            UD95 = 95,
            UD50 = 50,
            pointSize = 0.3,
            SaveFolder = "Slut")

# ---------
# Function to create RAI facet graphs by year and time, for each location:

RAI_facet(Location = "Cb",
          species = "Uro_cin",
          RAIsize = 18,
          map = mapProje,
          mapColor = 1,
          pointColor = "black",
          SaveFolder = "Zorra")

# ---------
# Function to calculate the RAI of the species by year, time and time/year, for each location:

RAI_Loc(Location = "Cb",
        species = "Uro_cin",
        Ymax = 8,
        SaveFolder = "Zorra")

# ---------
# Function to compare the RAI by habitat type in each year and time for each location:

RAI_Habitat(Location = "Cb",
            species = "Uro_cin",
            fontSize = 8,
            SaveFolder = "Zorra")

# ---------
# Function to estimate RAIs between locations, years and periods:
  
  RAI_LYS(species = "Uro_cin",
          SaveFolder = "Zorra")

################################################
# 7. eR ESTIMATION FOR MULTIPLE SPECIES

# All results in this section are automatically saved in the previously created "Results" folder:
###dir.create("Results")

# Read previously saved data:
data <- read.csv("data/datos.csv", header = T)
View(datos)

# -------
# Function to calculate the overall eR, in relative percentage, and naive occupancy:

eR_Gen(data, 
       SaveFolder = "Results")

# ----------------
# Function to display event records by camera for the selected species(ies):

MapEventsSpp(data,
             c("Syl_flo", "Odo_vir", "Can_lat", "Uro_cin"),
             parRow = 2,
             parCol = 2,
             pointSize = 0.5,
             labels = T,
             SaveFolder = "Results")

# ---------
# Function to calculate the eR for each species by camera:
dev.off()

eR_CTs(data,
       Ymax = 5,
       SaveFolder = "Results")

# ---------
# Function for statistical tests (Anova, Tukey's post hoc tests and HSD) of the eR between species:

eR_test(Ymax = 15, 
        SaveFolder = "Results")

# ---------
# Function to calculate the eR for all species as a generalized linear model (GLM):

eR_glm(data,
       family = "poisson",
       SaveFolder = "Results")

# ---------
# Function to generate the final table with all the results:

eR_resTab(data, SaveFolder = "Results")

# ---------
# Function to generate the matrix of the eR and Events by species and camera, useful for diversity analysis in other packages:

eR_matx(SaveFolder = "Results") 

# ---------
# Function to plot the eR for the species in different locations and years:

eR_LYS(df = datos,
       Factor = datos$Location,
       Name = "Location" ,
       bubSize = 15,
       fontSize = 12,
       SaveFolder = "Results")

eR_LYS(df = datos,
       Factor = datos$Year,
       Name = "Year",
       bubSize = 15,
       fontSize = 12,
       SaveFolder = "Results")

eR_LYS(df = datos,
       Factor = datos$Season,
       Name = "Season",
       bubSize = 15,
       fontSize = 12,
       SaveFolder = "Results")

# ---------
# Function to plot the eR facets by year and season:

eR_facet(df = datos, 
         bubSize = 7, 
         fontSize = 6, 
         SaveFolder = "Results") 

################################## 
# END SCRIPT