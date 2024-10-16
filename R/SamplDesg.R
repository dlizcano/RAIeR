#' @title Function `SamplDesg`
#'
#' @description Function to create a camera grid for field sampling desings
#' @author "SMandujanoR"
#'
#' @param map Shapefile of the study area
#' @param Proje Projection 1 crs
#' @param n1 Number of camera traps in rows
#' @param n2 Number of camera traps in columns
#' @param CTx Initial X-UTM
#' @param CTy Initial Y-UTM
#' @param CTdist Distance (meters) between cameras
#' @param legend Position of legend
#' @param colors Define the color palette
#' @param SaveFolder Directory to save plot
#'
#' @importFrom terra north sbar vect xmin xmax ymin ymax
#' @importFrom stringr str_to_title
#' @importFrom graphics lines par text
#'
#' @return Map plot and XY coordinates of each camera trap in the grid
#'
#' @examples
#' \dontrun{
#' SamplDesg(
#'   map = mapProje,
#'   Proje = proje1,
#'   n1 = 5,
#'   n2 = 6,
#'   CTx = 691000,
#'   CTy = 2007500,
#'   CTdist = 1000,
#'   legend = "bottom",
#'   colors = my_colors,
#'   SaveFolder = "Results"
#' )
#' }
#'
#' @export
#'
SamplDesg <- function(map, Proje, n1, n2, CTx, CTy, CTdist, legend, colors, SaveFolder) {
  # To create grid:
  miPlot <- terra::plot(map, col = colors, fill = T, lty = 0)
  terra::north()
  terra::sbar(2000, xy = "bottomright", divs = 3, cex = 0.7, ticks = TRUE, type = "bar", below = "meters")

  # To create the grid:
  x <- seq(from = CTx, to = (CTx + n1 * CTdist - CTdist), by = CTdist)
  y <- seq(from = CTy, to = (CTy + n2 * CTdist - CTdist), by = CTdist)
  xy <- expand.grid(x = x, y = y)
  points(xy, col = "black", pch = 16, cex = 1.5)
  n <- as.character(1:(n1 * n2))
  text(xy, n, col = "white", cex = 0.5)
  write.csv(xy, paste(stringr::str_to_title(SaveFolder), "/UTMs_grid.csv", sep = ""))

  # To create buffer around the grid:
  xySP <- terra::vect(xy, geom = c("x", "y"), crs = Proje)
  xSP <- seq(from = terra::xmin(xySP) - CTdist, to = terra::xmax(xySP) + CTdist, by = n1 * CTdist + CTdist)
  ySP <- seq(from = terra::ymin(xySP) - CTdist, to = terra::ymax(xySP) + CTdist, by = n2 * CTdist + CTdist)
  xy2 <- expand.grid(x = xSP, y = ySP)
  points(xy2, col = "black", bg = "red", pch = 22, cex = 1)
  buf <- rbind(xy2[1, ], xy2[2, ], xy2[4, ], xy2[3, ], xy2[1, ])
  lines(buf, add = T, col = "red", lty = 1, lwd = 3)

  # To estimate area:
  cat("---------- \n Grid (ha) = \n ")
  print(S_grid1 <- (((n1 - 1) * CTdist) * ((n2 - 1) * CTdist)) / 10000)

  cat("------------- \n Grid + buffer (ha) = \n ")
  print(S_grid2 <- (((n1 + 1) * CTdist) * ((n2 + 1) * CTdist)) / 10000)

  legend(legend, c(paste("Grid of ", (n1 * n2), "camera-traps,", "at", CTdist, "meters,"), paste("Grid area = ", S_grid1, "hectares,"), paste("and grid + buffer =", S_grid2, "hectares (red quadrant).")), cex = 0.7)

  dev.copy(jpeg, filename = file.path(SaveFolder, "CT_SamplDesg.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
  dev.off()

  return(list(miPlot, xy))
} # end function
