#' @title Function `dataFormatDF`
#'
#' @description Function specific to format each data.frame of location, year and season.
#' @author "SMandujanoR"
#'
#' @param dframe Data of species
#' @param data_CT Data of camera traps
#' @param Problem Logical. Define possible problem in DataOriginal
#'
#' @importFrom readr read_csv
#' @importFrom fuzzySim spCodes
#' @importFrom dplyr rename bind_rows %>%
#' @importFrom stringr str_to_title
#' @importFrom stats na.omit
#' @importFrom utils read.csv
#'
#' @return Save a formated data.frame
#'
#' @examples
#' \dontrun{
#' dataFormatDF(dframe = "data/df/Cb_2012_1.csv", data_CT = CTs, Problem = T)
#' dataFormatDF(dframe = "data/df/Cb_2012_2.csv", data_CT = CTs, Problem = T)
#' dataFormatDF(dframe = "data/df/Cb_2013_1.csv", data_CT = CTs, Problem = T)
#' dataFormatDF(dframe = "data/df/Cb_2013_2.csv", data_CT = CTs, Problem = T)
#' }
#'
#' @export
#'
dataFormatDF <- function(dframe, data_CT, Problem) {
  # Create folder
  dir.create("data/df2")

  # Specific data.frame
  data_Spp <- read.csv(dframe, header = T)

  # Use the function surveyReport and modified the parameters setupCol and retrivelCol:
  report <- camtrapR::surveyReport(recordTable = data_Spp, CTtable = data_CT, speciesCol = "Species", stationCol = "Station", setupCol = "Fecha_colocacion", retrievalCol = "Fecha_retiro", CTDateFormat = "%d/%m/%Y", recordDateTimeCol = "DateTimeOriginal", recordDateTimeFormat = "%Y-%m-%d %H:%M:%S", CTHasProblems = Problem)

  sampling_effort <- report[[1]]
  days <- sampling_effort[c("Station", "n_nights_active")]
  species <- report[[5]]

  # Merge data.frame:
  wildlife.data <- merge(species, days, all.y = T)

  # Rename columns:
  # wildlife.data <- wildlife.data %>%
  # readr::rename(Camera= Station, Events= n_events, Effort= n_nights_active)

  names(wildlife.data)[names(wildlife.data) == "Station"] <- "Camera"
  names(wildlife.data)[names(wildlife.data) == "n_events"] <- "Events"
  names(wildlife.data)[names(wildlife.data) == "n_nights_active"] <- "Effort"

  # Species names abbreviation:
  wildlife.data$Species <- fuzzySim::spCodes(wildlife.data$Species, sep.spcode = "_")

  # New columns:
  wildlife.data$Location <- unique(data_Spp$Location)
  wildlife.data$Year <- unique(data_Spp$Year)
  wildlife.data$Season <- unique(data_Spp$Season)

  # Delete NAs:
  wildlife.data <- na.omit(wildlife.data)

  # Save the formated data:
  write.csv(wildlife.data, paste("data/df2/wildlife.data_", str_to_title(unique(data_Spp$Location)), "_", stringr::str_to_title(unique(data_Spp$Year)), "_", stringr::str_to_title(unique(data_Spp$Season)), ".csv", sep = ""))

  # Merge the files and create a new data.frame:
  wildlife.data2 <- list.files(path = "data/df2", pattern = "*.csv", full.names = TRUE) %>%
    lapply(read_csv) %>%
    dplyr::bind_rows()
  wildlife.data2 <- wildlife.data2[, -1]
  wildlife.data2 <- as.data.frame(wildlife.data2)
  write.csv(wildlife.data2, paste("data/wildlife.data2_", stringr::str_to_title(unique(data_Spp$Location)), ".csv", sep = ""))

  return(wildlife.data2)
} # end function
