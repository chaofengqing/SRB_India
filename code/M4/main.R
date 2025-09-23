###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 23 September 2025
#
# main.R
# 
# This script is the master file to get MCMC array for Main.run. Run this
# script to get reulsts.
#
# used for which run: main.run
#
# this script is called by any other scripts: null
#
# this script calls other scripts:
# 1. source_BasicSetup.R
# 2. source_DirectorySetup.R
# 3. source_DataSetup.R 
# 4. jags_setupMCMC.R
# 5. jags_getMCMC.R
#
# functions called: Null
# 
# input data: data/interim/database_for_modeling_2020-03-30.csv
#
# output data:
# data/output/M4/temp.JAGSobjects/  - stepwise JAGS trajectory output
# Note: only the main output data are listed here since it is a master script.
#
###############################################################################

## Master code file ##
## This run is to get normal level of SRB only!!!

rm(list = objects())

projname <- "SRB_India" # name for this project
runname  <- "M4" # name for this run/model; based on M6c_new_full_reg
glb.normal.runname <- "M53test1_normal"
glb.adj.runname <- "M53test1_adj_edu"

First.run <- TRUE # construct mcmcarray and output?
CleanData <- FALSE # only do once to avoid problems with sorting differences
DoMCMC    <- TRUE  # get step-wise JAGS output?

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
dim(dataset) #1046   28


## When modle is to get normal SRB, use ALL data from non-Aisian, and 
## data with reference date BEFORE 1970 for Asian countries.
adj.year <- 1970.5 # no adjustment before 1980


source(paste0("code/", runname, "/source_DataSetup.R"))

# setup MCMC settings
source(paste0("code/", runname, "/jags_setupMCMC.R"))


## STOP HERE FOR JAGS ##
if (DoMCMC) {
  source(paste0("code/", runname, "/jags_getMCMC.R"))
}  

## The End! ##
