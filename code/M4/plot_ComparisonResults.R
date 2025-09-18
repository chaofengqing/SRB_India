

## load results from two models
runname1 <- "M4"; plotrun1 <- "update"
runname2 <- "M4_for paper"; plotrun2 <- "paper"

load(file = paste0("data/output/", runname1, "/cis_full_", runname1, ".rda"))#res.full
res1 <- res.full

load(file = paste0("data/output/", runname2, "/cis_full_M4.rda"))#res.full
res2 <- res.full

pdf(paste0(fig.dir, plotrun1, "&", plotrun2, "_compare_SRB.pdf"),
    height = 13, width = 30)
text.cex <- 4.5
par(cex.lab = text.cex, cex.axis = text.cex, mgp = c(11, 3, 0), mar = c(6, 14, 8, 10.7),
    cex.main = 6, las = 1, tcl = -1)
for (c in 1:C) {
  country <- name.c[c]
  c.select <- which(name.i == country)
  # sort by survey date to get nicer legend
  select <- c.select[order(surveyplot.i[c.select])]
  
  c.res2 <- which(name.c[c] == dimnames(res2$R.cqt)[[1]])
  ratio.lim <- range(c(r.i[c.select],
                       res1[["R.cqt"]][c, , ],
                       res2[["R.cqt"]][c.res2, , ]), na.rm = TRUE)
  
  R_run1.qt <- res1[["R.cqt"]][c, , ]
  R_run2.qt <- res2[["R.cqt"]][c.res2, , ]
  plot.range <- range(R_run1.qt, R_run2.qt, exp(logr.i[select]), na.rm = TRUE)
  
  par(las = 1)
  PlotCIbandwithDataseries(
    if.LogScale = TRUE, if.SurveyLegend = TRUE,
    dataseries = logr.i, dataseriesSE = logSEnoimpute.i, year.t = years.t,
    CI1s = R_run1.qt, CI2s = R_run2.qt,
    Source = surveyplot.i,
    baseSeries = "SRS", x.lim = range(round(years.t)),
    x = year.i, select.x = select,
    SElim = plot.range, datalim = plot.range,
    main = country, alpha.dataseries = 0.8,
    ylab = "Sex Ratio at Birth", xlab = "Year", cutoff = SRB0,  cex.dataseries = 2.5,
    lwd.CI1 = 15, lwd.CI2 = 10, lwd.dataseries = 3, colCI = c("red", "blue"),
    cex.legend = 2, legendCI.posi = "bottomleft", legendSurvey.posi = "topleft")
  
  
  legend("topright", c(plotrun1, plotrun2), col = c("red", "blue"), lty = 1,
         lwd = 10, cex = 3)
}#end of c loop

dev.off()

## the end ##

