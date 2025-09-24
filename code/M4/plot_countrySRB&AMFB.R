###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
#
# plot_countrySRB&AMFB.R
# 
# This script plots the results for all the countries
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
# output plots in folder fig/: 
# 1.CIs_SRBandAMFB_India_state_M4_*.pdf - compares SRB in 2016, 2000, and 1990
#
###############################################################################

############################################
## plot the results for all the countries ##
plot.year <- c(years.t[1]:2016.5)

pdf(paste0(fig.dir, "CIs_SRBandAMFB_India_state_", runname, "_", Sys.Date(), ".pdf"),
    height = 13, width = 30)
text.cex <- 3
par(mfrow = c(1, 2), cex.lab = text.cex, cex.axis = text.cex, mar = c(3, 12, 5, 1),
    las = 1, tcl = -1)
for (c in 1:C) { #c in c.asia: now plot a subset of Asian countries
  country <- name.c[c]
  c.select <- which(name.i == country)
  # sort by survey date to get nicer legend
  select <- c.select[order(surveyplot.i[c.select])]
  
  R.qt <- res.full[["R.cqt"]][country, , paste(plot.year-0.5)]
  N.qt <- res.full[["N.cqt"]][country, , paste(plot.year-0.5)]
  plot.range <- range(R.qt, exp(logr.i[select]), na.rm = TRUE)
  par(las = 1, mgp = c(8, 2, 0))
  PlotCIbandwithDataseries(
    if.LogScale = TRUE, if.SurveyLegend = TRUE, if.xlimFix = TRUE,
    dataseries = logr.i, dataseriesSE = logSEnoimpute.i, year.t = plot.year,
    CI1s = R.qt, 
    CI2s = N.qt, 
    Source = surveyplot.i,
    baseSeries = "SRS", x.lim = range(plot.year-0.5),
    x = year.i, select.x = select,
    SElim = plot.range, datalim = plot.range,
    main = "", alpha.dataseries = 0.8,
    ylab = "Sex Ratio at Birth", xlab = "Year", cutoff = SRB0,  cex.dataseries = 2.5,
    lwd.CI1 = 15, lwd.CI2 = 10, lwd.dataseries = 3, colCI = c("red", "darkgreen"),
    cex.legend = 2, legendCI.posi = "bottomleft", legendSurvey.posi = "topleft")
  legend("bottomleft", c("State-level SRB", "Country norm"),
         col = c("red", "darkgreen"), lty = 1, lwd = 10, cex = 2)
  
  misBf.qt <- res.full$misBf.cqt[name.c[c], , paste(plot.year-0.5)] / 1000
  par(mgp = c(6, 2, 0))
  PlotCIbandwithDataseries(
    if.xlimFix = TRUE,
    datalim = range(misBf.qt), SElim = range(misBf.qt),
    CI1s = misBf.qt,  x.lim = range(plot.year-0.5),
    main = "", alpha.estCI = 0.2,
    year.t = plot.year, x = plot.year,
    ylab = "Annual Number of\nMissing Female Births (in thousands)", lwd.CI1 = 10,
    xlab = "Year", cutoff = 0, colCI = "navyblue")
  
  title(main = country, outer = TRUE, line = -3, cex.main = 4)
}#end of c loop
dev.off()

## the end ##


