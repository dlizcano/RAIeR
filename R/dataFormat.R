#' @title Function `dataFormat`
#'
#' @description Function to format the previous file data/Location_lys.csv as required in this package
#' @author "Eva López-Tello and SMandujanoR"
#'
#' @param Location Select study or sampling location
#' @param data_Spp Data of species
#' @param data_CT Data of camera traps
#' @param Problem Logical. If DataOriginal...
#'
#' @importFrom fuzzySim spCodes
#' @importFrom dplyr rename
#' @importFrom stringr str_to_title
#' @importFrom camtrapR surveyReport
#'
#' @return Save a reformated data.frame grouping all data
#'
#' @examples
#' \dontrun{
#' data_Spp <- read.csv("data/CB_Lys.csv", header = T)
#' data_Spp <- data_Spp[, -1]
#'
#' CTs <- read.csv("data/CT_Operativity.csv", header = T)
#'
#' dataFormat(Location = "CB", data_Spp = data_Spp, data_CT = CTs, Problem = T)
#' }
#'
#' @export
#'
dataFormat <- function(Location, data_Spp, data_CT, Problem) {
  # Modified parameters:
  report <- camtrapR::surveyReport(recordTable = data_Spp, CTtable = data_CT, speciesCol = "Species", stationCol = "Station", setupCol = "Fecha_colocacion", retrievalCol = "Fecha_retiro", CTDateFormat = "%d/%m/%Y", recordDateTimeCol = "DateTimeOriginal", recordDateTimeFormat = "%Y-%m-%d %H:%M:%S", CTHasProblems = Problem)

  sampling_effort <- report[[1]]
  days <- sampling_effort[c("Station", "n_nights_active")]
  species <- report[[5]]

  # Merge data.frame:
  wildlife.data <- merge(species, days, all.y = T)

  # Rename columns:
  # wildlife.data <- wildlife.data %>%
  # dplyr::rename(Camera= Station, Events= n_events, Effort= n_nights_active)

  names(wildlife.data)[names(wildlife.data) == "Station"] <- "Camera"
  names(wildlife.data)[names(wildlife.data) == "n_events"] <- "Events"
  names(wildlife.data)[names(wildlife.data) == "n_nights_active"] <- "Effort"

  # Species names abbreviation:
  wildlife.data$Species <- fuzzySim::spCodes(wildlife.data$Species, sep.spcode = "_")

  # Save the formated data:
  write.csv(wildlife.data, paste("data/wildlife.data1_", stringr::str_to_title(Location), ".csv", sep = ""))

  return(wildlife.data)
} # end function
