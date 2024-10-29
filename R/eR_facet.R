#' @title Facet graph eR by species by years and sesons
#'
#' @description Function to facet graph eR by species by years and sesons
#' @author "SMandujanoR"
#'
#' @param df Data of species
#' @param bubSize Size of the circles
#' @param fontSize Size of the fonts
#' @param SaveFolder Directory to save plot
#'
#' @importFrom ggplot2 ggplot aes_string geom_point scale_size_area theme_bw theme element_blank element_line element_text unit facet_grid aes label_both
#'
#' @return Facet graph eR by species by years and sesons
#'
#' @examples
#' \dontrun{
#' eR_facet(df = datos, bubSize = 7, fontSize = 6, SaveFolder = "Results")
#' }
#'
#' @export
#'
eR_facet <- function(df, bubSize, fontSize, SaveFolder) {
  new.mat <- read.csv(file.path(SaveFolder, "/Table_eR_CTs.csv"), header = T)
  Veg_type <- new.mat$Veg_type
  Species <- new.mat$Species
  eRalt <- new.mat$eRalt
  Year <- new.mat$Year
  Season <- new.mat$Season

  myplot <- ggplot2::ggplot(new.mat, ggplot2::aes(x = Veg_type, y = Species, size = eRalt, color = factor(Year))) +
    ggplot2::geom_point(shape = 19) +
    ggplot2::scale_size_area(max_size = bubSize) +
    ggplot2::theme_bw() +
    ggplot2::theme(strip.text = element_text(size = 10, color = "black")) +
    theme(panel.spacing = unit(1, "lines")) +
    theme(legend.position = "none") +
    theme(axis.text = element_text(size = fontSize)) +
    theme(axis.title.y = element_blank()) +
    theme(axis.ticks = element_line(size = 0.7, color = "black"), axis.ticks.length = unit(.1, "cm")) +
    ggplot2::facet_grid(Year ~ Season, labeller = ggplot2::label_both)

  jpeg(filename = file.path(SaveFolder, "/eR_facet.jpg", sep = ""), width = 8000, height = 7000, units = "px", res = 1200)
  print(myplot)
  dev.off()

  return(myplot)
} # end function
