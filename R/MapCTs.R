#' @title Function `MapCT`
#'
#' @description Function to map the camera traps in the study area
#' @author "SMandujanoR"
#'
#' @param map Shapefile of the study area
#' @param CTs Coordinates XY of camera traps
#' @param colors Define the colors pallete
#' @param SaveFolder Directory to save plot
#'
#' @return plot of camera traps in the study area
#'
#' @importFrom terra north sbar
#' @importFrom grDevices dev.copy dev.off jpeg
#' @importFrom graphics points
#'
#' @examples
#' \dontrun{
#' MapCT(map = mapProje, CTs = habitat.data, colors = my_colors, SaveFolder = "Results")
#' }
#' @export
#'
MapCT <- function(map, CTs, colors, SaveFolder) {
  terra::plot(map, col = colors, fill = T, lty = 0)
  terra::points(CTs$X, CTs$Y, pch = 16, cex = 1.5, col = "black")
  terra::north()
  terra::sbar(2000, xy = "bottomright", divs = 2, cex = 0.7, ticks = TRUE, type = "bar", below = "meters")

  dev.copy(jpeg, filename = file.path(SaveFolder, "MapCTs.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
  dev.off()
} # end function
