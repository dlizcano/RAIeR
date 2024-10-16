
#' @title Function `MapKernelSp`
#'
#' @description To create kernel utilization distribution for selected species by season and total (year+season)
#' @author "SMandujanoR"
#'
#' @param Location Name location or study area
#' @param species Select the species
#' @param Season Define the season
#' @param map shapefile of the study area
#' @param Proje Define the projection
#' @param my_colors Name of your own palete colors
#' @param S.extent Extent
#' @param UD95 Utilization distribution ("Home range")
#' @param UD50 Utilization distribution ("Core area")
#' @param pointSize Define the size of the circles
#' @param SaveFolder Directory to save results
#'
#' @importFrom grDevices terrain.colors rgb
#' @importFrom graphics lines points
#' @importFrom adehabitatHR kernelUD getverticeshr
#' @importFrom sp proj4string SpatialPoints
#' @importFrom dplyr filter select
#' @importFrom terra vect rast writeRaster rasterize ext crs north sbar plot points lines
#' @importFrom stringr str_to_title
#'
#' @return Estimation, maps and raster of UDs
#'
#' @examples
#' \dontrun{
#' Season 1:
#' MapKernelSp(Location =  "Cb",
#'             species = "Odo_vir",
#'             Season = 1,
#'             map = mapProje,
#'             Proje = proje1,
#'             my_colors = my_colors,
#'             S.extent = 1,
#'             UD95 = 95,
#'             UD50 = 50,
#'             pointSize = 0.3,
#'             SaveFolder = "Venado")
#'
# Season 2:
#' MapKernelSp(Location =  "Cb",
#'             species = "Odo_vir",
#'             Season = 2,
#'             map = mapProje,
#'             Proje = proje1,
#'             my_colors = my_colors,
#'             S.extent = 1,
#'             UD95 = 95,
#'             UD50 = 50,
#'             pointSize = 0.3,
#'             SaveFolder = "Venado")
#' }
#' @export
#'
MapKernelSp <- function(Location, species, Season, map, Proje, my_colors, S.extent, UD95, UD50, pointSize, SaveFolder) {

  # Read RAIeR table:
  new.matTOT <- read.csv(file.path(SaveFolder,"/Data.csv"), header = T)
  new.mat <- new.matTOT[new.matTOT$Season== Season,]
  new.mat <- new.mat[,-1]
  Events <- new.mat$Events
  sp <- dplyr::select(new.mat, c("X", "Y", "Events"))
  sp <- dplyr::filter(sp, Events > 0)

  # Preparation of data:
  n <- length(sp$Events)
  nueva_mat <- vector("numeric", n)
  repetir <- function(i) {
    do.call("rbind", replicate(sp$Events[i], sp[i,], simplify = F))
  }

  for (i in 1:n) {
    nuevo <- repetir(i)
    nueva_mat <- rbind(nueva_mat, nuevo)
  }

  nueva_mat
  species_coord <- nueva_mat[-1,-3]
  print(species_coord)
  presenciaSP <- sp::SpatialPoints(coords = species_coord)
  ###sp::proj4string(presenciaSP) <- "+proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
  presenciaSP2 <- terra::vect(presenciaSP, Proje)

  # Kernel analysis using adehabitatHR package:
  S <- S.extent
  UD95 <- UD95
  UD50 <- UD50

  speciesUD <- adehabitatHR::kernelUD(presenciaSP, h = "href", kern = "bivnorm", grid = 95, hlim = c(0.75, 0.75), extent = S)
  print(speciesUD)
  speciesUD95 <- adehabitatHR::getverticeshr(speciesUD, percent = UD95)
  print(speciesUD95)
  speciesUD50 <- adehabitatHR::getverticeshr(speciesUD, percent = UD50)
  print(speciesUD50)

  # Create a Raster layer:
  r <- terra::rast(nrow = 30, ncol = 30, extent = ext(map))
  terra::crs(r) <- Proje
  vals <- speciesUD@data
  vals <- as.numeric(unlist(vals))
  kernel_rast <- terra::rasterize(cbind(speciesUD@coords), r, vals)
  terra::writeRaster(kernel_rast, file.path(SaveFolder, paste("/KernelRaster_", stringr::str_to_title(species), "_S", stringr::str_to_title(Season), ".tiff", sep = "")), overwrite = T)

  # Plot:
  miplot <- terra::plot(kernel_rast, col = terrain.colors(99, rev = T), legend = F, main = paste(species, "Season_", Season))
  terra::lines(map, alpha = 0.1)
  terra::points(new.mat$X, new.mat$Y, pch = 21, col = "black", cex = 1)
  terra::points(sp$X, sp$Y, pch = 16, col = rgb(1, 0, 0, 0.75), cex = sp$Events*pointSize)
  terra::plot(speciesUD95, add = T)
  terra::plot(speciesUD50, add = T, lty = 2)
  terra::north()
  terra::sbar(2000, xy = "bottomright", divs = 2, cex = 0.7, ticks = TRUE, type = "bar", below = "meters")

  dev.copy(jpeg, filename = file.path(SaveFolder, paste("/KernelRaster_", stringr::str_to_title(species), "_S", stringr::str_to_title(Season), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot)
  dev.off()

  #######################
  # Kernel total (años + seasons)

  sp <- dplyr::select(new.matTOT, c("X", "Y", "Events"))
  sp <- dplyr::filter(sp, Events > 0)

  # Preparation of data:
  n <- length(sp$Events)
  nueva_mat <- vector("numeric", n)
  repetir <- function(i) {
    do.call("rbind", replicate(sp$Events[i], sp[i,], simplify = F))
  }

  for (i in 1:n) {
    nuevo <- repetir(i)
    nueva_mat <- rbind(nueva_mat, nuevo)
  }

  nueva_mat
  species_coord <- nueva_mat[-1,-3]
  print(species_coord)
  presenciaSP <- sp::SpatialPoints(coords = species_coord)
  ###sp::proj4string(presenciaSP) <- "+proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
  presenciaSP2 <- terra::vect(presenciaSP, Proje)

  # Kernel analysis using adehabitatHR package:
  S <- S.extent
  UD95 <- UD95
  UD50 <- UD50

  speciesUD <- adehabitatHR::kernelUD(presenciaSP, h = "href", kern = "bivnorm", grid = 95, hlim = c(0.75, 0.75), extent = S)
  print(speciesUD)
  speciesUD95 <- adehabitatHR::getverticeshr(speciesUD, percent = UD95)
  print(speciesUD95)
  speciesUD50 <- adehabitatHR::getverticeshr(speciesUD, percent = UD50)
  print(speciesUD50)

  # Create a Raster layer:
  r <- terra::rast(nrow = 30, ncol = 30, extent = ext(map))
  terra::crs(r) <- Proje
  vals <- speciesUD@data
  vals <- as.numeric(unlist(vals))
  kernel_rast <- terra::rasterize(cbind(speciesUD@coords), r, vals)
  terra::writeRaster(kernel_rast, file.path(SaveFolder, "/KernelRaster_Total.tiff"), overwrite = T)

  # Plot:
  miplot2 <- terra::plot(kernel_rast, col = terrain.colors(99, rev = T), legend = F, main = paste(species, "Total"))
  terra::lines(map, alpha = 0.1)
  terra::points(new.mat$X, new.mat$Y, pch = 21, col = "black", cex = 1)
  terra::points(sp$X, sp$Y, pch = 16, col = rgb(1, 0, 0, 0.75), cex = sp$Events*pointSize)
  terra::plot(speciesUD95, add = T)
  terra::plot(speciesUD50, add = T, lty = 2)
  terra::north()
  terra::sbar(2000, xy = "bottomright", divs = 2, cex = 0.7, ticks = TRUE, type = "bar", below = "meters")

  dev.copy(jpeg, filename = file.path(SaveFolder, "/KernelRaster_Total.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
  dev.off()

  return(list(miplot, miplot2))

} # end function
