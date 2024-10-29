#' @title  Facet graph for RAI comparison
#'
#' @description To comparison RAI by habitat type during each year and season, in a selected location
#' @author "SMandujanoR"
#'
#' @param Location Name location or study area
#' @param species Select the species
#' @param map shapefile of the study area
#' @param RAIsize Define the point size
#' @param mapColor Select 1 or -1 to define viridis color
#' @param pointColor Define color to camera trap point
#' @param SaveFolder Directory to save results
#'
#' @importFrom stringr str_to_title
#' @importFrom grDevices terrain.colors dev.copy dev.off jpeg
#' @importFrom tidyterra geom_spatvector
#' @importFrom sf st_crs
#' @importFrom ggplot2 aes facet_grid theme_bw theme labs scale_size scale_fill_continuous geom_point ggtitle scale_fill_manual stat_density_2d scale_fill_gradientn element_text facet_grid geom_sf coord_sf
#'
#' @return Facet plots
#'
#' @examples
#' \dontrun{
#' RAI_facet(
#'   Location = "Cb",
#'   species = "Odo_vir",
#'   RAIsize = 40,
#'   map = mapProje,
#'   mapColor = 1,
#'   pointColor = "black",
#'   SaveFolder = "Venado"
#' )
#' }
#'
#' @export
#'
RAI_facet <- function(Location, species, RAIsize, map, mapColor, pointColor, SaveFolder) {

  # Read data:
  new.mat <- read.csv(file.path(SaveFolder, "/Data.csv"), header = T)

  Veg <- new.mat$Veg_type
  RAI <- new.mat$RAI
  Y <- new.mat$Y
  X <- new.mat$X

  # Plot 1: RAI CTs
  miplot1 <- ggplot2::ggplot(new.mat, ggplot2::aes(x = X, y = Y, size = RAI, fill = RAI)) +
    ggplot2::geom_point(alpha = 1, shape = 21, color = "white") +
    ggplot2::scale_size(range = c(1, RAIsize), guide = "none") +
    ggplot2::labs(x = "UTM-X", y = "UTM-Y", title = "") +
    ggplot2::scale_fill_continuous(name = "RAI", type = "viridis") +
    ggplot2::ggtitle(paste(species)) +
    ggplot2::theme_bw() +
    ggplot2::theme(text = element_text(size = 8)) +
    ggplot2::theme(plot.title = element_text(color = "black", size = 12, face = "bold", hjust = 0.5)) +
    ggplot2::theme(strip.text = element_text(size = 10, color = "black")) +
    ggplot2::facet_grid(Year ~ Season, labeller = ggplot2::label_both)

  jpeg(filename = file.path(SaveFolder, paste("/MapRAI.2_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot1)
  dev.off()

  # ------------
  # Plot: vegetation types
  miplot2 <- ggplot2::ggplot(data = map) +
    ggplot2::geom_sf(ggplot2::aes(fill = Veg)) +
    ggplot2::scale_fill_viridis_d(direction = , mapColor) +
    ggplot2::geom_point(data = new.mat, aes(X, Y, size = RAI), shape = 16, color = pointColor) +
    ggplot2::coord_sf(datum = sf::st_crs(map)) +
    ggplot2::theme_bw() +
    ggplot2::labs(x = "UTM-X", y = "UTM-Y", title = species) +
    ggplot2::theme(text = element_text(size = 7)) +
    ggplot2::theme(plot.title = element_text(color = "black", size = 12, face = "bold", hjust = 0.5)) +
    ggplot2::theme(strip.text = element_text(size = 10, color = "black")) +
    ggplot2::facet_grid(Year ~ Season, labeller = ggplot2::label_both)

  jpeg(filename = file.path(SaveFolder, paste("/MapRAI.3_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot2)
  dev.off()

  # ------------
  # Plot: Kernel density
  miplot3 <- ggplot2::ggplot(new.mat, ggplot2::aes(X, Y, size = RAI)) +
    ggplot2::geom_density_2d_filled(bins = 5) +
    ggplot2::geom_point() +
    ggplot2::scale_fill_viridis_d(direction = -1) +
    ##ggplot2::scale_fill_gradient(colours = grDevices::terrain.colors(5, rev = T)) +
    ggplot2::coord_sf(datum = sf::st_crs(map)) +
    ggplot2::theme_bw() +
    ggplot2::labs(x = "UTM-X", y = "UTM-Y", title = species) +
    ggplot2::theme(text = element_text(size = 7)) +
    ggplot2::theme(plot.title = element_text(color = "black", size = 12, face = "bold", hjust = 0.5)) +
    ggplot2::theme(strip.text = element_text(size = 10, color = "black")) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::facet_grid(Year ~ Season, labeller = ggplot2::label_both)

  jpeg(filename = file.path(SaveFolder, paste("/MapRAI.4_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot3)
  dev.off()

  return(list(miplot1, miplot2, miplot3))
} # end function
