###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
#
# SamplesToUI.R
# 
# This script contains function related to computing specified percentiles 
# from posterior samples.
#
# Functions are: function1(.., function2(3), ..); means function2 is called
# three times inside function1.
#
# SamplesToUI(..)
#
#
###############################################################################
#------------------------------------------------------------------------------

SamplesToUI <- function (
  samples.jt, # inputs, note that it also works for samples.j
  NA.jt = 0, # indicate which entries should be set to NA. If NULL, it's not used.
  percentile.q = percentiles # output percentiles for input
) {
  # output: result.qt
  
  if (is.vector(samples.jt)) {
    result.qt <- quantile(samples.jt + NA.jt, probs = percentile.q, na.rm = TRUE)
  }
  if (is.matrix(samples.jt)) {
    result.qt <- apply(samples.jt + NA.jt, 2, quantile, percentile.q, na.rm = TRUE)
  }
  
  return (result.qt)
  
}#end of SamplesToUI function

