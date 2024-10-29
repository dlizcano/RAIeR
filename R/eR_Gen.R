#' @title Estimate of encounter rate (eR), naive occupation, and events percent for each species
#'
#' @description Function to estimate of encounter rate (eR), naive occupation, and events percent for each species, and create plots
#' @author "SMandujanoR"
#'
#' @param new.mat Data of species
#' @param SaveFolder Directory to save plot
#'
#' @importFrom stringr str_to_title
#' @importFrom graphics abline
#' @importFrom stats cor lm

#' @return Table with estimates of encounter rate (eR), naive occupation, and events percent for each species, and plot
#'
#' @examples
#' \dontrun{
#' eR_Gen(new.mat = datos, SaveFolder = "Results")
#' }
#'
#' @export
#'
eR_Gen <- function(new.mat, SaveFolder) {
  # eR estimation:
  cameras <- with(new.mat, tapply(Camera, Species, length))
  days <- with(new.mat, tapply(Effort, Species, sum))
  n <- with(new.mat, tapply(Events, Species, sum))
  eR_gen <- round(n / days * 100, 2)

  # Naive occupation:
  occ <- subset(new.mat, new.mat$Events > 0)
  OccNaive <- as.data.frame(round(table(occ$Species) / cameras, 2))

  # Relative percent (RAIeR_pct):
  eR_pct <- with(new.mat, round(n / sum(Events) * 100, 2))

  # Results:
  table1 <- cbind(cameras, days, n, eR_gen, eR_pct, OccNaive = OccNaive[, 2])
  table1 <- table1[order(eR_gen), ]
  View(table1)
  write.csv(table1, paste(stringr::str_to_title(SaveFolder), "/Table_eR_Gen.csv", sep = ""))

  # RAIeR-naive occupation graph:
  r2 <- round(cor(eR_gen, OccNaive[, 2]), 2)
  miPlot <- plot(OccNaive[, 2], eR_gen, xlab = "Distribution naive", ylab = "Encounter rate", main = "", frame.plot = F, las = 1, pch = 16, col = "skyblue", cex = 2)
  abline(lm(eR_gen ~ OccNaive[, 2]), col = "red", lwd = 2)
  text(OccNaive[, 2], eR_gen, OccNaive[, 1], cex = 0.5)
  text(0.75, 1, paste("r2 =", r2), cex = 1)

  dev.copy(jpeg, filename = file.path(SaveFolder, "Occ_eR.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
  dev.off()

  return(list(miPlot, table1))
} # end function
