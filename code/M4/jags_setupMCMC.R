


# for a median test, overwrite MCMC settings
mcmc.chains    <- 20
ChainIDs       <- seq(1, mcmc.chains) 
mcmc.burnin    <- 10000 #* 2
N.STEPS        <- 100
n.iter.perstep <- 100 #* 2
mcmc.thin      <- 2


###################
# write JAGS model (jags_writeJAGSmodel.R)
NoTermPerLine <- 2 #shorten the length of long summition to seperate lines

# JAGS parameter priors
pri.rho.lower <- 0
pri.rho.upper <- 1

pri.sigma.eps.lower <- 0
pri.sigma.eps.upper <- 0.01

pri.sigmas.lower <- 0
pri.sigmas.upper <- 2

pri.sigma.b.lower <- 0
pri.sigma.b.upper <- 0.02


global.info <- read.csv(paste0(input.dir, "M57_normal_postinfo.csv"), row.names = 1)
N.mu <- global.info["a.c[87]", "X50.percentile"] #India national baseline
sigma.N <- 0.002

##########
## part 1: assign sequence of ChainIDs based on runID
# ChainIDs <- (runID - 1) * mcmc.chains + seq(1, mcmc.chains) # number of chains for aech script


## get the most recent time index with data for each country
max.t.c <- min.t.c <- rep(NA, C)
for (c in 1:C) {
  # the earliest time index with data;
  # or time index for the year 1950, whichever is smaller
  min.t.c[c] <- gett.cz[c, 1]
  # the most rescent time index with data
  max.t.c[c] <- gett.cz[c, nt.c[c]]
}#end of c loop


##########
## part 2: specify parameters to be saved for JAGS output, i.e. MCMC array
hyper.para <- c("sigma.eps", "rho", "sigma.b", "logN")

para.b.c <- paste0("b.c[", 1:C, "]")
para.sigmas <- paste0("sigma.s[", seq(1, S - 1), "]")

paraP <- NULL
for (c in 1:C) {
  ## from 1950 or the earliest year with data (whichever is earlier) to the most recent
  ## year with data
  paraP <- c(paraP, paste0("logP.ct[", c, ",", min.t.c[c]:max.t.c[c], "]"))
}#end of c loop

mort.parameters <- c(paraP, para.b.c, para.sigmas,
                     hyper.para)

##########
## part 3: specify input data for JAGS model
mort.data <- c(
  list(
    # prior info
    pri.rho.lower = pri.rho.lower,
    pri.rho.upper = pri.rho.upper,
    
    pri.sigma.eps.lower = pri.sigma.eps.lower,
    pri.sigma.eps.upper = pri.sigma.eps.upper,
    
    pri.sigmas.lower = pri.sigmas.lower,
    pri.sigmas.upper = pri.sigmas.upper,
    
    pri.sigma.b.lower = pri.sigma.b.lower,
    pri.sigma.b.upper = pri.sigma.b.upper
  ),
  
  list(t.i = t.i,
       c.i = c.i,
       min.t.c = min.t.c,
       max.t.c = max.t.c,
       I = I, C = C,
       S = S, Tend = Tend,
       source.i = source.i,
       logr.i = logr.i,
       logSE.i = logSE.i,
       N.mu = N.mu,
       sigma.N = sigma.N
  )
)


##########
## part 5: write out JAGS model in txt format
JAGSmodel.name <- paste0(runname, ".txt")
if (First.run) source(paste0("code/", runname, "/jags_writeJAGSmodel.R"))

## The End! ##
