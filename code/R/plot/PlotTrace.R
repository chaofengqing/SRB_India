###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
# PlotTrace.R
# 
# This script contains function relating to the trace plot for one parameter 
# and adding loess smoother for each chain.
#
# Functions are: function1(.., function2(3), ..); means function2 is called
# three times inside function1.
#
# PlotTrace(..)
#
###############################################################################

PlotTrace <- function(#Traceplot for one parameter
  ## Trace plot for one parameter and add loess smoother for each chain ##
  parname, mcmc.array,##<< needs to be 3-dimensional array!
  n.chains = NULL, n.sim = NULL, main = NULL){
  if (is.null(main)) main <- parname
  if (is.null(n.sim)) n.sim <- dim(mcmc.array)[1]
  if (is.null(n.chains)) n.chains <- dim(mcmc.array)[2]
  plot(c(mcmc.array[, 1, parname]), type = "l", ylab = parname,  main = main,
       #        ylim = c(min(mcmc.array[,,parname]),max(mcmc.array[,,parname]))
       ylim = range(c(mcmc.array[, , parname]), na.rm = TRUE))
  for (chain in 1:n.chains) {
    lines(c(mcmc.array[, chain, parname]), type = "l", col = chain)
  }
  for (chain in 1:n.chains) {
    curve(predict(loess(c(mcmc.array[, chain, parname]) ~ seq(1, n.sim)), x), 
          lty = 2, lwd = 3, add = TRUE, type = "l", col = chain)
  }
  
}#end of PlotTrace function

