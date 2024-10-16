#' Function `RAI_Habitat`
#'
#' @description To comparison RAI by habitat type during each year and season, in a selected location
#' @author "SMandujanoR"
#'
#' @param Location Name location or study area
#' @param species Select the species
#' @param Types Names. Vegetation or habitat types
#' @param my_colors Name of palette colors
#' @param SaveFolder Directory to save results
#'
#' @importFrom stats lm
#' @importFrom ggplot2 aes labs theme_bw theme facet_grid element_text scale_fill_manual geom_boxplot label_both
#' @importFrom xtable xtable
#' @importFrom stringr str_to_title
#'
#' @return Linear model and facet plot
#'
#' @examples
#' \dontrun{
#' RAI_Habitat(
#'   Location = "Cb",
#'   species = "Odo_vir",
#'   Types = c(
#'     "Agriculture", "River", "TDF Neo",
#'     "TDF Mim", "Saltworks", "Scrub-cras"
#'   ),
#'   my_colors = my_colors,
#'   SaveFolder = "Venado"
#' )
#' }
#'
#' @export
#'
RAI_Habitat <- function(Location, species, Types, my_colors, SaveFolder) {
  # Read data:
  new.mat <- read.csv(file.path(SaveFolder, "/Data.csv"), header = T)
  # new.mat  <- subset(new.mat, Location == Location & Species == species)

  Habt_types <- new.mat$Veg_type
  RAI <- new.mat$RAI

  # LM:
  Vegt <- stats::lm(RAI ~ Veg_type - 1, data = new.mat)
  print(summary(Vegt))
  test <- xtable::xtable(summary(Vegt))
  View(test)
  write.csv(test, paste(stringr::str_to_title(SaveFolder), "/Test-Vegt.csv", sep = ""))
  ## jpeg(filename = file.path(SaveFolder, paste("/Vegt_", str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  ## plot(RAI ~ Veg_type, data = new.mat)
  ## dev.off()

  Vegt.Year <- stats::lm(RAI ~ Veg_type - 1 + Year, data = new.mat)
  print(summary(Vegt.Year))
  test <- xtable::xtable(summary(Vegt.Year))
  View(test)
  write.csv(test, paste(stringr::str_to_title(SaveFolder), "/Test-VegtYear.csv", sep = ""))

  # Facet plot:
  mygraf <- ggplot2::ggplot(new.mat, aes(x = factor(Habt_types), y = RAI, fill = factor(Habt_types))) +
    ggplot2::geom_boxplot() +
    ggplot2::labs(x = "Habitat types", y = "RAI", title = species, caption = "") +
    ggplot2::scale_fill_manual(name = "Vegetation types", labels = Types, values = my_colors) +
    theme_bw() +
    theme(strip.text = element_text(size = 12, color = "black")) +
    theme(text = element_text(size = 8)) +
    theme(plot.title = element_text(color = "black", size = 14, face = "bold", hjust = 0.5)) +
    ggplot2::facet_grid(Year ~ Season, scales = "free_y", labeller = label_both)

  jpeg(filename = file.path(SaveFolder, paste("/Habitat_", stringr::str_to_title(species), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(mygraf)
  dev.off()

  return(list(test, mygraf))
} # end function
