



years.select <- c(2016, 1990) + 0.5
t.select <- which(is.element(years.t, years.select))

order.of.year <- max(years.select)
text.cex <- 1.5
dot.cex <- 2.1

pdf(paste0(fig.dir, "SRB_all_states_", floor(order.of.year), "order.pdf"),
    height = 14, width = 9)
par(mar = c(4.5, 12.3, 0.5, 0.5), cex.lab = text.cex, mgp = c(3, 0.7, 0), 
    cex.main = text.cex, cex.axis = text.cex, tcl = -0.5)
R.cqt <- res.full$R.cqt

select.t <- is.element(years.t, years.select)
select.c <- 1:C
PlotCIsegments(
  countryName.c = c(name.c),
  cutoff = 0, order = 2, data.cqt = R.cqt,
  select.c = select.c, select.t = select.t, yearOrder = order.of.year,
  xlab = "Sex Ratio at Birth", #main = "year 2017",
  colinfo = c("lightgrey", "hotpink4", "hotpink"), vertical.gap = 0.7,
  lwd.main = 4, lwd.cutoff = 1, cex = dot.cex,
  x.range = range(R.cqt), reset.xlim = TRUE)
abline(v = N.mu, col = "grey")
legend("bottomright", c("1990", "2016"), col = c("hotpink", "hotpink4"),
       lty = 1, lwd = 4, pch = 19, cex = text.cex, bg = "white")
box()
dev.off()


## the end ##

