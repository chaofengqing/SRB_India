###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
#
# plot_countrySRB&TFR.R
#
# This script plot the results containing SRB and TFR for all the countries
#
# used for which run: Main.run
#
# this script is called by any other scripts: main_output.R;
#
# this script calls other scripts: null
#
# functions called: function(2) means the function is called twice in this
# script. Those functions called in the scripts listed above are not listed.
# PlotCIbandwithDataseries(1)
#
# input data: null
# 
# output plots in folder fig/ :
# 1. CIs_SRB_India_state_M4_*

############################################
## plot the results for all the countries ##


pdf(paste0(fig.dir, "CIs_SRB_India_state_", runname, "_", Sys.Date(), ".pdf"),
    height = 13, width = 30)
text.cex <- 4.5
par(cex.lab = text.cex, cex.axis = text.cex, mgp = c(11, 3, 0), mar = c(6, 14, 8, 10.7),
    cex.main = 6, las = 1, tcl = -1)
for (c in 1:C) { #c in c.asia: now plot a subset of Asian countries
  country <- name.c[c]
  c.select <- which(name.i == country)
  # sort by survey date to get nicer legend
  select <- c.select[order(surveyplot.i[c.select])]
  
  R.qt <- res.full[["R.cqt"]][country, , ]
  N.qt <- res.full[["N.cqt"]][country, , ]
  plot.range <- range(R.qt, exp(logr.i[select]), na.rm = TRUE)
  par(las = 1)
  PlotCIbandwithDataseries(
    if.LogScale = TRUE, if.SurveyLegend = TRUE,
    dataseries = logr.i, dataseriesSE = logSEnoimpute.i, year.t = years.t,
    CI1s = R.qt, 
    CI2s = N.qt, 
    Source = surveyplot.i,
    baseSeries = "SRS", x.lim = range(round(years.t)),
    x = year.i, select.x = select,
    SElim = plot.range, datalim = plot.range,
    main = country, alpha.dataseries = 0.8,
    ylab = "Sex Ratio at Birth", xlab = "Year", cutoff = SRB0,  cex.dataseries = 2.5,
    lwd.CI1 = 15, lwd.CI2 = 10, lwd.dataseries = 3, colCI = c("red", "darkgreen"),
    cex.legend = 2, legendCI.posi = "bottomleft", legendSurvey.posi = "topleft")
  

  legend("topright", c("State-level SRB", "Country baseline"),
         col = c("red", "darkgreen"), lty = 1,
         lwd = 10, cex = 3)
}#end of c loop
dev.off()

## the end ##


