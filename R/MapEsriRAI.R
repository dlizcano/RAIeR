#' @title RAI Esri map
#'
#' @description To project RAI of the selected species on Esri.WorldImagery
#' @author "SMandujanoR"
#'
#' @param Location Name location or study area
#' @param species Select the species
#' @param Proje Projection 1 crs
#' @param reProje Projection 2 sp::CRS
#' @param pointsize Define the size of the circles
#' @param SaveFolder Directory to save plot
#'
#' @importFrom leaflet addProviderTiles addCircleMarkers addLayersControl
#' @importFrom terra vect project crds
#' @importFrom sp SpatialPoints
#' @importFrom mapview mapshot
#'
#' @return Esri map of RAI for selected species
#'
#' @examples
#' \dontrun{
#' MapEsriRAI(
#'   Location = "Cb",
#'   species = "Pec_taj",
#'   Proje = proje2,
#'   reProje = "+proj=longlat +datum=WGS84",
#'   pointsize = 2,
#'   SaveFolder = "Venado"
#' )
#' }
#'
#' @export
#'
MapEsriRAI <- function(Location, species, Proje, reProje, pointsize, SaveFolder) {
  # Read RAI data:
  sp <- read.csv(file.path(SaveFolder, "/Data.csv"), header = T)

  # CTs coordinates and projection:
  CT_points <- sp::SpatialPoints(cbind(sp$X, sp$Y), proj4string = Proje)
  CT_points <- terra::vect(CT_points)
  CT_points <- terra::project(CT_points, reProje)

  # Map Esri en the Viewer:
  leaflet::leaflet() %>%
    addProviderTiles(leaflet::providers$Esri.WorldImagery, group = "Satellite") %>%
    addProviderTiles(leaflet::providers$Esri.WorldTopoMap, group = "Base") %>%
    addCircleMarkers(lng = terra::crds(CT_points)[, 1], lat = terra::crds(CT_points)[, 2], popup = paste(sp$RAI), color = "skyblue", weight = 1, radius = sp$RAI * pointsize, opacity = 0.5, fill = T, fillOpacity = 1) %>%
    addLayersControl(baseGroups = c("Satellite", "Base"), options = leaflet::layersControlOptions(collapsed = FALSE))
} # end function
