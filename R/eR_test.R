#' @title Function `eR_test`
#'
#' @description Function to test statistical diferences through parametric ANOVA, and posteriori HSD and Tukey tests
#' @author "SMandujanoR"
#'
#' @param Ymax Define maxime value of Y-axis
#' @param SaveFolder Directory to save plot
#'
#' @importFrom stringr str_to_title
#' @importFrom xtable xtable
#' @importFrom stats aov TukeyHSD summary.aov
#' @importFrom agricolae HSD.test bar.group
#'
#' @return Anova test and plots of posteriori test
#'
#' @examples
#' \dontrun{
#' eR_test(Ymax = 15, SaveFolder = "Results")
#' }
#'
#' @export
#'
eR_test <- function(Ymax, SaveFolder) {
  # Anova:
  table2 <- read.csv(file.path(SaveFolder, "/Table_eR_CTs.csv"), header = T)
  eRaov <- stats::aov(eRalt ~ Species - 1, data = table2)
  cat("----- \n eR comparasion among species \n")
  print(summary(eRaov))
  mod <- summary(eRaov)
  anova <- xtable::xtable(mod)
  write.csv(anova, paste(stringr::str_to_title(SaveFolder), "/Table_ANOVA.csv", sep = ""))

  # Posterior comparison:
  P <- as.numeric(unlist(summary.aov(eRaov)[[1]][5]))[1]
  ifelse(P < 0.05,
    { # if P significative then:

      # Tukey test:
      miPlot_1 <- plot(stats::TukeyHSD(eRaov), cex.axis = 0.5, las = 1)

      dev.copy(jpeg, filename = file.path(SaveFolder, "HSD_test.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
      dev.off()

      # HSD test:
      out_1 <- agricolae::HSD.test(eRaov, "Species")
      out2 <- out_1$groups

      miPlot_2 <- agricolae::bar.group(out_1$groups, horiz = F, las = 2, cex.main = 2, font = 1, cex.axis = 0.9, plot = T, col = "lightblue", ylim = c(0, Ymax), names.arg = out_1$trt, ylab = "Encounter rate")

      dev.copy(jpeg, filename = file.path(SaveFolder, "HSD_test.jpg"), width = 8000, height = 7000, units = "px", res = 1200)
      dev.off()
    },
    NA
  ) # if P not significant

  return(list(anova, miPlot_1, miPlot_2))
} # end function
