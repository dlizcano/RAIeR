#' Function `RAI_Loc`
#'
#' @description To calculate the RAI of the selected species by year, season and season/year, for each studied location
#' @author "SMandujanoR"
#'
#' @param Location Name location or study area
#' @param species Select the species
#' @param Ymax Define maxime Y-axes value
#' @param SaveFolder Directory to save results
#'
#' @importFrom grDevices dev.off jpeg
#' @importFrom stats aggregate
#' @importFrom gplots plotmeans
#' @importFrom stringr str_to_title
#'
#' @return graphs RAI per Year, Season and Year*Season
#'
#' @examples
#' \dontrun{
#' RAI_Loc(
#'   Location = "Cb",
#'   species = "Pec_taj",
#'   Ymax = 8,
#'   SaveFolder = "Pecari"
#' )
#' }
#'
#' @export
#'
RAI_Loc <- function(Location, species, Ymax, SaveFolder) {
  # Read data:
  new.mat <- read.csv(file.path(SaveFolder, "/Data.csv"), header = T)
  # new.mat2 <- new.mat[new.mat$Location== Location & new.mat$Species== species,]
  # View(new.mat2)
  # write.csv(new.mat2, file.path(SaveFolder, paste("/Data_", str_to_title(Location), ".csv", sep = "")))

  # Estimate mean and SD:
  mean <- aggregate(RAI ~ Year + Season, data = new.mat, FUN = "mean")
  sd <- aggregate(RAI ~ Year + Season, data = new.mat, FUN = "sd")
  est <- data.frame(Year = mean$Year, Season = mean$Season, RAImean = round(mean$RAI, 2), RAIsd = round(sd$RAI, 2))
  print(est)
  write.csv(est, file.path(SaveFolder, paste("/RAIs_", stringr::str_to_title(species), ".csv", sep = "")))

  # Graph Year:
  miplot1 <- gplots::plotmeans(RAI ~ Year, data = new.mat, ylab = "RAI", ylim = c(0, Ymax), xlab = "Year", pch = 16, cex = 2, las = 1, frame.plot = F, cex.axis = 1, n.label = T, connect = T, cex.lab = 1.5, col = "skyblue", barcol = "skyblue", main = paste(species))

  dev.copy(jpeg, filename = file.path(SaveFolder, paste("/RAI_Year_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot1)
  dev.off()

  # Graph Season:
  miplot2 <- gplots::plotmeans(RAI ~ Season, data = new.mat, ylab = "RAI", ylim = c(0, Ymax), xlab = "Season", pch = 16, cex = 2, las = 1, frame.plot = F, cex.axis = 1, n.label = T, connect = F, cex.lab = 1.5, col = "skyblue", barcol = "skyblue", main = paste(species))

  dev.copy(jpeg, filename = file.path(SaveFolder, paste("/RAI_Season_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot2)
  dev.off()

  # Graph Year*Season:
  miplot3 <- gplots::plotmeans(RAI ~ interaction(Year, Season, sep = " "), data = new.mat, ylim = c(0, Ymax), xlab = "Year-Season", pch = 16, cex = 2, las = 2, frame.plot = F, cex.axis = 0.5, n.label = F, connect = F, cex.lab = 1.5, col = "skyblue", barcol = "skyblue", main = paste(species))

  dev.copy(jpeg, filename = file.path(SaveFolder, paste("/RAI_YearSeason_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(miplot3)
  dev.off()

  return(list(miplot1, miplot2, miplot3))
} # end function
