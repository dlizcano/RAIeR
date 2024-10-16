
#' @title Function `date_LYS`
#'
#' @description Function to 1) format date as "Ymd HM" to "mdY HM", 2) create new columns (Location, Year, Season), and 3) save subsets of data.frames
#' @author "SMandujanoR and C. García-Vital"
#'
#' @param df_Spp Data of species
#' @param Location Select location
#' @param mdY Logical. Define TRUE/FALSE if the DateTimeOriginal column in the data.frame actually is mdY or not
#' @param Jan Factor. Define the season (1,2,3...) of this mounth
#' @param Feb Factor. Define the season (1,2,3...) of this mounth
#' @param Mar Factor. Define the season (1,2,3...) of this mounth
#' @param Apr Factor. Define the season (1,2,3...) of this mounth
#' @param May Factor. Define the season (1,2,3...) of this mounth
#' @param Jun Factor. Define the season (1,2,3...) of this mounth
#' @param Jul Factor. Define the season (1,2,3...) of this mounth
#' @param Aug Factor. Define the season (1,2,3...) of this mounth
#' @param Sep Factor. Define the season (1,2,3...) of this mounth
#' @param Oct Factor. Define the season (1,2,3...) of this mounth
#' @param Nov Factor. Define the season (1,2,3...) of this mounth
#' @param Dec Factor. Define the season (1,2,3...) of this mounth
#' @param Y.init First year
#' @param Y.end  Laste year
#' @param S.init First season
#' @param S.end Laste season
#'
#' @importFrom lubridate parse_date_time
#' @importFrom dplyr recode
#' @importFrom utils View write.csv
#'
#' @return This create new columns LYS, the subcarpet df and a new data.frame
#'
#' @examples
#' \dontrun{
#' data_Spp <- read.csv("data/CT_Spp.csv", header = T) # Read the original data
#' data_Spp <- data_Spp[,-1] # If necesesary delete this column
#' Example 1:
#' dateSubsets_LYS(df_Spp = data_Spp,
#'        Location = "CB",
#'        mdY = T,
#'        Jan="1",
#'        Feb="1",
#'        Mar="1",
#'        Apr="1",
#'        May="1",
#'        Jun="2",
#'        Jul="2",
#'        Aug="2",
#'        Sep="2",
#'        Oct="2",
#'        Nov="2",
#'        Dec="1",
#'        Y.init = 2012,
#'        Y.end = 2013,
#'        S.init = 1,
#'        S.end = 2)
#' Example 2: is not necesary modify mdY
#' dateSubsets_LYS(df_Spp = table2, Location = "CBlanca", mdY = F,
#' Jan="1", Feb="1", ...
#' Y.init = 2012, Y.end = 2013,
#' S.init = 1, S.end = 2)
#' }
#'
#' @export
#'
date_LYS <- function(df_Spp, Location, mdY, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec, Y.init, Y.end, S.init, S.end) {

  # Create new folder to save data.frames
  dir.create("data/df")

  if(mdY==T) {

    # Format DateTimeOriginal:
    original <- df_Spp
    datetimeOriginal <- df_Spp$DateTimeOriginal
    df_Spp$DateTimeNew <- lubridate::parse_date_time(datetimeOriginal, c("%Y-%m-%d %H:%M:%S", "%m-%d-%y %H:%M:%S"))
    df_Spp$DateNew <- lubridate::parse_date_time(df_Spp$Date, c("Ymd", "mdY"))
    colnames(df_Spp)[3] <- "Old_DateTimeOriginal"
    colnames(df_Spp)[length(original)+1] <- "DateTimeOriginal"
    colnames(df_Spp)[4] <- "Old_Date"
    colnames(df_Spp)[length(original)+2] <- "Date"

    # Create new columns: Location, Year, Season:
    datetxt <- as.Date(df_Spp$Date, tz = "UTC", "%m/%d/%Y")
    df <- data.frame(Year = as.numeric(format(datetxt, format = "%Y")), month = as.numeric(format(datetxt, format = "%m")))
    df_Spp2 <- cbind(df_Spp, df)
    df_Spp2$Season <- dplyr::recode((df_Spp2$month), "1"=Jan, "2"=Feb, "3"=Mar, "4"=Apr, "5"=May, "6"=Jun, "7"=Jul, "8"=Aug, "9"=Sep, "10"=Oct, "11"=Nov, "12"=Dec)
    df_Spp2$Location <- Location
    write.csv(df_Spp2, paste("data/", stringr::str_to_title(Location), "_", stringr::str_to_title("LYS"), ".csv", sep = ""))

    # Create data.frames subsets by Year and Season:
    for (i in Y.init:Y.end) {
      for (j in S.init:S.end) {
        data_Spp1 <- subset(df_Spp2, df_Spp2$Year == i & df_Spp2$Season == j)
        write.csv(data_Spp1, paste("data/df/", stringr::str_to_title(Location), "_", stringr::str_to_title(i), "_", stringr::str_to_title(j), ".csv", sep = ""))
      } # j
    } # i

  } else { # if(mdY == F)

    # Create new columns: Location, Year, Season:
    datetxt2 <- as.Date(df_Spp$Date, tz = "UTC", "%Y-%m-%d")
    df_new <- data.frame(Year = as.numeric(format(datetxt2, format = "%Y")), month = as.numeric(format(datetxt2, format = "%m")))
    df_Spp3 <- cbind(df_Spp, df_new)
    df_Spp3$Season <- dplyr::recode((df_Spp3$month), "1"=Jan, "2"=Feb, "3"=Mar, "4"=Apr, "5"=May, "6"=Jun, "7"=Jul, "8"=Aug, "9"=Sep, "10"=Oct, "11"=Nov, "12"=Dec)
    df_Spp3$Location <- Location
    write.csv(df_Spp3, paste("data/", stringr::str_to_title(Location), "_", stringr::str_to_title("Spp_LYS"), ".csv", sep = ""))

    # Create data.frames subsets by Year and Season:
    for (i in Y.init:Y.end) {
      for (j in S.init:S.end) {
        data_Spp1 <- subset(df_Spp3, df_Spp3$Year == i & df_Spp3$Season == j)
       write.csv(data_Spp1, paste("data/df/", stringr::str_to_title(Location), "_", stringr::str_to_title(i), "_", stringr::str_to_title(j), ".csv", sep = ""))
      } # j
    } # i
  } # ifelse

  return(list(df_Spp2, df_Spp3))

} # end function
