
###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 23 September 2025
# 
# main_output.R
# 
# This script is the master file to get all results for Main.run. Run this
# script ONLY AFTER main.R have all been run through.
#
# used for which run: Main.run
#
# this script is called by any other scripts: null
#
# this script calls other scripts:
# 01. source_BasicSetup.R
# 02. source_DirectorySetup.R
# 04. source_DataSetup.R
# 05. jags_setupMCMC.R
# 06. jags_ConvergenceCheck.R
# 07. construct_logPselect.R
# 08. construct_CountryList_PastInflation.R
# 09. construct_countryCIs.R
# 10. plot_lineseg_SRB_allstates.R
# 11. plot_countrySRB&TFR.R
# 12. plot_countrySRB&AMFB.R
# 13. plot_SRB_map.R"
# 14. construct_cumsumMissingFemaleBirth.R
# 15. construct_countryCIs_SaveResults(cqt).R
# 16. construct_countryCIs_CountryTrajectories.R
# 17. plot_countryCIandData(NOimpute).R
#
# functions called: function(2) means the function is called twice in this
# script. Those functions called in the scripts listed above are not listed.
# ReadJagsOutput(1)
#
# input data in folder data/:
# 1. interim/database_for_modeling_2020-03-30.csv - SR data base;
#                                      created by source_dataCleaning (main.R)
#
# 2. output/M4/temp.JAGSobjects/* - read in stepwise JAGS output
#
# output data in folder data/output/M4/
# 1. selectP_M4.rda  - the estimated probabilities of SRB inflation 
#                      for each country or region based on the Bayesian model outputs.
# 2. cis_M4.rda   - the region median with 90% CI in orderto get other tables and plots.
# 3. cis_M4_CumsumMissing.rda  - the number of missing female
# 4. mcmc.array_M4.rda  - MCMC array
# Note: only the main output data are listed here since it is a master script.
# The above output data may be created in other scripts which are called in
# this script.
#################################################################################
## Master code file ##
## This run is to get normal level of SRB only!!!

rm(list = objects())

projname <- "SRB_India" # name for this project
runname  <- "M4" # name for this run/model; based on M6c_new_full_reg

First.run <- FALSE # construct mcmcarray and output?
CleanData <- FALSE # only do once to avoid problems with sorting differences
DoMCMC    <- FALSE  # get step-wise JAGS output?

workdir <- "Your own working dictionary"

setwd(file.path(workdir, projname))

# setup directories
source("code/source_DirectorySetup.R")

# setup constants, functions, libraries
source("code/source_BasicSetup.R")

# read in cleaned SRB database
dataset <- read.csv(paste0(interim.dir, srb.filename),
                    header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
dataset <- dataset[dataset$Inclusion, ]
dim(dataset) #1120   28


## When modle is to get normal SRB, use ALL data from non-Aisian, and 
## data with reference date BEFORE 1970 for Asian countries.
adj.year <- 1970.5 # no adjustment before 1980

source(paste0("code/", runname, "/source_DataSetup.R"))

# setup MCMC settings
source(paste0("code/", runname, "/jags_setupMCMC.R"))


## PART 1 - construct MCMC array (primary results) ##
## step 1: read in MCMC step-chains and get MCMC array as a whole
mcmc.array <- ReadJagsOutput(
  start.step = 1,
  n.steps = N.STEPS,
  maxiter = 10000,
  ChainNums = ChainIDs, # read in totall number of chains!
  runname = runname, output.dir = output.dir
)
save(mcmc.array, file = paste0(output.dir, "mcmc.array_", runname, ".rda"))

## step 2: check model convergency
load(paste0(output.dir, "mcmc.array_", runname, ".rda")) #mcmc.array
L <- dim(mcmc.array)[1] * dim(mcmc.array)[2]; L

## convergence check ##
source(paste0("code/", runname, "/jags_ConvergenceCheck.R"))

## reconstruct all logP.ct's ##
source(paste0("code/", runname, "/construct_logPselect.R"))
## get country-specific R, P first!
source(paste0("code/", runname, "/construct_countryCIs.R"))

save(selectP, file = paste0(output.dir, "selectP_", runname, ".rda"))
save(res.full, file = paste0(output.dir, "cis_", runname, ".rda"))

load(file = paste0(output.dir, "selectP_", runname, ".rda")) #selectP
load(file = paste0(output.dir, "cis_", runname, ".rda")) #res.full


# save country-specific trajectory
source(paste0("code/", runname, "/construct_countryCIs_CountryTrajectories.R"))
# get World and Regional results
source(paste0("code/", runname, "/construct_countryCIs_SaveResults(cqt).R"))
# get cummulative number of missing female births for world and region
source(paste0("code/", runname, "/construct_cumsumMissingFemaleBirth.R"))
# identify India states with significant missing female births
source(paste0("code/", runname, "/construct_CountryList_PastInflation.R"))

## read in estimates
load(file = paste0(output.dir, "cis_full_", runname, ".rda")) #res.full
load(file = paste0(output.dir, "cis_", runname, "_CumsumMissing.rda")) #res.missing.CI


# read in posterior info
adj.info <- read.csv(paste0(output.dir, runname, "_postinfo.csv"), row.names = 1)


# ## plot estimates and CIs for countries ##
# source(paste0("code/", runname, "/plot_countryCIandData(NOimpute).R"))

## plot outlying countries ##
source(paste0("code/", runname, "/plot_lineseg_SRB_allstates.R"))

## plot the relation between inflation adjustment and TFR
# highlight years when TFR is 3 and 2.1, and starting year of SRB inflation.
source(paste0("code/", runname, "/plot_countrySRB&TFR.R"))
source(paste0("code/", runname, "/plot_countrySRB&AMFB.R"))

## India map for SRB
source(paste0("code/", runname, "/plot_SRB_map.R"))

## The End! ##
