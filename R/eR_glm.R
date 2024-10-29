#' @title Estimate eR according with a GLM
#'
#' @description Function to estimate eR according with a GLM
#' @author "SMandujanoR"
#'
#' @param new.mat Data of species
#' @param family Define "poisson", "quasipoisson"
#' @param SaveFolder Directory to save plot
#'
#' @importFrom stringr str_to_title
#' @importFrom xtable xtable
#' @importFrom stats glm
#'
#' @return Table with eR estimation follwing Poisson GLM
#'
#' @examples
#' \dontrun{
#' eR_glm(datos, family = "poisson", SaveFolder = "Results")
#' }
#' @export
#'
eR_glm <- function(new.mat, family, SaveFolder) {
  eRglm <- stats::glm(Events ~ Species - 1, data = new.mat, offset = log(new.mat$Effort), family = family)

  cat("----- \n GLM-Poisson: \n")
  print(summary(eRglm))
  modglm <- summary(eRglm)

  cat("----- \n Estimation per species: \n")
  eRPois <- cbind(eRmean = round(exp(eRglm$coefficients) * 100, 2), eRSD = round(exp(summary(eRglm)$coefficients[, 2]), 2))
  eRPois <- eRPois[order(eRPois[, 1]), ]

  table_glm <- xtable(modglm)
  mlg <- cbind(table_glm, eRPois)
  write.csv(mlg, paste(str_to_title(SaveFolder), "/Table_eR_GLM.csv", sep = ""))

  return(mlg)
} # end function
