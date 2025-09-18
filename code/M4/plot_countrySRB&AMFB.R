

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
    CI1s = R.qt, #nameCI1 = "National SRB",
    CI2s = N.qt, #nameCI2 = "Regional norm",
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

