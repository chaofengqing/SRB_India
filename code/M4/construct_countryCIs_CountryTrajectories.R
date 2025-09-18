


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
