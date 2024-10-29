#' @title Create tables of Species-eR, and Species-Events
#'
#' @description Function to create tables of Species-eR, and Species-Events
#' @author "SMandujanoR"
#'
#' @param SaveFolder Directory to save plot
#'
#' @importFrom dplyr select arrange %>%
#' @importFrom tidyr pivot_wider as_tibble
#' @importFrom stringr str_to_title
#'
#' @return Tables of Species-eR, and Species-Events
#'
#' @examples
#' \dontrun{
#' eR_matx(SaveFolder = "Results")
#' }
#' @export
#'
eR_matx <- function(SaveFolder) {
  table2 <- read.csv(file.path(SaveFolder, "/Table_eR_CTs.csv"), header = T)

  # ---
  # matrix eR per Species:
  ## SppeR <- table2 %>% dplyr::select(Camera, Species, eRalt)
  SppeR <- subset(table2, select = c("Camera", "Species", "eRalt"))
  SppeR <- tidyr::as_tibble(SppeR)
  SppeR <- dplyr::arrange(SppeR, SppeR$Species)
  Spp_eR <- tidyr::pivot_wider(SppeR, names_from = "Species", values_from = "eRalt")
  View(Spp_eR)
  write.csv(Spp_eR, paste(str_to_title(SaveFolder), "/Matrix_Spp-eR.csv", sep = ""))

  # ---
  # matrix Events per Species:
  ### SppEvents <- table2 %>% dplyr::select(Camera, Species, Events)
  SppEvents <- subset(table2, select = c("Camera", "Species", "Events"))
  SppEvents <- tidyr::as_tibble(SppEvents)
  SppEvents <- dplyr::arrange(SppEvents, SppEvents$Species)
  Spp_Event <- tidyr::pivot_wider(SppEvents, names_from = "Species", values_from = "Events")
  View(Spp_Event)
  write.csv(Spp_Event, paste(str_to_title(SaveFolder), "/Matrix_Spp-Events.csv", sep = ""))

  return(list(Spp_eR, Spp_Event))
} # end function
