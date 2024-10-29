#' Create a map of the RAI selected category
#'
#' @description To create a map of the RAI selected category as sex, age, other
#' @author "SMandujanoR"
#'
#' @param Catg Factor. Define the category to map RAI
#' @param map shapefile of the study area
#' @param pointSize Define the size of the circles
#' @param colors Name of your own palete colors
#' @param SaveFolder Directory to save results
#'
#' @importFrom terra plot points north sbar
#' @importFrom stringr str_to_title
#'
#' @return Map plot of RAI of selected category as sex, age, other
#'
#' @examples
#' \dontrun{
#' MapSexRAI(
#'   Sex = "Female",
#'   map = mapProje,
#'   pointSize = 0.05,
#'   colors = my_colors,
#'   SaveFolder = "Cb"
#' )
#' }
#'
#' @export
#'
MapCatgRAI <- function(Catg, map, pointSize, colors, SaveFolder) {
  # Read data:
  new.mat <- read.csv(file.path(SaveFolder, "Data.csv"), header = T)
  new.mat <- new.mat[new.mat$Catg == Catg, ]
  new.mat <- new.mat[, -1]

  # Plot:
  miplot <- terra::plot(map, col = colors, fill = T, lty = 0, main = Catg)
  terra::points(new.mat$X, new.mat$Y, pch = 16, col = "#00000170", cex = new.mat$RAI * pointSize)
  terra::north()
  terra::sbar(2000, xy = "bottomright", divs = 2, cex = 0.7, ticks = TRUE, type = "bar", below = "meters")

  jpeg(filename = file.path(SaveFolder, paste("/MapRAI_", stringr::str_to_title(Catg), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot)
  dev.off()

  return(miplot)
} # end function
