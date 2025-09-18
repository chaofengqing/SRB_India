

###############################################################################
# SRB project
#
###############################################################################

## construct empty arrays and metrics and assign dimention names ##
array.cqt <- array(0, c(C, Per, Tend))
array.clt <- array(0, c(C, L,   Tend))

dimnames(array.cqt)[[2]] <- percentiles

dimnames(array.cqt)[[3]] <- dimnames(array.clt)[[3]] <- floor(years.t)

dimnames(array.cqt)[[1]] <- dimnames(array.clt)[[1]] <- name.c

###########
## state ##
Bf.cqt <- Bm.cqt <-
  expBf.cqt <-
  misBf.cqt <-
  R.cqt <- P.cqt <- N.cqt <- array.cqt

R.clt <- array.clt

#########################
## get country results ##
for (c in 1:C) {
  cat(c, "in", C, "\n")
    
  # read in country-specific trajectory
  load(file = paste0(countryTraj.dir, "trajectory_", runname,
                     "_", code.c[c], "_full.rda")) #res.c.full
  
  ## get country-specific results ##
  R.cqt[c, , ] <- SamplesToUI(res.c.full[["R.lt"]])
  P.cqt[c, , ] <- SamplesToUI(res.c.full[["P.lt"]])
  N.cqt[c, , ] <- SamplesToUI(res.c.full[["N.lt"]])
  Bf.cqt[c, , ] <- SamplesToUI(res.c.full[["Bf.lt"]])
  Bm.cqt[c, , ] <- SamplesToUI(res.c.full[["Bm.lt"]])
  expBf.cqt[c, , ] <- SamplesToUI(res.c.full[["Bexpf.lt"]])
  misBf.cqt[c, , ] <- SamplesToUI(res.c.full[["Bmisf.lt"]])
}#end of c loop

res.full <- list(R.cqt = R.cqt, P.cqt = P.cqt, N.cqt = N.cqt,
                 Bf.cqt = Bf.cqt, Bm.cqt  = Bm.cqt,
                 expBf.cqt = expBf.cqt,
                 misBf.cqt = misBf.cqt)

save(res.full, file = paste(output.dir, "cis_full_", runname, ".rda", sep = ""))


##########################
## save R.ct trajectory ##
for (c in 1:C) {
  print(c)
  # read in country-specific trajectory
  load(file = paste0(countryTraj.dir, "trajectory_", runname,
                     "_", code.c[c], "_full.rda")) #res.c.full
  
  R.clt[c, , ] <- res.c.full[["R.lt"]]
}#end of c loop

res.Rtrajectory <- list(R.clt = R.clt)

save(res.Rtrajectory, file = paste0(output.dir, "trajectory_", runname, "_R.rda"))

## the end ##


