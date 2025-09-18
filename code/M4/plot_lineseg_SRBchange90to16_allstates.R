


load(file = paste0(output.dir, "trajectory_", runname, "_R.rda")) #res.Rtrajectory

yr.start <- c(1990, 2000)
yr.end <- c(2016, 2016)
order.of.year <- min(yr.end)

changeR.cqt <- array(0, c(C, Per, Tend))
dimnames(changeR.cqt)[[3]] <- paste(years.t)
for (j in 1:length(yr.start)) {
  changeR.cq <- t(apply(res.Rtrajectory$R.clt[, , paste(yr.end[j])] -
                          res.Rtrajectory$R.clt[, , paste(yr.start[j])],
                        1, quantile, percentiles, na.rm = TRUE))
  t <- which(years.t == yr.start[j] + 0.5)
  changeR.cqt[, , t] <- changeR.cq
  
}#end of j loop
text.cex <- 1.5
dot.cex <- 2.3

pdf(paste0(fig.dir, "SRBchange_all_states_", floor(order.of.year), "order.pdf"),
    height = 13, width = 10)
par(mar = c(4.5, 12.3, 0.5, 0.5), cex.lab = text.cex, mgp = c(3, 0.7, 0), 
    cex.main = text.cex, cex.axis = text.cex, tcl = -0.5)

select.c <- 1:C
select.t <- is.element(years.t, yr.start[1] + 0.5)
PlotCIsegments(
  countryName.c = name.c,
  cutoff = 0, order = 2, data.cqt = changeR.cqt,
  select.c = select.c,
  select.t = select.t,
  yearOrder = order.of.year,
  xlab = "Sex Ratio at Birth for India States", #main = "year 2017",
  colinfo = c("lightgrey", "hotpink4", "hotpink"), vertical.gap = 0.7,
  lwd.main = 5, lwd.cutoff = 1, cex = dot.cex,
  x.range = range(changeR.cqt, na.rm = TRUE), reset.xlim = TRUE)
box()
dev.off()



## the end ##

