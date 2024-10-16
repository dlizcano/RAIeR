#' @title Function `RAIeR`
#'
#' @description Function to create a map of the RAI values in each camera trap for the selected species
#' @author "SMandujanoR"
#'
#' @param Location Name location or study area
#' @param species Select the species
#' @param map shapefile of the study area
#' @param pointSize Define the size of the circles
#' @param colors Name of your own palete colors
#' @param SaveFolder Directory to save results
#'
#' @importFrom terra plot points north sbar
#' @importFrom grDevices dev.off jpeg
#' @importFrom stringr str_to_title
#'
#' @return Map with RAI per camera trap
#' @examples
#' \dontrun{
#' MapRAI(
#'   Location = "Cb",
#'   species = "Pec_taj",
#'   map = mapProje,
#'   pointSize = 1,
#'   colors = my_colors,
#'   SaveFolder = "Pecari"
#' )
#' }
#'
#' @export
#'
MapRAI <- function(Location, species, map, pointSize, colors, SaveFolder) {
  # Read data:
  new.mat <- read.csv(file.path(SaveFolder, "/Data.csv"), header = T)

  # map plot:
  miplot <- terra::plot(map, col = colors, fill = T, lty = 0, main = species)
  terra::points(new.mat$X, new.mat$Y, pch = 16, col = "#00000170", cex = new.mat$RAI * pointSize)
  terra::north()
  terra::sbar(2000, xy = "bottomright", divs = 2, cex = 0.7, ticks = TRUE, type = "bar", below = "meters")

  dev.copy(jpeg, filename = file.path(SaveFolder, paste("/MapRAI.1_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot)
  dev.off()

  return(miplot)
} # end function
