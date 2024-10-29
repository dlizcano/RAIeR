#' @title Plot eR for species in different locations and years
#'
#' @description Function to graph the eR for species in different locations and years
#' @author "A. Zavaleta & SMandujanoR"
#'
#' @param df Data of species
#' @param Factor Factor. Select Location, Year or Season
#' @param Name Name of Location, Year or Season
#' @param bubSize Size of the circles
#' @param fontSize Size of the fonts
#' @param SaveFolder Directory to save plot
#'
#' @importFrom stringr str_to_title
#' @importFrom ggplot2 ggplot aes_string geom_point scale_size_area scale_x_discrete theme_classic theme element_blank element_line element_text unit
#'
#' @return Graphs of eR for species in different locations and years

#' @examples
#' \dontrun{
#' eR_LYS(
#'   df = datos,
#'   Factor = datos$Location,
#'   Name = "Location",
#'   bubSize = 15,
#'   fontSize = 12,
#'   SaveFolder = "Results"
#' )
#'
#' eR_LYS(
#'   df = datos,
#'   Factor = datos$Year,
#'   Name = "Year",
#'   bubSize = 15,
#'   fontSize = 12,
#'   SaveFolder = "Results"
#' )
#'
#' eR_LYS(
#'   df = datos,
#'   Factor = datos$Season,
#'   Name = "Season",
#'   bubSize = 15,
#'   fontSize = 12,
#'   SaveFolder = "Results"
#' )
#' }
#'
#' @export
#'
eR_LYS <- function(df, Factor, Name, bubSize, fontSize, SaveFolder) {
  new.mat <- read.csv(file.path(SaveFolder, "/Table_eR_CTs.csv"), header = T)
  Species <- new.mat$Species
  eRalt <- new.mat$eRalt

  myplot <- ggplot2::ggplot(new.mat, ggplot2::aes(x = factor(Factor), y = Species, color = Factor, size = eRalt)) +
    ggplot2::geom_point(shape = 19, ggplot2::aes(size = eRalt)) +
    ggplot2::scale_size_area(max_size = bubSize) +
    ggplot2::scale_x_discrete(name = Name) +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::theme(axis.text = ggplot2::element_text(size = fontSize)) +
    ggplot2::theme(axis.title.y = ggplot2::element_blank()) +
    ggplot2::theme(axis.ticks = ggplot2::element_line(size = 0.7, color = "black"), axis.ticks.length = ggplot2::unit(.3, "cm"))

  jpeg(filename = file.path(SaveFolder, paste("/Spp_eR_", stringr::str_to_title(Name), ".jpg", sep = "")), width = 8000, height = 7000, units = "px", res = 1200)
  print(myplot)
  dev.off()

  return(myplot)
} # end function
