#' @title Plot XY of events
#'
#' @description Function to plot XY of events in camera traps for the selected species
#' @author "SMandujanoR"
#'
#' @param new.mat Data of species
#' @param especie Select the species to plot
#' @param parRow Number of rows
#' @param parCol Number of colummns
#' @param pointSize Size of the circles
#' @param labels Axes legends
#' @param SaveFolder Directory to save plot
#'
#' @return Plot XY of events in camera traps for the selected species
#'
#' @examples
#' \dontrun{
#' MapEventsSpp(
#'   df = datos,
#'   Species = c("Syl_flo", "Odo_vir", "Can_lat", "Uro_cin"),
#'   parRow = 2,
#'   parCol = 2,
#'   pointSize = 0.5,
#'   labels = T,
#'   SaveFolder = "Results"
#' )
#' }
#'
#' @export
#'
MapEventsSpp <- function(new.mat, especie, parRow, parCol, pointSize, labels, SaveFolder) {
  par(mfcol = c(parRow, parCol), mar = c(5, 5, 2, 2))

  for (i in 1:length(especie)) {
    sp <- subset(new.mat, new.mat$Species == especie[i])

    miPlot <- plot(sp$X, sp$Y, xlab = "", ylab = "", frame.plot = F, cex.axis = 1, main = unique(sp$Species), type = "n", labels = labels, cex.main = 0.9)
    points(sp$X, sp$Y, pch = 16, col = "skyblue", cex = sp$Events * pointSize)
    text(sp$X, sp$Y, sp$Events, cex = 0.7)
  }

  dev.copy(jpeg, filename = file.path(SaveFolder, "Event_CT.jpg"), width = 10000, height = 7000, units = "px", res = 1200)
  dev.off()

  return(miPlot)
} # end function
