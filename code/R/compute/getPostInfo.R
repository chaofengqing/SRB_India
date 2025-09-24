###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
#
# getPostInfo.R
# 
# This script contains function which extracts posterior summaries (percentiles and R-hat) 
# for all parameters from an MCMC array.
#
# Functions are: function1(.., function2(3), ..); means function2 is called
# three times inside function1.
#
# getPostInfo(..)
#
#
###############################################################################
#------------------------------------------------------------------------------

getPostInfo <- function(
  mcmc.array,
  percentile.p = percentiles) {
  
  ## compute R hat and median & CI for post for all para ##
  Rhat      <- Rhat(mcmc.array)
  Per       <- length(percentile.p)
  POST.INFO <- matrix(NA, nr = dim(mcmc.array)[3], nc = Per)
  for (i in 1:dim(mcmc.array)[3]) {
    post <- c(mcmc.array[, , i])
    POST.INFO[i, ] <- quantile(post, probs = percentile.p)
  }#end of i loop
  
  post.full <- cbind(POST.INFO, Rhat)
  
  # order the output from largest to smallest Rhat values
  order.para <- order(Rhat, decreasing = TRUE)
  post.full <- post.full[order.para, ]
  
  # column to show the perentiles of Rhat value
  Percentile.Rhat <- rep(NA, dim(post.full)[1])
  for (i in 1:dim(post.full)[1]) {
    Percentile.Rhat[i] <- mean(post.full[i, "Rhat"] <= Rhat,
                               na.rm = TRUE) * 100
  }#end of i loop
  
  post.full <- cbind(post.full, Percentile.Rhat)
  dimnames(post.full)[[2]] <- c(paste(percentile.p * 100, "percentile"),
                                "Rhat (descending)",
                                "Percentile.Rhat (100%)")  
  return(post.full)
}#end of getPostInfo function

