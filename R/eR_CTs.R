#' @title Estimate eRs per camera and species
#'
#' @description Function to estimate eRs per camera and species, and create plots
#' @author "SMandujanoR"
#'
#' @param new.mat Data of species
#' @param Ymax Define maxime value of Y-axis
#' @param SaveFolder Directory to save plot
#'
#' @importFrom stringr str_to_title
#' @importFrom gplots plotmeans
#' @importFrom grDevices topo.colors
#' @importFrom graphics boxplot contour image
#' @importFrom akima interp
#'
#' @return Table with eRs for species in each camera, and plots
#'
#' @examples
#' \dontrun{
#' eR_CTs(datos, Ymax = 15, SaveFolder = "Results")
#' }
#'
#' @export
#'
eR_CTs <- function(new.mat, Ymax, SaveFolder) {
  # Estimation eRs per camera and species:
  eRalt <- with(new.mat, round((Events / Effort) * 100, 2))
  table2 <- cbind(new.mat, eRalt)
  write.csv(table2, paste(stringr::str_to_title(SaveFolder), "/Table_eR_CTs.csv", sep = ""))

  # Boxplot graph:
  miPlot_1 <- boxplot(eRalt ~ Species, data = new.mat, ylab = "Encounter rate", ylim = c(0, Ymax), xlab = "", varwidth = F, outline = F, cex = 3.4, las = 2, frame.plot = F, cex.axis = 0.7, col = "skyblue")

  dev.copy(jpeg, filename = file.path(SaveFolder, "eR_CTs.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
  dev.off()

  # ------
  # plotmens graph
  miPlot_2 <- gplots::plotmeans(eRalt ~ Species, data = new.mat, ylab = "Encounter rate", pch = 16, cex = 2, las = 2, barwidth = 2.5, frame.plot = F, cex.axis = 1, n.label = F, connect = F, cex.lab = 1.5, col = "skyblue", barcol = "skyblue", main = "", xlab = "")

  dev.copy(jpeg, filename = file.path(SaveFolder, "eR_CTs2.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
  dev.off()

  # interpolation:
  eR_mean <- with(table2, round(tapply(eRalt, Species, mean), 2))
  eR_sd <- with(table2, round(tapply(eRalt, Species, sd), 2))
  occ <- subset(table2, table2$Events > 0)
  cameras <- with(new.mat, tapply(Camera, Species, length))
  n <- with(new.mat, tapply(Events, Species, sum))
  OccNaive <- round(table(occ$Species) / cameras, 2)
  g <- akima::interp(eR_mean, OccNaive, n, duplicate = T)

  miPlot_3 <- image(g, col = topo.colors(12), cex.lab = 1.0, frame = F, xlab = "Encounter rate", ylab = "Naive occupation", xlim = c(0, max(eR_mean + 2)), ylim = c(0, 1.1))
  contour(g, add = T)
  text(eR_mean, jitter(OccNaive, 3), labels = unique(sort(table2$Species)), cex = 1, pos = 4, col = "red")

  dev.copy(jpeg, filename = file.path(SaveFolder, "eR_NaiveOcc.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
  dev.off()

  return(list(table2, miPlot_1, miPlot_2, miPlot_3))
} # end function
