

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
