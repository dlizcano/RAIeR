#' @title map of the RAI in CTs
#'
#' @description Function to create a map of the RAI values in each camera trap for the selected species
#' @author "SMandujanoR"
#'
#' @param Location Name location or study area
#' @param species Select the species
#' @param map shapefile of the study area
#' @param mapColor Select 1 or -1 to define viridis color
#' @param pointColor Define color to camera trap point
#' @param SaveFolder Directory to save results
#'
#' @importFrom ggplot2 aes facet_grid theme_bw theme labs scale_size scale_fill_continuous geom_point ggtitle scale_fill_manual stat_density_2d scale_fill_gradientn element_text facet_grid geom_sf coord_sf
#' @importFrom stringr str_to_title
#'
#' @return Map with RAI per camera trap
#' @examples
#' \dontrun{
#' MapRAI(
#'   Location = "Cb",
#'   species = "Odo_vir",
#'   map = mapProje,
#'   mapColor = 1,
#'   pointColor = "black",
#'   SaveFolder = "Venado")
#' }
#'
#' @export
MapRAI <- function(Location, species, map, mapColor, pointColor, SaveFolder) {

  # Read data:
  new.mat <- read.csv(file.path(SaveFolder, "/Data.csv"), header = T)

  Veg <- new.mat$Veg_type
  RAI <- new.mat$RAI
  Y <- new.mat$Y
  X <- new.mat$X

  # map plot:
miplot <- ggplot2::ggplot(data = map) +
  ggplot2::geom_sf(ggplot2::aes(fill = Veg)) +
  ggplot2::scale_fill_viridis_d(direction = mapColor) +
  ggplot2::geom_point(data = new.mat, aes(X, Y, size = RAI), shape = 16, color = pointColor) +
  ggplot2::coord_sf(datum = sf::st_crs(map)) +
  ggplot2::theme_bw() +
  ggplot2::labs(x = "UTM-X", y = "UTM-Y", title = species) +
  ggplot2::theme(text = element_text(size = 7)) +
  ggplot2::theme(plot.title = element_text(color = "black", size = 12, face = "bold", hjust = 0.5)) +
  ggplot2::theme(strip.text = element_text(size = 10, color = "black"))

jpeg(filename = file.path(SaveFolder, paste("/MapRAI.1_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
print(miplot)
dev.off()

    return(miplot)

} # end function
