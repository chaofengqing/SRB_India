##############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 23 September 2025
# construct_countryCIs_CountryTrajectories.R
# 
# This script uses Bayesian posterior samples to estimate state - level sex ratios at 
# birth and missing female births (1990-2016), then saves the full trajectories 
# for each state.
#
# used for which run: main.run
#
# this script is called by any other scripts: main_output.R
#
# this script calls other scripts: null
#
# functions called: function(2) means the function is called twice in this
# script. Those functions called in the scripts listed above are not listed.
# GetSexSpecificBirthfromAllandSRB(1)
# 
# input data: data/interim/birth.ct.rda
#
# output data: 
# data/output/countryTrajectory/trajectory_M3_*_full.rda 
#
###############################################################################
load(file = paste0(interim.dir, "birth.ct.rda")) #birth.ct

dim(birth.ct) # 29 93
summary(c(birth.ct))
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 3345   54007  475896  754974 1096635 5559560 


for (c in 1:C) {
  cat(c, "/", C, "computing:", name.c[c], "\n")
  
  P.lt <- R.lt <- N.lt <- matrix(NA, L, Tend)

  for (t in 1:Tend) {
    P.lt[, t] <- exp(c(selectP[["logP.ctl"]][c, t, ]))
    N.lt[, t] <- exp(c(mcmc.array[, , "logN"]))
    R.lt[, t] <- P.lt[, t] * N.lt[, t] # with inflation due to sex-seletive abortion
  }# end of t loop
  
  
  ##############################
  ## get sex-specific RESULTS ##
  bhatF.lt <-  #estimated female birth - use R
    bhatM.lt <-  #estimated male birth - use R
    bexpF.lt  <- #expected female birth - use R.noadj
    bmisF.lt <- #missing female birth: expected - estimated

    matrix(NA, L, Tend)
  
  for (t in 1:Tend) {
    ## estimated male & female birth - use R ##
    birth.est <- GetSexSpecificBirthfromAllandSRB(
      b.all = birth.ct[name.c[c], t], srb = R.lt[, t])
    bhatF.lt[, t] <- bhatF.l <- birth.est[["b.female"]]
    bhatM.lt[, t] <- bhatM.l <- birth.est[["b.male"  ]]
    
    ## expected female birth - use N.l ##
    bexpF.lt[, t] <- bexpF.l <- bhatM.l / N.l
  }#end of t loop
  
  ## missing female birth: expected - estimated ##
  bmisF.lt <- bexpF.lt - bhatF.lt

  ## save country specific results ##
  res.c.both <- list(code = code.c, name = name.c[c],
                     R.lt = R.lt, P.lt = P.lt, N.lt = N.lt)
  
  res.c.bySex <- list(Bf.lt = bhatF.lt, #estimated female birth
                      Bm.lt = bhatM.lt, #estimated male birth
                      Bexpf.lt = bexpF.lt, #expected female birth
                      Bmisf.lt = bmisF.lt #missing female birth
  )
  
  res.c.full <- c(res.c.both, res.c.bySex)
  save(res.c.full,
       file = paste0(countryTraj.dir, "trajectory_", runname, "_", code.c[c], "_full.rda"))
  
}#end of c loop

## the end! ##

