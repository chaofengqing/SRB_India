###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 23 September 2025
# 
# construct_logPselect.R
# 
# This script is to get trajectories for logP's for each year of the full
# observation period. In JAGS model, we only save those non-missing logP's.
#
# used for which run: main.run
#
# this script is called by any other scripts: main_output.R
#
# this script calls other scripts: null
#
# functions called: null
# 
# input data: null
#
# output data: null
#
###############################################################################

# note: here l refers to posterior sample
rho.l    <- c(mcmc.array[, , "rho"])
sigma.l  <- c(mcmc.array[, , "sigma.eps"])
logP.ctl <- array(NA, c(C, Tend, L))

for (c in 1:C) {
  set.seed(c*123)
  cat(c, "/", C, "\n")

  t.min <- min.t.c[c]
  t.max <- max.t.c[c]
  
  b.l <- c(mcmc.array[, , paste0("b.c[", c, "]")])
  
  for (t in t.min:t.max) {
    logP.ctl[c, t, ] <- c(mcmc.array[, , paste0("logP.ct[", c, ",", t, "]")])
  }#end of t loop
  
  for (t in (t.min - 1):1) {
    mean.l <- rho.l * (logP.ctl[c, t+1, ] - b.l) + b.l
    logP.ctl[c, t, ] <- rnorm(n = L, mean = mean.l, sd = sigma.l)
  }#end of t loop
  
  for (t in (t.max+1):Tend) {
    mean.l <- rho.l * (logP.ctl[c, t-1, ] - b.l) + b.l
    logP.ctl[c, t, ] <- rnorm(n = L, mean = mean.l, sd = sigma.l)
  }#end of t loop
}#end of c loop

selectP <- list(logP.ctl = logP.ctl)

## the end ##


