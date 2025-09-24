###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
# 
# StandardizeDecimal.R
# 
# This script contains function related to making number.in to round to n.round. 
#
# Functions are: function1(.., function2(3), ..); means function2 is called
# three times inside function1.
#
# StandardizeDecimal(..)
#
#
###############################################################################
#------------------------------------------------------------------------------

StandardizeDecimal <- function(
  number.in,
  n.round) {
  ## make number.in to round to n.round. If resulting number has decimal places
  # smaller than rounded number, add 0 behind. E.g. round(1.999, 2) to be 2.00
  # instead of 2
  number.out <- format(as.numeric(round(number.in, n.round)), nsmall = n.round)
  
  return(number.out)
}#end of StandardizeDecimal()

