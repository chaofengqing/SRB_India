
##############################################################################
# Levels and trends in the sex ratio at birth and missing female births for 29 states 
# and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 22 September 2025
#
# source_DirectorySetup.R
#
# This script creates and assign all directories used in this project.
#
# used for which run: Main.run
#
# this script is called by any other scripts: main.R
#
# this script calls other scripts: null
# functions called:                null
# input data:                      null
# output data:                     null
#
# Folders that you need to create by yourself before you start this project:
# project folder: SRB_India/
# input data folder: SRB_India/data/input/
# output data folder: SRB_India/data/output
#
#
# Folders that will be created after running this script for a certain run:
# 1. SRB_India/data/interim/
# 2. SRB_India/data/output/; and its subfolders
# 3. SRB_India/fig/; and its subfolders
#
## setup directory for data cleaning ##
#######################################

# aux.data.dir <- "data/input/Auxdata/"

## subfolder for intermediate data ##
input.dir <- "data/input/"
interim.dir <- "data/interim/"
dir.create("data/interim/", showWarnings = FALSE)

#############################################
## setup directory for modeling and output ##
if (!CleanData) {
  ## data-related ##
  output.dir      <- paste0("data/output/", runname, "/")
  jagsStep.dir    <- paste0(output.dir, "temp.JAGSobjects/") # to save step-wise JAGS output
  countryTraj.dir <- paste0(output.dir, "countryTrajectory/")
  
  ## figure-related ##
  fig.dir          <- paste0("fig/", runname, "/") # root directory for all plots
  convergeplot.dir <- paste0(fig.dir, "convergence/") # convergence plots
  
  ####################
  ## create folders ##
  if (First.run) {
    
    ## output data folderss ##
    dir.create("data/output", showWarnings = FALSE)
    dir.create(output.dir, showWarnings = FALSE)
    dir.create(jagsStep.dir, showWarnings = FALSE)
    dir.create(countryTraj.dir, showWarnings = FALSE)
    
    ## figure folders ##
    dir.create("fig", showWarnings = FALSE)
    dir.create(fig.dir, showWarnings = FALSE)
    dir.create(convergeplot.dir, showWarnings = FALSE)
    
  }#end of if (First.run)
  
}#end of if(!CleanData)

## the end ##



