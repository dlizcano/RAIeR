#' Function RAI_LYS
#'
#' @description To comparison RAI between locations, years and seasons
#' @author "SMandujanoR"
#'
#' @param species Select the species
#' @param SaveFolder Directory to save results
#'
#' @importFrom ggplot2 aes facet_grid theme_bw theme stat_summary labs mean_cl_normal
#'
#' @return Graph RAI by location, year and season
#'
#' @examples
#' \dontrun{
#' RAI_LYS(species = "Pec_taj", SaveFolder = "Pecari")
#' }
#'
#' @export
#'
RAI_LYS <- function(species, SaveFolder) {
  # Read data:
  new.mat <- read.csv(file.path(SaveFolder, "/Data.csv"), header = T)

  RAI <- new.mat$RAI
  Location <- new.mat$Location

  # Plot:
  mygraf <- ggplot2::ggplot(new.mat, aes(x = factor(Location), y = RAI, fill = factor(Location), col = Location)) +
    ggplot2::stat_summary(fun = mean, geom = "point", size = 4) +
    ggplot2::stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0, size = 1) +
    ggplot2::labs(x = "Locations", y = "RAI", title = "", caption = "") +
    ggplot2::facet_grid(Year ~ Season, scales = "free_y") +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "none")

  jpeg(filename = file.path(SaveFolder, "/RAI_LocYS.jpg", sep = ""), width = 8000, height = 7000, units = "px", res = 1200)
  print(mygraf)
  dev.off()

  return(mygraf)
} # end function
