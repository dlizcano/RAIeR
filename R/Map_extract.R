#' @title Function `Map_extract`
#'
#' @description Function to extract information of each camera traps of the raster layer of the study area
#' @author "SMandujanoR"
#'
#' @param map Shapefile of the study area
#' @param CTs Coordinates XY of camera traps
#' @param SaveFolder Directory to save plot
#'
#' @return a data.frame with new column named Habt_types
#'
#' @importFrom terra extract
#' @importFrom stringr str_to_title
#'
#' @examples
#' \dontrun{
#' Map_extract(map = mapProje, CTs = habitat.data, SaveFolder = "Results")
#' }
#'
#' @export
#'
Map_extract <- function(map, CTs, SaveFolder) {
  CTs_coord <- data.frame(X = CTs$X, Y = CTs$Y)
  print(CTs_coord)
  Habt_types <- terra::extract(map, CTs_coord, byid = T)
  print(Habt_types)
  Data <- data.frame(CTs, Habt_types = Habt_types[, 2])
  write.csv(Data, paste(stringr::str_to_title(SaveFolder), "/Data.csv", sep = ""))

  return(Data)
} # end function
