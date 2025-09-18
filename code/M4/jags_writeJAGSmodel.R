

###############################################################################

# JAGS may not work well on sum with many elements. So we split into several
# sums with fewer element within each sum.

# note: spaces in cat matter!
cat("

model {
    #############################
    ## data model on log-scale ##
    for (i in 1:I) {
    logr.i[i] ~ dnorm(logrhat.i[i], tau.i[i])
    logrhat.i[i] <- logN + logP.ct[c.i[i], t.i[i]]
    tau.i[i] <- 1 / (pow(sigma.s[source.i[i]], 2) + pow(logSE.i[i], 2))
    }#end of i loop
    
    logN ~ dnorm(log(N.mu), tau.N)

    ###############
    ## log(P.ct) ##
    for (c in 1:C) {
    
    logP.ct[c, min.t.c[c]] ~ dnorm(b.c[c], tau.eps.stat)

    for (t in (min.t.c[c] + 1):max.t.c[c]) {
    logP.ct[c, t] ~ dnorm(epshat.ct[c,t], tau.eps)
    epshat.ct[c,t] <- b.c[c] + rho * (logP.ct[c, t-1] - b.c[c])
    }#end of t loop

    b.c[c] ~ dt(0, tau.b, 3)
    }#end of c loop
    
    
    #########################
    ## non-sampling errors ##
    for (s in 1:(S - 1)) { 
    sigma.s[s] ~ dunif(pri.sigmas.lower, pri.sigmas.upper)
    }#end of s loop
    
    # for VR:
    sigma.s[S] <- 0
    
    
    ############
    ## priors ##
    # tau.eps.stat <- tau.eps * (1 - pow(rho, 2))
    # tau.N        <- pow(sigma.N, -2)
    # 
    # ## hyper parameters ##
    # sigma.eps   <- pow(tau.eps, -1/2)
    # sigma.b   <- pow(tau.b, -1/2)
    # rho       ~ dunif(pri.rho.lower, pri.rho.upper)
    # tau.eps   ~ dgamma(1, 1)
    # tau.b     ~ dgamma(1, 1)

    ## taus ##
    tau.eps.stat <- tau.eps * (1 - pow(rho, 2))
    tau.eps      <- pow(sigma.eps, -2)
    tau.b        <- pow(sigma.b, -2) 
    tau.N        <- pow(sigma.N, -2)

    ## hyper parameters ##
    rho       ~ dunif(pri.rho.lower, pri.rho.upper)
    sigma.eps ~ dunif(pri.sigma.eps.lower, pri.sigma.eps.upper)
    sigma.b   ~ dunif(pri.sigma.b.lower, pri.sigma.b.upper)

    }#end of model
    
    ",
    sep    = "",
    append = FALSE,
    file   = file.path(output.dir, JAGSmodel.name),
    fill   = TRUE
)


################
## JAGS NOTES ##
## 1. no empty entries are allowed on the LHS of equation or distribution:
##    not Y[,j], but Y[i,j]; RHS also better to specify.
## 2. cannot use the same expression in loop, i.e. not i <- i+1, must specify
##    to indicate different entries.
## 3. when writing for (i in A:B), B cannot be expression of the number,
##    e.g. given C is an integer, cannot specify B<-C+1 after the loop. need to
##    write as for (i in A:(C+1));
## 4. given T, cannot write sth like for(r in 1:T.c[j,c]) where
##    T.c[j,c]<-T[H[j,c]], should write as for(r in 1:T[cumsum.C[j]+c])
## 5. cannot specify a distribution on V.CI[j,1:C[j]], and then assign values
##    to V.CI[j, 1:C[j]]. Instead, you can include the observed V.CI[j,c]
##    directly as data input.
## 6. inverse() does not work for a single entry, but only for matrix in JAGS.
## 7. no cut() function in JAGS, use dsum()
## 8. cannot use data[ind.a, ind.b] to indicate double index,
##    should use data[ind[ind.a,ind.b]].
## 9. JAGS may not work well on sum with many elements. So we split into several
##    sums with fewer element within each sum.
##10. write for (i in A:B), instead of for (i in C) even if C is a numerical
##    vector.


## The End! ##

