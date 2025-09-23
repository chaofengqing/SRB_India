###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 23 September 2025
# construct_countryCIs.R
# 
# This script saves country-specific results: sex ratio (estimated and expected),
# and P multiplier.
#
# used for which run: Main.run
# note: For Main.run, this script is sourced after constructing adjustment factors 
# and identifying countries with past/ongoing SRB inflation. 
#
#
# this script is called by any other scripts: main_output.R
#
# this script calls other scripts: null
#
# functions called: function(2) means the function is called twice in this
# script. Those functions called in the scripts listed above are not listed.
# SamplesToUI(3)
# 
# input data: null
#
# output data: null
#
# note the indices in the output R object:
# *.jqt - country related; 
# 
###############################################################################
array.cqt                <- array(NA, c(C, Per, Tend))
array.qt                 <- matrix(NA, nr = Per, nc = Tend)
dimnames(array.cqt)[[1]] <- name.c
dimnames(array.cqt)[[2]] <- dimnames(array.qt)[[1]] <- percentiles
dimnames(array.cqt)[[3]] <- dimnames(array.qt)[[2]] <- floor(years.t)

R.cqt <- P.cqt <- N.cqt <- array.cqt

for (c in 1:C) {
  cat(c, "/", C, "\n")
  select.reg <- 1 # which(region.r == reg.c[c])
  
  R.lt <- P.lt <- matrix(NA, L, Tend)
  N.l  <- exp(c(mcmc.array[, , "logN"]))
  
  for (t in 1:Tend) {
    P.lt[, t] <- exp(c(selectP[["logP.ctl"]][c, t, ]))    
    R.lt[, t] <- P.lt[, t] * N.l
    N.cqt[c, , t] <- SamplesToUI(N.l)
  }# end of t loop
  
  R.cqt[c, , ] <- SamplesToUI(R.lt)
  P.cqt[c, , ] <- SamplesToUI(P.lt)
}#end of j loop

res.full <- list(R.cqt = R.cqt,
                 P.cqt = P.cqt,
                 N.cqt = N.cqt)



## the end ##

