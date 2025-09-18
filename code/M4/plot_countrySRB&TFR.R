

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
    CI1s = R.qt, #nameCI1 = "National SRB",
    CI2s = N.qt, #nameCI2 = "Regional norm",
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

