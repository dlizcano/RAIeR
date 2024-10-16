#' @title Function `eR_resTab`
#'
#' @description Function to create a final table
#' @author "SMandujanoR"
#'
#' @param new.mat Data of species
#' @param SaveFolder Directory to save plot
#'
#' @importFrom stringr str_to_title
#'
#' @return Create Table of results
#'
#' @examples
#' \dontrun{
#' eR_resTab(datos, SaveFolder = "Results")
#' }
#' @export
#'
eR_resTab <- function(new.mat, SaveFolder) {
  # Read previously saved tables:
  t1 <- read.csv(file.path(SaveFolder, "Table_eR_Gen.csv"), header = T)
  t2 <- read.csv(file.path(SaveFolder, "Table_eR_CTs.csv"), header = T)
  t3 <- read.csv(file.path(SaveFolder, "Table_eR_GLM.csv"), header = T)

  # Mean and SD estimation:
  eR_ct.Mean <- with(t2, round(tapply(eRalt, Species, mean), 2))
  eR_ct.SD <- with(t2, round(tapply(eRalt, Species, sd), 2))
  alt <- cbind(eR_ct.Mean, eR_ct.SD)
  alt2 <- alt[order(eR_ct.Mean), ]

  # Create and save final table
  table3 <- with(c(t1, t3), cbind(cameras, days, n, eR_gen, alt2, eRmean, eRSD, eR_pct, OccNaive))
  # table3 <- table3[order(RAIeR_gen),]
  View(table3)
  write.csv(table3, paste(str_to_title(SaveFolder), "/Table_resTab.csv", sep = ""))
} # end function
