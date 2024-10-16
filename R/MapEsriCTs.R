#' @title Function `MapEsriCTs`
#'
#' @description Function to map the camera traps in Esri
#' @author "G. Andrade-Ponce & SMandujanoR"
#'
#' @param CTs Coordinates XY of camera traps
#' @param Proje Projection 1 crs
#' @param reProje Projection 2 sp::CRS
#'
#' @importFrom leaflet addProviderTiles addCircleMarkers addLayersControl
#' @importFrom terra vect project crds
#' @importFrom sp SpatialPoints
#' @importFrom mapview mapshot
#'
#' @return map of the camera traps in Esri map projection in the RStudio Viewer
#'
#' @examples
#' \dontrun{
#' MapEsriCTs(CTs = habitat.data, Proje = proje2, reProje = "+proj=longlat +datum=WGS84")
#' }
#'
#' @export
#'
MapEsriCTs <- function(CTs, Proje, reProje) {
  # CTs coordinates and projection:
  CT_points <- sp::SpatialPoints(cbind(CTs$X, CTs$Y), proj4string = Proje)
  CT_points <- terra::vect(CT_points)
  CT_points <- terra::project(CT_points, reProje)

  # Map Esri en the Viewer:
  leaflet::leaflet() %>%
    addProviderTiles(leaflet::providers$Esri.WorldImagery, group = "Satellite") %>%
    addProviderTiles(leaflet::providers$Esri.WorldTopoMap, group = "Base") %>%
    addCircleMarkers(lng = terra::crds(CT_points)[, 1], lat = terra::crds(CT_points)[, 2], popup = paste(CTs$Camera), color = "skyblue", weight = 1, radius = 7, opacity = 0.5, fill = T, fillOpacity = 0.75) %>%
    addLayersControl(baseGroups = c("Satellite", "Base"), options = leaflet::layersControlOptions(collapsed = FALSE))
} # end function
