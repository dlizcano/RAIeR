#' @title Map the camera traps
#'
#' @description Function to map the camera traps in the study area
#' @author "SMandujanoR"
#'
#' @param map Shapefile of the study area
#' @param CTs Coordinates XY of camera traps
#' @param SaveFolder Directory to save plot
#' @param mapColor Select 1 or -1 to define viridis color
#' @param pointColor Define color to camera trap point
#'
#' @return plot of camera traps in the study area
#'
#' @importFrom ggplot2 aes facet_grid theme_bw theme labs scale_size scale_fill_continuous geom_point ggtitle scale_fill_manual stat_density_2d scale_fill_gradientn element_text facet_grid geom_sf coord_sf
#'
#' @examples
#' \dontrun{
#' MapCT(map = mapProje,
#'      CTs = habitat.data,
#'      mapColor = 1,
#'      pointColor = "black",
#'      SaveFolder = "Results")
#' }
#' @export
#'
MapCT <- function(map, CTs, mapColor, pointColor, SaveFolder) {

  Veg <- CTs$Veg_type # shortcut to run the script
  Y <- CTs$Y
  X <- CTs$X

  # map plot:
  miplot <- ggplot2::ggplot(data = map) +
    ggplot2::geom_sf(ggplot2::aes(fill = Veg)) +
    ggplot2::scale_fill_viridis_d(direction = mapColor) +
    ggplot2::geom_point(data = CTs, aes(X, Y), shape = 16, color = pointColor, size = 3) +
    ggplot2::coord_sf(datum = sf::st_crs(map)) +
    ggplot2::theme_bw() +
    ggplot2::labs(x = "UTM-X", y = "UTM-Y") +
    ggplot2::theme(plot.title = element_text(color = "black", size = 12, face = "bold", hjust = 0.5)) +
    ggplot2::theme(strip.text = element_text(size = 10, color = "black"))

  jpeg(filename = file.path(SaveFolder, paste("/MapCTs", ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot)
  dev.off()

  return(miplot)

} # end function
