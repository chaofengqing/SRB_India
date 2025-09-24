###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
# 
# StandardizeSignifDigit.R
# 
# This script contains function which rounds an input number to 
# match the number of significant digits of a reference number.
#
# Functions are: function1(.., function2(3), ..); means function2 is called
# three times inside function1.
#
# StandardizeSignifDigit(..)
#
#
###############################################################################
#------------------------------------------------------------------------------

StandardizeSignifDigit <- function (
  number.in, # input number that you want to standardize
  number.ref # standardize the number.in to have the same number of significant
  # digits as number.ref.
) {
  ## make number.in to have the same number of significant digits as number.ref
  for (power in c(5:1)) {
    if (number.ref %% 10^power == 0) {
      break
    } else {
      power <- 0
    }
  }#end of power loop
  
  number.out <- round(number.in / 10^power) * 10^power
  
  return(number.out)
  
}#end of StandardizeSignifDigit function

