###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 24 September 2025
# 
# InternalStandardizeIndiaStateName.R
# 
# This script contains all functions related to shortening India's region name.
# Functions are: function1(.., function2(3), ..); means function2 is called
# three times inside function1.
# InternalStandardizeNepalDevRegName(..)
###############################################################################
#------------------------------------------------------------------------------

InternalStandardizeIndiaStateName <- function(name.in) {
  
  ## Shorten India state names (and make consistent) ##
  name.in <- ifelse(name.in == "ArunachalPradesh", "Arunachal Pradesh", paste(name.in))
  name.in <- ifelse(name.in == "Jammu & Kashmir", "Jammu and Kashmir", paste(name.in))
  name.in <- ifelse(name.in == "Maharshtra", "Maharashtra", paste(name.in))
  name.in <- ifelse(name.in == "NCT of Delhi" | name.in == "Nct Of Delhi" |
                      name.in == "nct of delhi", "Delhi", paste(name.in))
  name.in <- ifelse(name.in == "Odisha", "Orissa", paste(name.in))
  name.in <- ifelse(name.in == "Andhra Pradesh", "former state of Andhra Pradesh", paste(name.in))
  
  name.out <- name.in
  return(name.out)
}#end of InternalStandardizeIndiaStateName function
