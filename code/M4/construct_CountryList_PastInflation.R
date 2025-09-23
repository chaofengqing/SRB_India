###############################################################################
# Levels and trends in the sex ratio at birth and missing female births for 
# 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 22 September 2025
#
# construct_CountryList_PastInflation.R
# 
# This script identifies countries with past SRB inflation 
#
# used for which run: Main.run
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
## identify countries with past SRB inflation ##
adj.year <- 1970.5
adj.timeindex <- which(years.t == adj.year)
country.list.past.inflation <- NULL
max.prob.c <- min.prob.c <- rep(NA, C)
names(max.prob.c) <- name.c

count <- 0
for (c in 1:C) {

  # read in country-specific trajectory
  load(file = paste0(countryTraj.dir, "trajectory_", runname, "_", code.c[c], "_full.rda")) #res.c.full
  
  diff.ls <- res.c.full[["Bmisf.lt"]][, adj.timeindex:which(years.t == 2016.5)]
  
  diff.qs <- SamplesToUI(diff.ls)
  dimnames(diff.qs)[[2]] <- paste(floor(adj.year):2016)
  
  max.prob.c[c] <- max(apply(diff.ls > 0, 2, mean))
  
  check <- sum(diff.qs[1, ] > 0)
  
  if (check > 0) {
    count <- count + 1
    cat(count, name.c[c], check, "\n")
    country.list.past.inflation <- c(country.list.past.inflation, name.c[c])
  }#end of if
}#end of c loop


round(sort(max.prob.c * 100), 2)

save(max.prob.c, file = paste0(output.dir, "max.prob.c.rda"))
save(country.list.past.inflation, file = paste0(output.dir, "country.list.past.inflation.rda"))

## the end ##

