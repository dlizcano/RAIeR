#' @title Function `RAI_CTs`
#'
#' @description Function to calculate the RAI in each camera trap
#' @author "SMandujanoR"
#'
#' @param species Select the species
#' @param df Data.frame with data of animals and camera traps
#' @param SaveFolder Directory to save results
#'
#' @importFrom stringr str_to_title
#'
#' @return RAI for each camera trap
#'
#' @examples
#' \dontrun{
#' RAI_CTs(species = "Pec_taj", df = datos, SaveFolder = "Pecari")
#' }
#'
#' @export
#'
RAI_CTs <- function(species, df, SaveFolder) {
  # Read data:
  new.mat <- df[df$Species == species, ]
  RAI <- with(new.mat, round((Events / Effort) * 100, 2))
  Data <- cbind(new.mat, RAI)
  View(Data)
  write.csv(Data, paste(stringr::str_to_title(SaveFolder), "/Data.csv", sep = ""))

  return(Data)
} # end function
